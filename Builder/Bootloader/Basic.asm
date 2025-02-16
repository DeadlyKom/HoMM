
                ifndef _BUILDER_BOOTLOADER_
                define _BUILDER_BOOTLOADER_

                display "Basic:\t\t\t\t\t\t", /A, Begin, "\t= busy [ ", /D, Size, " byte(s)  ]"
; -----------------------------------------
; boot загрузчик
; In:
; Out:
; Corrupt:
; Note:
;   #5D40
; -----------------------------------------
Basic:          DB #00, #0A                                                     ; номер строки 10
                DW EndBoot - StartBoot + 2                                      ; длина строки
                DB #EA                                                          ; команда REM
StartBoot:      DI

                ; отключение 128кб BASIC
                LD SP, (BASIC.ERR_SP)                                           ; ERR_SP
                LD HL, #1303                                                    ; MAIN_4
                EX (SP), HL
                RES 4, (IY + 1)                                                 ; FLAGS
                                                                                ; бит 4, используется только в 128К = 1 при новом ПЗУ, иначе 0
                LD BC, Adr.Port_7FFD
                LD A, ROM
                LD (BC), A
                OUT (C), A

                LD SP, Adr.Booloader.StackTop


                ; определение текущего адреса
                LD HL, #E9E1	                                                ; POP HL : JP (HL)
                EX (SP), HL	                                                    ; размещение 2х команд
                CALL Adr.Booloader.StackTop                                     ; в стек помещается адрес следующей команды,
                                                                                ; где выполняется POP HL : JP (HL)
                                                                                ; регистр HL хранит адрес следующей команды
                ; перемещение кода "настройка" в общую память
                LD 	DE, Data.Memory-$
                ADD	HL, DE
                LD 	DE, Adr.SharedPoint
                LD 	BC, Memory.Determine.Size
                LDIR

                ; перемещение точки входа
                LD 	DE, Adr.EntryPoint
                LD 	BC, Size.EntryPoint
                LDIR

                ; определение доступной памяти
                CALL Adr.SharedPoint
                JP NC, Memory.InsufficientRAM                                   ; недостаточно памяти!

                ; инициализация прерывания
                include "Source/Interrupt/Initialize.asm"

                ; переход по точке входа
                LD SP, Adr.StackTop
                JP Adr.EntryPoint
Data:
.Memory         include "Source/Memory/Determine.asm"
.EntryPoint     include "Source/EntryPoint/Include.inc"                         ; точка входа
EndBoot:        DB #0D                                                          ; конец строки
                DB #00, #14                                                     ; номер строки 20
                DB #2A, #00                                                     ; длина строки 42 байта
                DB #F9                                                          ; RANDOMIZE
                DB #C0                                                          ; USE
                DB #28                                                          ; (
                DB #BE                                                          ; PEEK
                DB #B0                                                          ; VAL
                DB #22                                                          ; "
                DB #32, #33, #36, #33, #36                                      ; 23636
                DB #22                                                          ; "
                DB #2A                                                          ; *
                DB #32, #35, #36                                                ; 256
                DB #0E, #00, #00, #00, #01, #00                                 ; значение 256
                DB #2B                                                          ; +
                DB #BE                                                          ; PEEK
                DB #B0                                                          ; VAL
                DB #22                                                          ; "
                DB #32, #33, #36, #33, #35                                      ; 23635
                DB #22                                                          ; "
                DB #2B                                                          ; +
                DB #35                                                          ; 5
                DB #0E, #00, #00, #05, #00, #00                                 ; значение 5
                DB #29                                                          ; )
                DB #0D                                                          ; конец строки

                endif ; ~_BUILDER_BOOTLOADER_
