
                ifndef _INPUT_MOUSE_UPDATE_STATES_
                define _INPUT_MOUSE_UPDATE_STATES_
; -----------------------------------------
; обновление положения курсора в экранных координатах
; In :
; Out :
; Corrupt :
;   HL, E, BC, AF
; -----------------------------------------
UpdateCursor:   LD A, #FF
                LD (PositionFlag), A
                
                CALL GetMouseX                                                  ; получить текущее значение позиции мыши по оси X
                LD E, A
                LD HL, LastValue.FromMousePortX
                SUB (HL)                                                        ; рассчитать разницу значений между текущим и предыдущими значениями
                LD (HL), E                                                      ; сохраним текущее значение
                INC HL
                LD (HL), A                                                      ; сохранение дельты
                JR Z, .SkipChangeX                                              ; дельта равна 0
                LD HL, PositionX
                JP P, .PositiveX                                                ; разница значений положительная

                ADD A, (HL)
                JR C, .SetMouseX                                                ; проверка на переполнение (курсор достиг левого края экрана)

                XOR A                                                           ; фиксируем значение
                JR .SetMouseX
.PositiveX      ADD A, (HL)
                JR NC, .SetMouseX                                               ; проверка на переполнение (курсор достих правого края экрана)

                LD A, #FF                                                       ; фиксируем значение
.SetMouseX      LD (HL), A                                                      ; изменить значение положение мыши по оси X
                XOR A
                LD (PositionFlag), A                                            ; установка флага изменения позиции мыши

.SkipChangeX    CALL GetMouseY                                                  ; получить текущее значение позиции мыши по оси Y
                LD E, A
                LD HL, LastValue.FromMousePortY
                SUB (HL)                                                        ; рассчитать разницу значений между текущим и предыдущими значениями
                LD (HL), E                                                      ; сохраним текущее значение
                INC HL
                LD (HL), A                                                      ; сохранение дельты

                RET Z                                                           ; дельта равна 0
                NEG                                                             ; инвертнём значение оси Y
                LD HL, PositionY
                JP P, .PositiveY                                                ; разница значений положительная

                ADD A, (HL)
                JR C, .SetMouseY                                                ; проверка на переполнение (курсор достиг верхнего края экрана)

                XOR A                                                           ; фиксируем значение
                JR .SetMouseY
.PositiveY      ADD A, (HL)
                JR C, .SetMaxY                                                  ; проверка на переполнение (курсор достих нижнего края экрана)
                CP #C0
                JR C, .SetMouseY

.SetMaxY        LD A, #BF                                                       ; фиксируем значение
.SetMouseY      LD (HL), A
                XOR A
                LD (PositionFlag), A                                            ; установка флага изменения позиции мыши
                RET
Position:       EQU $
PositionX:      DB #80
PositionY:      DB #60
LastValue:
.FromMousePortX DB #80
.DeltaOffsetX   DB #00                                                          ; дельта смещения мышки по горизонтали
.FromMousePortY DB #60
.DeltaOffsetY   DB #00                                                          ; дельта смещения мышки по вертикали
PositionFlag:   DB #FF                                                          ; если курсор не поменяет позицию, хранит #FF

                endif ; ~_INPUT_MOUSE_UPDATE_STATES_
