
                ifndef _MODULE_SESSION_SAVE_SLOT_VALIDATION_INFO_
                define _MODULE_SESSION_SAVE_SLOT_VALIDATION_INFO_
; -----------------------------------------
; валидация информации о слоте сохранения
; In:
; Out:
;   флаг переполнения установлен, если данные слота сохранения корректны
; Corrupt:
; Note:
; -----------------------------------------
Validation:     ; проверка наличия данных
                LD HL, Adr.TilemapBuffer
                LD BC, FSaveSlot-1
                CALL Session.Utilities.DataAvailable
                RET NC                                                          ; выход, если данные слота сохранения, некорректны

                ; проверка контрольной суммы
                LD HL, Adr.TilemapBuffer
                LD DE, FSaveSlot-1
                CALL Session.Utilities.CRC_8

                ; проверка соответствия контрольной суммы
                LD HL, Adr.TilemapBuffer + FSaveSlot.CRC
                OR A                                                            ; сброс флага переполнения
                                                                                ; данные слота сохранения, некорректны
                CP (HL)
                RET NZ                                                          ; выход, если контрольная сумма несоответствует

                SCF                                                             ; установка флага переполнения
                                                                                ; данные слота сохранения, корректны
                RET

                display " - Validation 'Save Slot' info:\t\t\t", /A, Load_Info, "\t= busy [ ", /D, $-Load_Info, " byte(s)  ]"

                endif ; ~_MODULE_SESSION_SAVE_SLOT_VALIDATION_INFO_
