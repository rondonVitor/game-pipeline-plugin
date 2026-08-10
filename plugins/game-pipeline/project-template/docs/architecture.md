# Arquitetura do Aplicativo

> Padrão canônico de TODO projeto criado por este pipeline (origem: runner_clash). **Toda feature segue este documento.** App offline-first: onde o padrão original fala de rede/HTTP/token, aqui se aplica persistência local — o resto vale igual. Se o jogo usar Flame, o game-loop vive na `view/` da feature e conversa com o `domain/` via ViewModel; menus, progressão, loja e meta seguem MVVM normalmente.

## Visão Geral

Clean Architecture orientada a features. Separa responsabilidades, facilita testes e permite evolução. Cada feature é um módulo independente com suas camadas.

## Estrutura de Pastas

```
lib/
├── core/                   # componentes compartilhados em toda a aplicação
├── design_system/          # tokens, tema, componentes reutilizáveis (AppSnackBar, botões, ...)
├── features/               # módulos funcionais
│   ├── <feature>/
│   │   ├── data/           # implementações concretas
│   │   │   └── services/
│   │   ├── domain/         # Dart puro, sem Flutter
│   │   │   ├── dtos/ models/ services/ enums/ errors/ states/ viewmodels/
│   │   ├── view/           # UI (widgets, telas; game-loop Flame se houver)
│   │   │   └── widgets/
│   │   └── <feature>_routes.dart
│   └── ...
├── shared/                 # compartilhado entre features
├── app_routes.dart         # rotas centrais
├── app_injections.dart     # registro de dependências (get_it)
└── main.dart
```

## Princípios (Clean Architecture)
1. **Independência de frameworks** — `domain/` não importa Flutter/Flame nem pacotes de UI/persistência.
2. **Testabilidade** — cada camada testável isoladamente; domínio sem `BuildContext`.
3. **Independência de UI** e **de persistência** — a lógica não sabe se é widget/Flame nem se o dado vem de prefs/hive/arquivo.

### Camadas
- **Apresentação:** `view/` (widgets/telas), `viewmodels/`, `states/`.
- **Domínio:** `domain/{models,services(interfaces),dtos,enums,errors,states,viewmodels}`.
- **Dados:** `data/services/` (implementações concretas dos contratos de `domain/services/`).

## Fluxo (unidirecional)
View capta evento → ViewModel processa e chama services → Services executam lógica/dados → ViewModel atualiza state → View renderiza.

## Estado — `ValueNotifier`
- ViewModel `extends ValueNotifier<State>`; UI reage com `ValueListenableBuilder`.
- States **imutáveis** (use `equatable`). State em `domain/states/`, ViewModel em `domain/viewmodels/` — arquivos e pastas separados.

```dart
abstract class IHomeState {}
class HomeInitialState implements IHomeState {}
class HomeLoadingState implements IHomeState {}
class HomeLoadedState implements IHomeState { final Data data; const HomeLoadedState(this.data); }
class HomeErrorState implements IHomeState { final String message; const HomeErrorState(this.message); }

class HomeViewmodel extends ValueNotifier<IHomeState> {
  HomeViewmodel(this._service) : super(HomeInitialState());
  final IHomeService _service;
}
```

## Injeção de Dependências — `get_it`
- Injeções por feature (`<feature>_injections.dart`) agregadas em `app_injections.dart`.
- `registerLazySingleton` p/ vida longa, `registerFactory` p/ efêmeros. Nunca instanciar service na mão dentro da view.

```dart
getIt.registerFactory<IHomeService>(() => HomeService(getIt.get()));
getIt.registerLazySingleton<HomeViewmodel>(() => HomeViewmodel(getIt.get()));
```

## Navegação
Rotas por feature (`<feature>_routes.dart`) agregadas em `app_routes.dart`. Transições personalizadas quando melhorar UX.

## Erros — padrão Result (`result_dart`)
- Services retornam `AsyncResult<Success, Error>`; a UI usa `fold`. Sem retorno útil = `Unit`. Erros tipados em `domain/errors/`. Nada de `throw` cru cruzando camada.

```dart
Result<Unit, Exception> exampleMethod() { /* ... */ return Success(unit); }
```

### SnackBars padronizados (`AppSnackBar`)
Feedback único: sucesso (verde), erro (vermelho), aviso (laranja), info (azul). Sempre via `AppSnackBar`, nunca `ScaffoldMessenger` cru. Ações úteis quando cabível; 3-4s (5s+ com ação).

## Persistência (offline-first)
Acesso a dados atrás de interface em `domain/services/` (ex: `ISaveRepository`); implementação em `data/services/` (shared_preferences/hive). Nenhuma chamada de rede em runtime.

## Boas Práticas
Código limpo (nomes descritivos, funções curtas); separação estrita (UI sem lógica, ViewModel sem detalhe de service, service sem UI); consistência de nomenclatura/pastas; lazy loading de DI; acessibilidade (contraste AA, alvo ≥ 48dp); reuso via `design_system/` e `shared/`.

## Regras não-negociáveis (checagem devil-advocate / quality-gate)
- `domain/` nunca importa Flutter/Flame.
- `features/X` acessa dados só via interfaces de `domain/services/`.
- ViewModel = `ValueNotifier<State>`; State imutável em pasta separada.
- Erros via `result_dart` (`AsyncResult`/`fold`/`Unit`).
- DI via `get_it`; nada de service instanciado na mão na view.
- Cores/tipografia/espaço do `design_system/`, nunca `Color(0xFF...)` solto.
