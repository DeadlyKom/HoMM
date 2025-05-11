
                ifndef _MAIN_MENU_INPUT_SCAN_
                define _MAIN_MENU_INPUT_SCAN_
; -----------------------------------------
; сканирование устроиств ввода
; In:
; Out:
; Corrupt:
; Note:
; -----------------------------------------
Scan:           ; проверка HardWare ограничения мыши
                CHECK_HARDWARE_FLAG HARDWARE_KEMPSTON_MOUSE_BIT
                JR Z, .KeyCheck                                                 ; переход, если мышь недоступна
                CALL Mouse.UpdateCursor                                         ; обновить положение курсора

.KeyCheck       ; проверка клавиши

                ; ToDo: выбор слота должен осуществляться в игровом меню
                ; ToDo: произвести выборку карты в игровом меню, снастройками сессии

                RET

                endif ; ~_MAIN_MENU_INPUT_SCAN_
