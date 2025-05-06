
                ifndef _MODULE_SESSION_INCLUDE_
                define _MODULE_SESSION_INCLUDE_
JumpTable:      ; таблица переходов
                DW Launch                                                       ; функция запуска (0)
                DW #0000                                                        ; резерв

                include "Launch.asm"

                endif ; ~_MODULE_SESSION_INCLUDE_
