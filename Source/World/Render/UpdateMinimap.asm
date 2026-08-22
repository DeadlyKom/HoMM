
                ifndef _WORLD_RENDER_UPDATE_MINIMAP_SHADOW_SCREEN_
                define _WORLD_RENDER_UPDATE_MINIMAP_SHADOW_SCREEN_
; -----------------------------------------
; обновление миникарты (теневого экрана)
; In:
; Out:
; Corrupt:
; Note:
;   ℹ️ код расположен в "общей памяти"
; -----------------------------------------
Update:
.Minimap        SET_PAGE_MAP                                                    ; включить страницу работы с картой
                CALL Reset                                                      ; сброс буфера анимаций тайлов
                CALL Minimap.GenFog                                             ; генерация тумана для миникарты
                CALL Minimap.Compilation                                        ; компиляция миникарты
                CALL Minimap.Memcpy                                             ; копирование миникарты
                
                ; копирование миникарты в теневой экран
                SET_PAGE_SCREEN_SHADOW
                SCREEN_ADR_REG HL, SCR_ADR_BASE, SCR_MINIMAP_POS_X << 3, SCR_MINIMAP_POS_Y << 3
                LD IXL, #06
                CALL World.SharedScreen.ScreenRefresh.Memcpy.Screen_6
; -----------------------------------------
; подсветка положения видимого окна на миникарте
; In:
; Out:
; Corrupt:
;   HL, DE, BC, AF
; Note:
;   подсвечивается знакоместо, содержащее левый верхний гексагон видимой области
;   ℹ️ код расположен в "общей памяти"
; -----------------------------------------
.MinimapView    ; преобразование координаты X гексагона в X знакоместа миникарты
                LD A, (GameSession.WorldInfo + FWorldInfo.MapPosition.X)
                RRCA
                RRCA
                RRCA
                AND %00000111
                ADD A, SCR_MINIMAP_POS_X                                        ; экранная координата X знакоместа миникарты
                LD E, A

                ; преобразование координаты Y гексагона в Y знакоместа миникарты
                LD A, (GameSession.WorldInfo + FWorldInfo.MapPosition.Y)
                RRCA
                RRCA
                RRCA
                AND %00000111
                ADD A, SCR_MINIMAP_POS_Y                                        ; экранная координата Y знакоместа миникарты
                LD D, A

                ; преобразование экранных координат знакоместа в адрес атрибута
                SET_RENDER_TO_BASE_SCREEN
                CALL Convert.AttributeAdr                                       ; DE - адрес нового атрибута основного экрана

.OldAddress     EQU $+1
                LD HL, #0000                                                    ; старый адрес атрибута
                ; OR A                                                           ; флаг переноса уже сброшен в Convert.AttributeAdr
                SBC HL, DE
                RET Z                                                           ; выход, если знакоместо не изменилось
                ADD HL, DE                                                      ; восстановить старый адрес
                LD (.OldAddress), DE                                            ; сохранить новый адрес

                ; обновление основного и теневого экранов
                SET_PAGE_SCREEN_SHADOW
                BIT 6, H
                JR Z, $+8                                                       ; пропуск очистки при первом вызове
                RES 6, (HL)                                                     ; сброс яркости старого знакоместа
                SET 7, H
                RES 6, (HL)                                                     ; сброс яркости старого знакоместа
                EX DE, HL
                SET 6, (HL)                                                     ; подсветка нового знакоместа
                SET 7, H
                SET 6, (HL)                                                     ; подсветка нового знакоместа
                RET

                display " - Update minimap shadow screen:\t\t\t", /A, Update, "\t= busy [ ", /D, $-Update, " byte(s)  ]"

                endif ; ~_WORLD_RENDER_UPDATE_MINIMAP_SHADOW_SCREEN_
