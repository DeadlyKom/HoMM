
                ifndef _ITEM_REMOVE_AT_SWAP_
                define _ITEM_REMOVE_AT_SWAP_
; -----------------------------------------
; удалить предмет, переместив последний предмет на его место
; In:
;   A - идентификатор удаляемого предмета
; Out:
;   D - прежний идентификатор последнего предмета
;   E - новый идентификатор перемещённого предмета
;   флаг переполнения установлен, если перемещения не было
; Corrupt:
;   HL, DE, BC, AF
; Note:
;   ℹ️ необходимо включить страницу массива предметов
;   при перемещении внешние ссылки с D необходимо заменить на E
; -----------------------------------------
RemoveAtSwap:   ; получение адреса счётчика предметов
                LD HL, GameState.ItemsNum

                ; проверка наличия удаляемого предмета в массиве
                ifdef _DEBUG
                CP (HL)
                DEBUG_BREAK_POINT_NC                                            ; ошибка, идентификатор удаляемого предмета выходит за пределы массива
                endif

                ; сохранение идентификатора удаляемого предмета
                LD E, A

                ; уменьшение количества предметов и получение последнего ID
                DEC (HL)
                LD D, (HL)

                ; проверка удаления последнего предмета
                CP D
                SCF                                                             ; флаг, перемещения нет
                RET Z                                                           ; выход, если удаляемый предмет последний

                ; получение адреса назначения экземпляра предмета
                PUSH DE
                LD A, E
                CALL Utilities.Address.HL
                PUSH HL

                ; получение адреса последнего экземпляра предмета
                LD A, D
                CALL Utilities.Address.HL
                POP DE

                ; копирование последнего экземпляра на место удалённого
                ifdef _OPTIMIZE
                rept ITEM_SIZE
                LDI
                endr
                else
                LD BC, ITEM_SIZE
                CALL Memcpy.FastLDIR
                endif
                POP DE

                ; получение адреса назначения размещения предмета
                PUSH DE
                LD A, E
                CALL Utilities.Location.HL
                PUSH HL

                ; получение адреса размещения последнего предмета
                LD A, D
                CALL Utilities.Location.HL
                POP DE

                ; копирование размещения последнего предмета
                ifdef _OPTIMIZE
                rept ITEM_LOCATION_SIZE
                LDI
                endr
                else
                LD BC, ITEM_LOCATION_SIZE
                CALL Memcpy.FastLDIR
                endif
                POP DE

                OR A                                                            ; сброс флага, последний предмет перемещён
                RET

                display " - Remove at swap 'item':\t\t\t\t", /A, RemoveAtSwap, "\t= busy [ ", /D, $-RemoveAtSwap, " byte(s) ]"

                endif ; ~_ITEM_REMOVE_AT_SWAP_

