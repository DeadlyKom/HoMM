
                ifndef _MODULE_WORLD_SAVE_STATE_
                define _MODULE_WORLD_SAVE_STATE_
; -----------------------------------------
; сохранение состояния модуля мира
; In:
; Out:
; Corrupt:
;   HL, DE, BC, AF, AF'
; Note:
;   ℹ️ код расположен в модуле "мира"
; -----------------------------------------
SaveState:      ; сохранение индексов спрайтов персонажа в соответствующее место образа мира
                MEMCPY World.SharedCode.Render.Object.Character.Indexes, \
                    World.Adr.Deploy.World + (World.SharedCode.Render.Object.Character.Indexes - Adr.World), \
                    World.SharedCode.Render.Object.Character.Indexes.Size

                ; сохранение индексов спрайтов UI в соответствующее место образа мира
                MEMCPY World.SharedCode.Render.Object.UI.Indexes, \
                    World.Adr.Deploy.World + (World.SharedCode.Render.Object.UI.Indexes - Adr.World), \
                    World.SharedCode.Render.Object.UI.Indexes.Size

                ; сохранение идентификатора спрайта курсора Idle в образ мира
                LD A, (Kernel.Modules.World.Page)
                EX AF, AF'
                LD A, Page.SharedScreen
                LD HL, UI_Cursor.Idle.SpriteID
                LD DE, World.Adr.Deploy.SharedScreen + (UI_Cursor.Idle.SpriteID - Adr.SharedScreen)
                LD BC, #01
                CALL Memcpy.BetweenPages                                        ; копирование с возвратом в страницу модуля мира

                ; сохранение идентификатора спрайта курсора Click в образ мира
                LD A, (Kernel.Modules.World.Page)
                EX AF, AF'
                LD A, Page.SharedScreen
                LD HL, UI_Cursor.Click.SpriteID
                LD DE, World.Adr.Deploy.SharedScreen + (UI_Cursor.Click.SpriteID - Adr.SharedScreen)
                LD BC, #01
                JP Memcpy.BetweenPages                                          ; копирование с возвратом в страницу модуля мира

                endif ; ~_MODULE_WORLD_SAVE_STATE_
