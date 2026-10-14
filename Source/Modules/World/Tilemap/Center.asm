                ifndef _MODULE_WORLD_TILEMAP_CENTER_
                define _MODULE_WORLD_TILEMAP_CENTER_

                module Center
; -----------------------------------------
; мгновенное центрирование на активном персонаже
; In:
; Out:
; Corrupt:
;   HL, DE, BC, AF, AF', IX, IY
; -----------------------------------------
Instant:        ; проверка наличия персонажей
                LD A, (GameSession.WorldInfo + FWorldInfo.HeroNum)
                OR A
                RET Z                                                           ; выход, если персонажи отсутствуют

                ; расчёт положения камеры относительно активного персонажа
                CALL GetTarget

                ; установка рассчитанного положения камеры
                JP SetPosition
; -----------------------------------------
; расчёт цели центрирования на активном персонаже
; In:
; Out:
;   DE - положение карты в гексагонах (D - y, E - x)
;   BC - смещения внутри гексагона (B - y, C - x)
; Corrupt:
;   HL, AF, AF', IX, IY
; Note:
;   активный персонаж должен существовать
; -----------------------------------------
GetTarget:      ; получение координат активного персонажа
                LD A, (GameState.PlayerActions + FPlayerActions.SelectedHeroID)
                LD E, A
                CALL_IN_PAGE Page.Object, Character.Utilities.GetPosHexagon.Wrap

                ; расчёт горизонтального смещения с учётом чётности строки
                LD A, D
                AND #01
                LD C, A
                ADD A, A
                ADD A, C
                LD C, A

                ; расчёт положения карты по горизонтали относительно персонажа
                LD A, E
                SUB #02

                ; проверка левой границы карты
                JR NC, .LimitX                                                  ; переход, если левая граница не нарушена
                XOR A
                LD C, A

.LimitX         ; проверка правой границы карты
                CP MAX_WORLD_HEX_X - 4
                JR C, .TargetX                                                  ; переход, если правая граница не нарушена
                LD A, MAX_WORLD_HEX_X - 5
                LD C, HEXTILE_SIZE_X - 1

.TargetX        ; сохранение горизонтальной позиции и смещения
                LD E, A
                LD L, C

                ; расчёт положения карты по вертикали относительно персонажа
                ; три гексагона вверх и два знакоместа вниз
                LD C, #02
                LD A, D
                SUB #03

                ; проверка верхней границы карты
                JR NC, .LimitY                                                  ; переход, если верхняя граница не нарушена
                XOR A
                LD C, A

.LimitY         ; проверка нижней границы карты
                CP MAX_WORLD_HEX_Y - 6
                JR C, .TargetY                                                  ; переход, если нижняя граница не нарушена
                LD A, MAX_WORLD_HEX_Y - 6
                LD C, #01

.TargetY        ; подготовка положения карты и смещений для возврата
                LD D, A
                LD B, C
                LD C, L
                RET
; -----------------------------------------
; установка положения камеры
; In:
;   DE - положение карты в гексагонах (D - y, E - x)
;   BC - смещения внутри гексагона (B - y, C - x)
; Out:
; Corrupt:
;   HL, BC, AF, AF'
; Note:
;   положение и смещения должны находиться в границах карты
;   обновление буферов выполняет вызывающий код
; -----------------------------------------
SetPosition:    ; установка положения карты и смещений внутри гексагона
                LD (GameSession.WorldInfo + FWorldInfo.MapPosition), DE
                LD (GameSession.WorldInfo + FWorldInfo.MapOffset), BC

                ; установка смещений для формирования изображения карты
                LD A, C
                LD (World.Shift_X), A
                LD A, B
                LD (World.Shift_Y), A

                ; получение адреса левого верхнего гексагона видимой области
                CALL_IN_PAGE Page.Page1, BufferUtilities.GetMapArrayAdr
                LD (GameSession.WorldInfo + FWorldInfo.Tilemap), HL
                RET

                endmodule

                endif ; ~_MODULE_WORLD_TILEMAP_CENTER_
