
                ifndef _MODULE_SESSION_SAVE_SLOT_SAVE_INFO_
                define _MODULE_SESSION_SAVE_SLOT_SAVE_INFO_
; -----------------------------------------
; сохранение информации о слоте сохранения
; In:
; Out:
; Corrupt:
; Note:
;   портится тайловый буфер
; -----------------------------------------
Save_Info:      ; проверка наличия слота
                LD A, (GameSession.SaveSlotID)
                CP SAVE_SLOT_MAX
                RET NC                                                          ; выход, если данный слот недоступен

                ; -----------------------------------------
                ; запись группы секторов. в регистре
                ; B  - количество считываемых секторов,
                ; D  - номер начального трека,
                ; E  - начальный сектор, 
                ; HL - адрес буфера, в который производится чтение
                ; -----------------------------------------
                LD HL, Adr.TilemapBuffer
                LD D, #00
                ADD A, #09                                                      ; 0 слот сохранения расположен в 9 секторе (сектора начинаются с 0-го)
                LD E, A
                LD BC, (#01 << 8) | TRDOS.WR_SECTORS
                CALL TRDOS.Jump3D13                                             ; переход в TR-DOS

                ; восстановление страницы расположения ассета
                LD A, (Kernel.Modules.Session.Page)
                SET_PAGE_A

                SCF                                                             ; установка флага переполнения
                                                                                ; сохранение данных слота сохранения, завершены успешно
                RET

                display " - Save 'Save Slot' info:\t\t\t\t", /A, Save_Info, "\t= busy [ ", /D, $-Save_Info, " byte(s)  ]"

                endif ; ~_MODULE_SESSION_SAVE_SLOT_SAVE_INFO_
