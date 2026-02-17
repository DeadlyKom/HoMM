
                ifndef _EVENT_HANDLER_
                define _EVENT_HANDLER_
; -----------------------------------------
; обработчик событий
; In:
; Out:
; Corrupt:
; Note:
; -----------------------------------------
Handler.Before: LD A, #38       ; JR C, $
                JR $+4
Handler.After:  LD A, #30       ; JR NC, $
                LD (.JR), A

                ; количество обрабатываемых событий
                LD A, (GameSession.WorldInfo + FWorldInfo.EventNum)             ; количество элементов в массиве
                OR A
                RET Z                                                           ; выход, если нет элементов в массиве
                
                ; инициализация
                LD B, A
                LD IX, Adr.EventArray                                           ; стартовый адрес массива событий

.Loop           PUSH BC
                SET_PAGE_SCREEN_SHADOW                                          ; включение страницы теневого экрана

                ; проверка фазы выполнения события
                LD A, (IX + FEvent.Flags)
                ADD A, A                                                        ; EVENT_EXECUTE_PHASE_BIT
.JR             EQU $
                JR NC, .NextEvent                                               ; переход, если событие после отрисовки

                EX AF, AF'

                ; копирование тела события
                LD IY, Adr.ExtraBuffer - FEvent
                LD A, IXL
                ADD A, FEvent
                LD L, A
                LD H, HIGH Adr.EventArray
                LD DE, Adr.ExtraBuffer
                ifdef _OPTIMIZE
                rept EVENT_SIZE - FEvent
                LDI
                endr
                else
                LD BC, EVENT_SIZE - FEvent
                CALL Memcpy.FastLDIR
                endif

                LD A, (IX + FEvent.Page)
                LD HL, (IX + FEvent.Function)
                EXX
                EX AF, AF'
                
                ; обработка события
                AND %00000110
                LD HL, .JumpTable
                CALL Func.JumpTable.NoShift

                ; вызов функции
                EXX
                EX AF, AF'
                CALL SetPage                                                    ; установка страницы функции
                CALL .HL

.NextEvent      ; следующий элемент
                LD A, IXL
                ADD A, EVENT_SIZE
                LD IXL, A

                ; уменьшение счётчика элементов
                POP BC
                DJNZ .Loop

.RET            RET
.HL             JP (HL)

.JumpTable      DW Lifetime.Once                                                ; EVENT_LIFETIME_ONCE
                DW Lifetime.Timer                                               ; EVENT_LIFETIME_TIMER
                DW Lifetime.Cond                                                ; EVENT_LIFETIME_CONDITION
                DW .RET                                                         ; резерв

                display " - Handler event:\t\t\t\t\t", /A, Handler.Before, "\t= busy [ ", /D, $-Handler.Before, " byte(s)  ]"

                endif ; ~_EVENT_HANDLER_
