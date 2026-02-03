
                ifndef _MODULE_WORLD_UI_HANDLER_MINIMAP_
                define _MODULE_WORLD_UI_HANDLER_MINIMAP_
; -----------------------------------------
; обработчик UI элемента "миникарты"
; In:
;   флаг переполнения Carrry сброшен, если  таймера подсказки обнулился
; Out:
; Corrupt:
; Note:
; -----------------------------------------
Minimap:        ; проверка нажатия клавиши "выбор"
                LD A, (GameState.Input.Value)
                BIT SELECT_KEY_BIT, A
                RET Z                                                           ; выход, если небыла нажата клавиша "выбор"

                ; расчёт клика по миникарте (вертикаль)
                LD A, (Mouse.PositionY)
                SUB SCR_MINIMAP_POS_Y << 3
                CP MAX_WORLD_HEX_Y-HEXTILE_BASE_SIZE_Y-2-4                      ; учёт нижнего смещения
                JR C, .SubOffsetY
                LD A, MAX_WORLD_HEX_Y-HEXTILE_BASE_SIZE_Y-2
                JR .SetPositionY
.SubOffsetY     ; добавить смещение
                SUB HEXTILE_BASE_SIZE_Y >> 1
                JR NC, $+3
                XOR A

.SetPositionY   ; установка позиции карты по вертикали
                LD L, A
                LD (GameSession.WorldInfo + FWorldInfo.MapPosition.Y), A
                XOR A
                LD (World.Shift_Y), A
                LD (GameSession.WorldInfo + FWorldInfo.MapOffset.Y), A

                ; расчёт адреса гексогональной карты учитывая только вертикаль
                LD H, #00
                LD B, H
                LD C, L
                ADD HL, HL  ; x2
                ADD HL, BC  ; x3
                ADD HL, HL  ; x6
                ADD HL, HL  ; x12
                ADD HL, HL  ; x24
                ADD HL, HL  ; x48
                LD BC, Adr.Hextile
                ADD HL, BC

                ; расчёт клика по миникарте (горизонталь)
                LD A, (Mouse.PositionX)
                SUB SCR_MINIMAP_POS_X << 3
                CP MAX_WORLD_HEX_X-(HEXTILE_SIZE_X >> 1)-1-3                    ; учёт правого смещения
                JR C, .SubOffsetX
                LD A, MAX_WORLD_HEX_X-(HEXTILE_SIZE_X >> 1)-1
                JR .SetPositionX

.SubOffsetX     ; добавить смещение
                SUB HEXTILE_SIZE_X >> 1
                JR NC, $+3
                XOR A

.SetPositionX   ; установка позиции карты по горизонтали
                LD C, A
                LD (GameSession.WorldInfo + FWorldInfo.MapPosition.X), A
                XOR A
                LD (World.Shift_X), A
                LD (GameSession.WorldInfo + FWorldInfo.MapOffset.X), A

                ; добавить смещение по горизонтали к адресу гексогональной карты
                LD B, #00
                ADD HL, BC
                LD (GameSession.WorldInfo + FWorldInfo.Tilemap), HL

                SET_VIEW_FLAG SET_MAP_POSITION_ON_MINIMAP_BIT                   ; установка флага установления положения карты по мини-карте
                SET_INPUT_TIMER_FLAG SCROLL_MAP_BIT                             ; установка флага разрешения обновления скрола карты
                RET
                
; Div6            LD DE, HEXTILE_SIZE_X
;                 rept 7
;                 CP E
;                 RET C
;                 SUB E
;                 INC D
;                 endr
;                 RET

                endif ; ~_MODULE_WORLD_UI_HANDLER_MINIMAP_
