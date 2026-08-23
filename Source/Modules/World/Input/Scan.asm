
                ifndef _MODULE_WORLD_INPUT_SCAN_
                define _MODULE_WORLD_INPUT_SCAN_
; -----------------------------------------
; сканирование устроиств ввода
; In:
; Out:
; Corrupt:
; Note:
; -----------------------------------------
Scan:           ; проверка HardWare ограничения мыши
                CHECK_HARD_INPUT_FLAG HARD_INPUT_KEMPSTON_MOUSE_BIT
                JR Z, .KeyCheck                                                 ; переход, если мышь недоступна
                CALL Mouse.UpdateCursor                                         ; обновить положение курсора

                ifdef _DEBUG
                CALL .DebugSpawnStandard                                        ; отладочный спавн штандарта по одиночному нажатию E
                endif

                LD BC, Mouse.Position

                LD A, (BC)                                                      ; позиция корсора по горизонтали
                CP SCREEN_EDGE
                CALL C, Movement.Left.Force

                LD A, (BC)
                CP SCREEN_CURSOR_X - SCREEN_EDGE
                CALL NC, Movement.Right.Force

                INC BC

                LD A, (BC)                                                      ; позиция корсора по вертикали
                CP SCREEN_EDGE
                CALL C, Movement.Up.Force

                LD A, (BC)
                CP SCREEN_CURSOR_Y - SCREEN_EDGE
                CALL NC, Movement.Down.Force

.KeyCheck       ; --------------------------------------------------------------
                ; очистка системных клавиш
                LD A, (GameState.Input.Value)
                AND ~KEY_MASK
                LD (GameState.Input.Value), A
                ; --------------------------------------------------------------
                
                ; запрос открытия "книги заклинаний"
                LD A, (GameConfig.KeySpellBook)
                CALL Input.CheckKeyState
                LD C, UI_MODE_SPELLBOOK
                CALL Z, UI.Runtime.Request

                ; проверка клавиши "выбор"
                LD A, (GameConfig.KeySelect)
                CALL Input.CheckKeyState
                CALL Z, Input.Select                                            ; переход, если клавиша нажата

                ; проверка клавиши "выход"
                ; LD A, (GameConfig.KeyESC)

                ; проверка клавиши "меню/пауза"
                CALL Input.MenuPause                                            ; обработать нажатие и отпускание
                CALL World.UI.Handler.GameWindow.SyncButtons                    ; синхронизировать защёлки клавиш "выбор" и "отмена"

                ; проверка клавиш перемещения
                LD A, (GameConfig.KeyAccel)
                CALL Input.CheckKeyState
                CALL Z, Input.Accelerate
                ; --------------------------------------------------------------
                ; опрос перемещения влево
                LD A, (GameConfig.KeyLeft)
                CALL Input.CheckKeyState
                CALL Z, Movement.Left

                ; опрос перемещения вправо
                LD A, (GameConfig.KeyRight)
                CALL Input.CheckKeyState
                CALL Z, Movement.Right

                ; опрос перемещения вверх
                LD A, (GameConfig.KeyUp)
                CALL Input.CheckKeyState
                CALL Z, Movement.Up

                ; опрос перемещения вниз
                LD A, (GameConfig.KeyDown)
                CALL Input.CheckKeyState
                CALL Z, Movement.Down
                ; --------------------------------------------------------------
                ; проверка нажатий клавиш перемещения
                LD A, (GameState.Input.Value)
                AND MOVEMENT_MASK
                RET Z                                                           ; выход если нет онажатия клавиш

                SET_INPUT_TIMER_FLAG SCROLL_MAP_BIT                             ; установка флага разрешения обновления скрола карты
                RET

                ifdef _DEBUG
; -----------------------------------------
; отладочный спавн штандарта в гексе под курсором по нажатию клавиши E
; In:
; Out:
; Corrupt:
;   HL, DE, BC, AF, AF'
; Note:
;   удержание клавиши не создаёт дополнительные объекты;
;   новое событие формируется только после отпускания и следующего нажатия
; -----------------------------------------
.DebugSpawnStandard
                LD A, VK_E
                CALL Input.CheckKeyState
                JR NZ, .SpawnKeyReleased                                        ; переход, если клавиша E отпущена

.SpawnKeyFlag   FLAG_MODIFY 0                                                   ; флаг, текущее нажатие уже обработано
                RET C                                                           ; выход, если нажатие уже обработано

                SET_FLAG_MODIFY Scan.SpawnKeyFlag                               ; установить защёлку до обработки нажатия

                ; проверка нахождения курсора внутри области мира
                LD A, (Mouse.PositionX)
                SUB SCR_WORLD_POS_X << 3
                CP SCR_WORLD_SIZE_X << 3
                RET NC

                LD A, (Mouse.PositionY)
                SUB SCR_WORLD_POS_Y << 3
                CP SCR_WORLD_SIZE_Y << 3
                RET NC

                ; получение гексагона под курсором
                CALL World.Hexagon.GetPosByMouse                                ; BC: B - y, C - x
                LD D, B
                LD E, C
                JP_IN_PAGE Page.Page0, Tick.Spawn.Standard                      ; вызов спавна штандарта в странице 0

.SpawnKeyReleased
                RES_FLAG_MODIFY Scan.SpawnKeyFlag                               ; сбросить защёлку после отпускания клавиши
                RET
                endif

                endif ; ~_MODULE_WORLD_INPUT_SCAN_
