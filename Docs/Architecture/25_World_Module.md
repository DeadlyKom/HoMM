# 25. Модуль «мира» [World]

## Назначение главы

Эта глава посвящена `World` — самому насыщенному и центральному runtime-модулю проекта.
Если `MainMenu` задаёт интерфейсное состояние, а `Session` готовит данные сессии, то `World` — это уже собственно активный игровой мир.

## Почему `World` центральный

Именно в `World` встречаются:
- игровой loop;
- interrupt handler;
- render pipeline;
- tilemap-логика;
- UI «мира»;
- sprite-слой;
- input-обработка;
- world-object rendering;
- shared screen механика;
- генерация служебных таблиц.

То есть это не просто один из модулей. Это основная runtime-сцена игры.

## Два уровня `World`

Как и у `MainMenu`, здесь есть два слоя:
- модульный слой `Source/Modules/World/`;
- shared/runtime слой `Source/World/`.

### Модульный слой

Отвечает за загрузку, разворачивание, deploy-копирование и настройку окружения «мира».

### Shared/runtime слой

Содержит разворачиваемый код «мира»: loop, interrupt, render, tilemap и UI. Его рабочая область используется и другими экранными модулями, поэтому после их работы код «мира» восстанавливается из образа ресурса.

## Execute-Фаза

`Source/Modules/World/Execute.asm`:
- переключает страницу assets;
- загружает asset мира;
- запускает его.

Это уровень asset-dispatch и перехода в «мир».

## Launch-Фаза

`Source/Modules/World/Launch.asm` — один из самых информативных файлов проекта.
Он показывает, что запуск «мира» включает не просто вызов `World.SharedCode.Loop`, а целую последовательность сборки runtime-среды.

### Что делает Launch

Последовательность в [Launch.asm](../../Source/Modules/World/Launch.asm):

- сохраняет страницу ресурса «мира»;
- готовит текстуру Bayer;
- разворачивает `SharedCode` и `SharedScreen`;
- создаёт и копирует служебные таблицы;
- загружает и инициализирует общую игровую музыку;
- инициализирует спрайты;
- завершает показ прогресса загрузки;
- мгновенно центрирует камеру на активном персонаже;
- подготавливает игровое окно;
- вызывает `Launch.Initialize`, который назначает UI, loop, render, swap и interrupt handler, разрешает ввод и задаёт начальные флаги.

Инициализация устанавливает `GAME_SUSPEND` и соответствующий запрос, то есть мир начинает работу в режиме остановки времени. Полная пауза здесь не устанавливается.

### Почему это ключевой файл архитектуры

Он показывает реальную философию проекта:
мир не просто “существует”, а собирает часть своей среды исполнения динамически при старте.

## `Source/Modules/World/Include.inc`

Этот include-файл подключает:
- `ProgressTimeline.inc`
- `Kernel/Bind.inc`
- `Launch.asm`
- `SaveState.asm`
- `RestoreState.asm`
- `UI/Include.inc`
- `Input/Include.inc`
- `Launch/Include.inc`
- `Tilemap/Include.inc`
- `Graphics/Include.inc`
- `Utilities/Include.inc`
- `Source/Draw/Stencil/Include.inc`
- генераторы таблиц
- hexagon utilities
- deploy-блоки `Sprite`, `World`, `SharedScreen`

### Что это значит

Уже на модульном уровне мир описывается как композиция многих подсистем.
Здесь нет монолитного “world.asm, в котором всё подряд”.

## Shared Runtime слой `Source/World/`

`Source/World/Include.inc` формирует `module SharedCode` и включает:
- `Loop.asm`
- `Interrupt.asm`
- `Render/Include.inc`
- `Tilemap/Include.inc`
- `Source/World/UI/Include.inc`, содержащий слои, обработчики и переходники UI

Это skeleton runtime мира.

## Подмодуль `Input`

`Source/Modules/World/Input/Include.inc` включает:
- `Scan.asm`
- `Input_Select.asm`
- `Input_Movement.asm`
- `Input_MenuPause.asm`
- `Input_GameSuspend.asm`
- `Input_Accelerate.asm`

### Смысл

World-input слой разделяет разные аспекты ввода:
- общий скан;
- выбор;
- движение;
- ускорение.

Это хороший признак, что input в мире моделируется как набор отдельных обязанностей, а не одна гигантская процедура.

## Подмодуль `UI`

`Source/Modules/World/UI/Include.inc` подключает разделы `Handler`, `Complete`, `Initialize`, `Transition`.

В `Handler` находятся `Icon_Mode.asm`, `Layer_GameUI.asm`, `Layer_Minimap.asm`, `Layer_GameView.asm`. Шестерёнка вызывает `World.UI.Handler.Options`; ENTER в `Input.MenuPause` запрашивает тот же `UI_MODE_OPTIONS`. Переход `ToOptions.asm` завершает UI «мира». `World.Loop` сохраняет состояние и запускает `ExecuteModule.Options`.

Для `UI_MODE_COMBAT` предусмотрен аналогичный маршрут через `ToCombat.asm`, завершение «мира» и `ExecuteModule.Combat`. Сам триггер начала боя ещё не реализован.

