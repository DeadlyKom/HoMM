                ifndef _MODULE_WORLD_UI_HANDLER_GAME_WINDOW_
                define _MODULE_WORLD_UI_HANDLER_GAME_WINDOW_
; -----------------------------------------
; обработчик UI элемента "игрового окна"
; In:
;   флаг переполнения сброшен, если таймер подсказки обнулился
; Out:
; Corrupt:
; Note:
; -----------------------------------------
GameWindow:     ; проверка бездействия игрока
                LD A, (GameState.PlayerActions + FPlayerActions.Action)
                OR A                                                            ; PLAYER_ACTION_NONE
                RET NZ                                                          ; выход, если действие игрока не закончено

                ; проверка клавиши "выбор"
                LD A, (GameConfig.KeySelect)
                CALL Input.CheckKeyState
                RET NZ                                                          ; выход, если не нажата клавиша "выбор"

                ; ToDo: в зависимости от действий игрока GameState.PlayerActions
                ;       меняем поведение, пока только одно — выбор гексагона!

                ; определение позиции гексагона под курсором мыши
                CALL World.Hexagon.GetPosByMouse                                ; BC - координаты гексагона под курсором (B - y, C - x)

                ; получить адреса живого героя и его начальную позицию
                PUSH BC                                                         ; сохранение координат назначения
                LD A, (GameState.PlayerActions + FPlayerActions.SelectedHeroID)
                LD E, A
                CALL_IN_PAGE Page.Object, Character.Utilities.GetPosHexagon.Wrap
                POP BC                                                          ; восстановление координат назначения

                ;   DE - координаты героя               (D = Y, E = X)
                ;   BC - координаты назначения          (B = Y, C = X)

                ; сравнение позиций
                LD L, E
                LD H, D
                OR A
                SBC HL, BC
                RET Z                                                           ; выход, если позиции совпадают

                ; подготовить параметры поиска
                EXX

                ; соседний гекс формирует прямой путь,
                ; для остальных выполняется ограниченный BFS
                CALL_IN_PAGE Page.Pathfinding, Pathfinding.Request.Wrap

                ; A' = длина найденного пути
                EX AF, AF'
                OR A
                RET Z                                                           ; выход, путь не найден

                LD C, A                                                         ; длина найденного пути
                EXX                                                             ; C' = длина пути

                ; применить найденный маршрут к тому же живому объекту
                CALL_IN_PAGE Page.Page0, Character.PathInitialize.Wrap
                EX AF, AF'
                OR A
                RET Z                                                           ; защитная проверка отклонила маршрут

                ; начать движение только после успешной установки пути
                LD A, PLAYER_ACTION_HERO_MOVEMENT
                LD (GameState.PlayerActions + FPlayerActions.Action), A
                RET

                endif ; ~_MODULE_WORLD_UI_HANDLER_GAME_WINDOW_