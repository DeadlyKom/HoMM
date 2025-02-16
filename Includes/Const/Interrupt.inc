
                ifndef _CONST_INTERRUPT_
                define _CONST_INTERRUPT_
Int:
.TableSize      EQU 257                                                         ; размер таблицы прерывания
.StackSize      EQU 64 * 2                                                      ; размер стека прерывания
.Table          EQU MemBank_02                                                  ; таблица прерываний 257 байт
.StackBottom    EQU Int.Table + Int.TableSize                                   ; нижний адрес стека
.StackTop       EQU Int.StackBottom + Int.StackSize                             ; верхний адрес стека

                endif ; ~_CONST_INTERRUPT_
