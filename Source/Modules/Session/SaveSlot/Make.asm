
                ifndef _MODULE_SESSION_SAVE_SLOT_MAKE_INFO_
                define _MODULE_SESSION_SAVE_SLOT_MAKE_INFO_
; -----------------------------------------
; создание слота сохранения
; In:
;   
; Out:
; Corrupt:
; Note:
; -----------------------------------------
Make_Info:      ; создание контрольной суммы
                LD HL, GameSession.SaveSlot
                LD DE, FSaveSlot-1
                CALL Session.Utilities.CRC_8
                LD (GameSession.SaveSlot + FSaveSlot.CRC), A
                
                ; копирование информации о слоте сохранения в буффер
                LD HL, GameSession.SaveSlot
                LD DE, Adr.TilemapBuffer
                LD BC, FSaveSlot
                JP Memcpy.FastLDIR

                display " - Make 'Save Slot' info:\t\t\t\t", /A, Make_Info, "\t= busy [ ", /D, $-Make_Info, " byte(s)  ]"

                endif ; ~_MODULE_SESSION_SAVE_SLOT_MAKE_INFO_
