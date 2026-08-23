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
GameWindow:     ; команды маршрута разрешены только во время паузы мира
                CHECK_UI_FLAG UI_GAME_PAUSE_BIT
                RET Z

                ; проверка нажатия клавиши "отмена"
                LD A, (GameConfig.KeyESC)
                CALL Input.CheckKeyState
                JR NZ, .CancelReleased                                          ; переход, если клавиша отпущена

                ; проверка флага защёлки клавиши "отмена"
.CancelFlag     FLAG_MODIFY 1                                                   ; флаг, текущее нажатие уже обработано
                RET C                                                           ; выход, если текущее нажатие уже обработано

                SET_FLAG_MODIFY GameWindow.CancelFlag                           ; установка защёлки до выполнения команды
                JR .CancelPath

.CancelReleased ; сброс флага защёлки клавиши "отмена"
                RES_FLAG_MODIFY GameWindow.CancelFlag

                ; проверка нажатия клавиши "выбор"
                LD A, (GameConfig.KeySelect)
                CALL Input.CheckKeyState
                JR NZ, .SelectReleased                                          ; переход, если клавиша отпущена

                ; проверка флага защёлки клавиши "выбор"
.SelectFlag     FLAG_MODIFY 1                                                   ; флаг, текущее нажатие уже обработано
                RET C                                                           ; выход, если текущее нажатие уже обработано

                ; установка флага защёлки клавиши "выбор"
                SET_FLAG_MODIFY GameWindow.SelectFlag                           ; принять нажатие до BFS и возможных ранних выходов
                JR .BuildPath

.SelectReleased ; сброс флага защёлки клавиши "выбор"
                RES_FLAG_MODIFY GameWindow.SelectFlag
                RET

.CancelPath     ; отмена пути выбранного персонажа
                LD A, (GameState.PlayerActions + FPlayerActions.SelectedHeroID)
                LD E, A
                EXX                                                             ; E' = CharacterID
                CALL_IN_PAGE Page.Page0, Character.PathCancel.Wrap
                RET

.BuildPath      ; ToDo: в зависимости от действий игрока GameState.PlayerActions
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

                ; применить найденный маршрут к объекту
                CALL_IN_PAGE Page.Page0, Character.PathInitialize.Wrap
                RET
; -----------------------------------------
; синхронизировать защёлки кнопок маршрута
; In:
; Out:
; Corrupt:
;   HL, BC, AF
; Note:
;   вызывается Input.Scan каждое прерывание, в том числе когда курсор
;   находится вне GameWindow
; -----------------------------------------
.SyncButtons    ; проверка клавиши "отмена"
                LD A, (GameConfig.KeyESC)
                CALL Input.CheckKeyState
                JR NZ, .CancelUp                                                ; переход, если клавиша отпущена

                ; проверка состояния паузы мира
                CHECK_UI_FLAG UI_GAME_PAUSE_BIT
                JR NZ, .SyncSelect                                              ; переход, т.к. на паузе нажатие принимает только GameWindow

                ; установка флага защёлки клавиши "отмена"
                SET_FLAG_MODIFY GameWindow.CancelFlag                           ; блокировать удержание клавиши вне паузы
                JR .SyncSelect

.CancelUp       ; сброс флага защёлки клавиши "отмена"
                RES_FLAG_MODIFY GameWindow.CancelFlag

.SyncSelect     ; проверка нажатия клавиши "выбор"
                LD A, (GameConfig.KeySelect)
                CALL Input.CheckKeyState
                JR NZ, .SelectUp                                                ; переход, если клавиша отпущена

                ; проверка состояния паузы мира
                CHECK_UI_FLAG UI_GAME_PAUSE_BIT
                RET NZ                                                          ; выход, т.к. на паузе нажатие принимает только GameWindow

                ; установка флага защёлки клавиши "выбор"
                SET_FLAG_MODIFY GameWindow.SelectFlag                           ; блокировать удержание клавиши вне паузы
                RET

.SelectUp       ; сброс флага защёлки клавиши "выбор"
                RES_FLAG_MODIFY GameWindow.SelectFlag
                RET

                endif ; ~_MODULE_WORLD_UI_HANDLER_GAME_WINDOW_