В `Source/World/UI` размещены разворачиваемые слои и постоянные точки входа в процедуры ресурса «мира». Старые `Layer_GamePause`, слой `GamePause`, сетка поверх мира и возврат из этого меню удалены. `UI_MODE_GAME_MENU` теперь является отдельной заглушкой; он не открывается по ENTER. Актуальная схема переходов и нумерация режимов приведены в [главе 06](06_Runtime_Flow_and_Control.md).

## Подмодуль `Tilemap`

`Source/Modules/World/Tilemap/Include.inc` включает `ResetMapScroll.asm`, `UpdateMovement.asm`, `Center.asm`, `CenterSmooth.asm`.

### Что это показывает

Tilemap-слой мира не является только статической геометрией. Он напрямую участвует в механике обновления движения.

## Подмодуль `Graphics`

`Source/Modules/World/Graphics/Include.inc` включает:
- `Firmament.asm`
- `Display_GameplayUI.asm`
- `Display_DiamondChrono.asm`
- `Display_GameplayFrame.asm`
- `Display_DiamondTexture.asm`
- `Display_GameplaySuspend.asm`
- бинарные данные frame и ornament

### Почему это важно

World-graphics слой связывает код отображения игрового окна с упакованными графическими ресурсами интерфейса «мира».
Это ещё один пример того, как runtime и assets в проекте неразрывно связаны.

## `Source/World/Render/Include.inc`

Render-слой shared runtime мира включает:
- `Draw.asm`
- `Object/Include.inc`
- `UpdateMinimap.asm`
- `PipelineHexagons.asm`
- `SetViewWorldBound.asm`

### Что это значит

Render мира — это не просто “нарисовать всё”.
Он уже разбит на темы:
- общий draw;
- курсор;
- объектный рендер;
- обновление миникарты;
- pipeline гексагонов;
- вычисление границ видимой области мира.

Это серьёзная и зрелая структура render-подсистемы.

При этом важно не перепутать обзор модуля с полным разбором экранного цикла.
В этой главе World рассматривается как runtime-модуль целиком.
Подробная пошаговая схема кадра, двойной буферизации, dirty screen blocks, длинного swap и курсорного подпотока вынесена отдельно в [18_Rendering_Pipeline.md](18_Rendering_Pipeline.md).

## Сохранение и восстановление мира

Перед уходом в характеристики, инвентарь, опции или «сражение» `World.Loop` вызывает `SaveState`. Процедура сохраняет изменяемые индексы спрайтов персонажей и UI, а также идентификаторы курсора в соответствующие места образа ресурса «мира».

`RestoreState` отключает пользовательский обработчик, восстанавливает `SharedCode` и `SharedScreen`, инициализирует курсор сохранёнными идентификаторами, рисует окно и повторно вызывает `Launch.Initialize`. После переключения ресурсы «характеристик», инвентаря, опций и «сражения» помечаются невостребованными. Это не немедленное освобождение всех ресурсов.

Поскольку восстановление использует `Launch.Initialize`, его результатом является начальное состояние флагов мира, включая `GAME_SUSPEND`. Произвольное прежнее состояние игрового времени процедура сейчас не восстанавливает.

## Роль SharedScreen

Модуль «мира» [World] разворачивает отдельный shared-screen код на отдельную страницу.
Это подчёркивает, что экран и буферизация здесь являются частью архитектуры, а не мелкой технической деталью.

## Роль генерации таблиц

В запуске «мира» явно присутствуют генераторы:
- `BitScanLsbTable`
- `Div6Table`
- `ScrBlockTable`

### Что это показывает

Проект использует compile/runtime-generated lookup tables как способ оптимизации сложных или часто повторяемых операций.
Это очень характерно для системного подхода под ограниченную платформу.

## Почему `World` — самый богатый модуль проекта

Потому что он является местом, где одновременно сходятся:
- state machine приложения;
- spatial model мира;
- рендер;
- ввод;
- объекты;
- интерфейс;
- таблицы оптимизации;
- screen management.

Ни один другой модуль не держит столько пересечений предметных и платформенных слоёв сразу.

## Диаграмма внутренней структуры

```mermaid
flowchart TD
    World --> Launch[Launch]
    Launch --> SharedCode[World.SharedCode]
    Launch --> Input[Modules/World/Input]
    Launch --> UI[Modules/World/UI]
    Launch --> Tilemap[Modules/World/Tilemap]
    Launch --> Graphics[Modules/World/Graphics]
    SharedCode --> Loop[Loop]
    SharedCode --> Interrupt[Interrupt]
    SharedCode --> Render[Render]
    SharedCode --> Layers[UI Layers]
```

## Практический итог главы

`World` — это центральная runtime-платформа проекта. Он загружается как asset, разворачивает код, генерирует таблицы, настраивает экранную инфраструктуру, поднимает sprite-слой, подключает input/UI/tilemap/render и становится главным активным состоянием игры. Это самый сложный и самый содержательный модуль всей текущей архитектуры.

