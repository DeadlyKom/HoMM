
                ifndef _WORLD_RENDER_UPDATE_MINIMAP_SHADOW_SCREEN_
                define _WORLD_RENDER_UPDATE_MINIMAP_SHADOW_SCREEN_
; -----------------------------------------
; обновление миникарты (теневого экрана)
; In:
; Out:
; Corrupt:
; Note:
; -----------------------------------------
UpdateMinimap:  SET_PAGE_MAP                                                    ; включить страницу работы с картой
                CALL Reset                                                      ; сброс буфера анимаций тайлов
                CALL Minimap.GenFog                                             ; генерация тумана для миникарты
                CALL Minimap.Compilation                                        ; компиляция миникарты
                CALL Minimap.Memcpy                                             ; копирование миникарты
                
                ; копирование миникарты в теневой экран
                SET_PAGE_SCREEN_SHADOW
                SCREEN_ADR_REG HL, SCR_ADR_BASE, SCR_MINIMAP_POS_X << 3, SCR_MINIMAP_POS_Y << 3
                LD IXL, #06
                JP World.SharedScreen.ScreenRefresh.Memcpy.Screen_6

                display " - Update minimap shadow screen:\t\t\t", /A, UpdateMinimap, "\t= busy [ ", /D, $-UpdateMinimap, " byte(s)  ]"

                endif ; ~_WORLD_RENDER_UPDATE_MINIMAP_SHADOW_SCREEN_
