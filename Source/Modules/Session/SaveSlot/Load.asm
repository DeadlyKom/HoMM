
                ifndef _MODULE_SESSION_SAVE_SLOT_LOAD_INFO_
                define _MODULE_SESSION_SAVE_SLOT_LOAD_INFO_
; -----------------------------------------
; загрузка информации о слоте сохранения
; In:
; Out:
; Corrupt:
; Note:
; -----------------------------------------
Load_Info:      ; проверка наличия слота
                LD A, (GameSession.SaveSlot + FSaveSlot.MapID)
                CP SAVE_SLOT_MAX
                RET NC                                                          ; выход, если данный слот недоступен

                ; -----------------------------------------
                ; чтение группы секторов. в регистре
                ; B  - количество считываемых секторов,
                ; D  - номер начального трека,
                ; E  - начальный сектор, 
                ; HL - адрес буфера, в который производится чтение
                ; -----------------------------------------
                LD HL, Adr.TilemapBuffer
                LD D, #00
                ADD A, #09                                                      ; 0 слот сохранения расположен в 9 секторе (сектора начинаются с 0-го)
                LD E, A
                LD BC, (#01 << 8) | TRDOS.RD_SECTORS
                CALL TRDOS.Jump3D13                                             ; переход в TR-DOS

                ; восстановление страницы расположения ассета
                LD A, (Kernel.Modules.Session.Page)
                JP_SET_PAGE_A

                display " - Load 'Save Slot' info:\t\t\t\t", /A, Load_Info, "\t= busy [ ", /D, $-Load_Info, " byte(s)  ]"

                endif ; ~_MODULE_SESSION_SAVE_SLOT_LOAD_INFO_
