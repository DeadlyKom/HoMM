# Архитектурная книга проекта

Старый `ProjectOverview` в обзорном формате заменён на структуру книги.
Теперь архитектура проекта описывается как набор связанных глав в каталоге `Docs/Architecture/`.

## Читать отсюда

- [Путеводитель по книге](Architecture/00_Index.md) — с чего начать и как читать книгу
- [Репозиторий и документация](Architecture/01_Repository_and_Docs.md) — устройство репозитория и роль документов
- [Сборка, упаковка и образ диска](Architecture/02_Build_and_Packing.md) — как проект превращается в итоговый образ
- [Includes и контрактный слой](Architecture/03_Includes_and_Contracts.md) — слой `Includes` как контракт системы
- [Макро-система и флаги](Architecture/17_Macro_System_and_Flag_Orchestration.md) — patch-points, self-modifying wiring и управление рантаймом
- [Source и runtime-модули](Architecture/04_Source_Runtime_and_Modules.md) — исполняемый код и модули рантайма
- [Модель данных](Architecture/05_Data_Model.md) — участники, персонажи, объекты и команды игрока
- [Поток рантайма и управление](Architecture/06_Runtime_Flow_and_Control.md) — запуск, main loop и разделение human/AI path
- [AI и StateTree](Architecture/07_AI_and_StateTree.md) — `StateTree`, `AIContext` и `Blackboard`
- [Rendering pipeline](Architecture/18_Rendering_Pipeline.md) — двойная буферизация, dirty screen blocks и экранный цикл мира
- [Детальный разбор структур](Architecture/09_Structs_Deep_Dive_Index.md) — отдельные главы по ключевым структурам
- [FAssets и runtime-зеркало ресурса](Architecture/15_FAssets_and_GameState_Assets.md) — `GameState.AssetID` и последний загруженный ресурс
- [Главный архитектурный подход](Architecture/16_Asset_Centric_Runtime_Approach.md) — центральная идея проекта
- [Детальный разбор модулей](Architecture/20_Modules_Deep_Dive_Index.md) — отдельные главы по ключевым runtime-модулям
- [AssetsManager и исполнение assets](Architecture/26_AssetsManager_and_Asset_Execution.md) — загрузка, размещение и запуск ресурсов
- [Архитектурные заметки и риски](Architecture/08_Architecture_Notes_and_Risks.md) — выводы, ограничения и направления развития

## Что изменилось

Раньше этот файл был одним обзорным конспектом.
Теперь он выполняет роль титульной страницы и оглавления, а подробное описание вынесено в отдельные главы, чтобы документация читалась как техническая книга, а не как одна длинная заметка.
