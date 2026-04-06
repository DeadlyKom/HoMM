# Архитектурная Книга Проекта

Старый `ProjectOverview` в обзорном формате заменён на структуру книги.
Теперь архитектура проекта описывается как набор связанных глав в каталоге `Docs/Architecture/`.

## Читать Отсюда

- [00_Index.md](Architecture/00_Index.md) — карта книги и порядок чтения
- [01_Repository_and_Docs.md](Architecture/01_Repository_and_Docs.md) — устройство репозитория и роль документов
- [02_Build_and_Packing.md](Architecture/02_Build_and_Packing.md) — сборка, упаковка, assets и страницы памяти
- [03_Includes_and_Contracts.md](Architecture/03_Includes_and_Contracts.md) — слой `Includes` как контракт системы
- [04_Source_Runtime_and_Modules.md](Architecture/04_Source_Runtime_and_Modules.md) — исполняемый код и модули рантайма
- [05_Data_Model.md](Architecture/05_Data_Model.md) — модель данных: участники, персонажи, объекты, команды игрока
- [06_Runtime_Flow_and_Control.md](Architecture/06_Runtime_Flow_and_Control.md) — поток запуска, main loop и разделение human/AI path
- [07_AI_and_StateTree.md](Architecture/07_AI_and_StateTree.md) — AI-слой, `StateTree`, `AIContext`, `Blackboard`
- [09_Structs_Deep_Dive_Index.md](Architecture/09_Structs_Deep_Dive_Index.md) — детальный раздел по ключевым структурам
- [15_FAssets_and_GameState_Assets.md](Architecture/15_FAssets_and_GameState_Assets.md) — asset record, `GameState.AssetID` и runtime-зеркало последнего ресурса
- [16_Asset_Centric_Runtime_Approach.md](Architecture/16_Asset_Centric_Runtime_Approach.md) — главный архитектурный подход проекта
- [20_Modules_Deep_Dive_Index.md](Architecture/20_Modules_Deep_Dive_Index.md) — детальный раздел по ключевым runtime-модулям
- [26_AssetsManager_and_Asset_Execution.md](Architecture/26_AssetsManager_and_Asset_Execution.md) — главный движок загрузки, размещения и исполнения assets
- [08_Architecture_Notes_and_Risks.md](Architecture/08_Architecture_Notes_and_Risks.md) — архитектурные выводы, текущие ограничения и направления развития

## Что Изменилось

Раньше этот файл был одним обзорным конспектом.
Теперь он выполняет роль титульной страницы и оглавления, а подробное описание вынесено в отдельные главы, чтобы документация читалась как техническая книга, а не как одна длинная заметка.
