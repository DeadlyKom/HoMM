
                ifndef _MODULE_WORLD_UI_HANDLER_GAME_WINDOW_
                define _MODULE_WORLD_UI_HANDLER_GAME_WINDOW_
; -----------------------------------------
; обработчик UI элемента "игрового окна"
; In:
;   флаг переполнения сброшен, если  таймера подсказки обнулился
; Out:
; Corrupt:
; Note:
; -----------------------------------------
GameWindow:     ; принять только фронт нового нажатия ЛКМ
                LD HL, GameState.RouteControl
                BIT ROUTE_SELECT_EDGE_BIT, (HL)
                RET Z

                ; новый маршрут разрешён только при бездействии игрока
                LD A, (GameState.PlayerActions + FPlayerActions.Action)
                OR A                                                            ; PLAYER_ACTION_NONE
                JR NZ, .DiscardRouteCommand                                     ; действие уже занято, удалить устаревший mailbox

                ; захватить команду до чтения героя и расчёта гекса;
                ; interrupt после этого не создаёт вторую команду и не входит в debug GetPos
                LD A, PLAYER_ACTION_HERO_PATHFINDING
                LD (GameState.PlayerActions + FPlayerActions.Action), A

                ; ToDo: в зависимости от действий игрока GameState.PlayerActions
                ;       меняем поведение, пока только одно выбор гексагона!

                CALL World.Hexagon.GetPosByRouteTarget                          ; гекс из атомарно опубликованного снимка команды
                LD HL, GameState.RouteControl
                RES ROUTE_SELECT_EDGE_BIT, (HL)                                 ; освободить mailbox после полного чтения снимка

                ; BC' = цель; DE' = старт; IX/IY сохраняют адреса конкретного героя
                ; на всё время синхронного поиска
                EXX
                CALL_IN_PAGE Page.Object, Character.Utilities.GetRouteContext

                ; выход, если позиции совпадают
                EXX
                LD L, E
                LD H, D
                OR A
                SBC HL, BC
                JR Z, .RouteCommandComplete                                     ; выход, если позиции совпадают
                EXX

                ; запросить прямой шаг, точный bounded-путь либо 8-шаговый дальний префикс;
                ; результат записывается в Adr.SortBuffer
                CALL_IN_PAGE Page.Pathfinding, Pathfinding.Request.Wrap
                EX AF, AF'
                LD C, A                                                         ; длина найденного пути

                LD A, C
                OR A
                JR Z, .PathfindingFailed                                        ; путь отсутствует либо цель недостижима

                ; точечно применить маршрут к тому же объекту; PathInitialize
                ; повторно проверит CharacterID, ObjectID и оба адреса слотов
                EXX
                CALL_IN_PAGE Page.Page0, Character.PathInitialize.Wrap
                EX AF, AF'
                OR A
                JR Z, .RouteContextChanged                                      ; защитная проверка отклонила устаревший контекст

                ; установить действие только после успешного применения пути
                LD A, PLAYER_ACTION_HERO_MOVEMENT
                LD (GameState.PlayerActions + FPlayerActions.Action), A
                ; первый пакет "мировых тиков" запросит персонаж после завершения поворота
                RET

.PathfindingFailed
                ; ToDo: отправить UI/звуковое событие с причиной отказа построения пути
                JR .RouteCommandComplete

.RouteContextChanged
                ; ToDo: диагностическое событие: во время синхронного BFS герой
                ;       штатно не может быть удалён, перемещён в массиве или заменён
.RouteCommandComplete
                XOR A
                LD (GameState.PlayerActions + FPlayerActions.Action), A         ; PLAYER_ACTION_NONE
                RET

.DiscardRouteCommand
                RES ROUTE_SELECT_EDGE_BIT, (HL)
                RET

                endif ; ~_MODULE_WORLD_UI_HANDLER_GAME_WINDOW_
