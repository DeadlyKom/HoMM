
                ifndef _ENTRY_POINT_
                define _ENTRY_POINT_
; -----------------------------------------
; точка входа
; In:
; Out:
; Corrupt:
; Note:
;   #73C0, размер 64 байта
; -----------------------------------------
EntryPoint:     EI
                HALT

                CALL ExecuteModule.Core                                         ; запуск "ядра"

                LD HL, ASSETS_ID_MAP_DEBUG
                CALL ExecuteModule.LoadMap                                      ; загрузка карты

                LD A, SAVE_SLOT_0
                LD (GameSession.SaveSlot), A
                CALL ExecuteModule.Session                                      ; запуск загрузки/инициализации сессии

                CALL ExecuteModule.World                                        ; запуск "мира"

                endif ; ~_ENTRY_POINT_
