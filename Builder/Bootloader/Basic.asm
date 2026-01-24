
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

                ; перемещение минимального кернела
                LD 	DE, Adr.KernelMinimal
                LD 	BC, KernelMinimal.Size
                LDIR

                ; перемещение точки входа
                LD 	DE, Adr.EntryPoint
                LD 	BC, EntryPoint.Size
                LDIR

                ; перемещение драйвера TR-DOS
                LD 	DE, Adr.ExtraBuffer
                LD 	BC, TRDOS.Size
                LDIR

                MEMSET_BYTE Adr.HardConfig, 0, Size.HardConfig                  ; очистка конфигурации железа
                ; -----------------------------------------
                ; определение доступной памяти
                ; In:
                ; Out:
                ;   A  - флаг выбраного порта памяти
                ;   A' - количество доступных страниц
                ; Corrupt:
                ; Note:
                ; -----------------------------------------
                CALL Adr.SharedPoint
                EX AF, AF'
                CP MIN_PAGES_ALLOWED
                JP C, Memory.InsufficientRAM                                    ; недостаточно памяти!
                LD (HardConfig.AvailablePages), A                               ; сохранение количества доступных страниц памяти по 16кб

                ; копирование битового массива доступного ОЗУ
                SET_PAGE_ASSETS                                                 ; включить страницу расположения ассет менеджера
                LD HL, Adr.TilemapBuffer
                LD DE, Adr.AvailableMem
                LD BC, Size.AvailableMem
                LDIR
                ; очистка битового массива начальных блоков памяти
                LD H, D
                LD L, E
                INC E
                LD BC, Size.InitialBlockMem-1
                LD (HL), B
                LDIR

                ; копирование кода в стеш
                LD HL, Adr.ExtraBuffer
                LD DE, Adr.Stash_TRDOS
                LD BC, Size.Stash_TRDOS
                LDIR

                ; инициализация TR-DOS
                CALL TRDOS.Initialize

                ; инициализация ресурс менеджера
                include "Source/AssetsManager/Initialize.asm"                   ; (0)

                ; инициализация прерывания
                include "Source/Interrupt/Initialize.asm"                       ; (1)

                ; отметить занятую область данными в доступной ОЗУ (принудительно)
                MARK_RAM PAGE_0, MemBank_03, BankSize                           ; отметить страницу памяти 0 занятой
                MARK_RAM PAGE_1, MemBank_03, BankSize                           ; отметить страницу памяти 1 занятой
                MARK_RAM PAGE_2, MemBank_02, BankSize                           ; отметить страницу памяти 2 занятой
                MARK_RAM PAGE_3, MemBank_03, BankSize                           ; отметить страницу памяти 3 занятой
                ; MARK_RAM PAGE_4, MemBank_03, BankSize                           ; отметить страницу памяти 4 занятой
                MARK_RAM PAGE_5, MemBank_01, BankSize                           ; отметить страницу памяти 5 занятой
                ; MARK_RAM PAGE_6, MemBank_03, BankSize                           ; отметить страницу памяти 6 занятой
                MARK_RAM PAGE_7, MemBank_03, BankSize                           ; отметить страницу памяти 7 занятой

                ; подготовка и загрузка кернеля
                SET_PAGE_ASSETS                                                 ; включить страницу расположения ассет менеджера
                SET_LOAD_ASSETS ASSETS_ID_KERNEL, Page.Kernel, Adr.Kernel
                LOAD_ASSETS ASSETS_ID_KERNEL

                ; подготовка и загрузка кода страницы 0
                SET_PAGE_ASSETS                                                 ; включить страницу расположения ассет менеджера
                SET_LOAD_ASSETS ASSETS_ID_PAGE_0, Page.Page0, Adr.Code.Page0
                LOAD_ASSETS ASSETS_ID_PAGE_0

                ; подготовка и загрузка кода страницы 1
                SET_PAGE_ASSETS                                                 ; включить страницу расположения ассет менеджера
                SET_LOAD_ASSETS ASSETS_ID_PAGE_1, Page.Page1, Adr.Code.Page1
                LOAD_ASSETS ASSETS_ID_PAGE_1

                ; подготовка и загрузка кода страницы 3
                SET_PAGE_ASSETS                                                 ; включить страницу расположения ассет менеджера
                SET_LOAD_ASSETS ASSETS_ID_PAGE_3, Page.Page3, Adr.Code.Page3
                LOAD_ASSETS ASSETS_ID_PAGE_3

                ; переход по точке входа
                LD SP, Adr.StackTop
                JP Adr.EntryPoint
Data:
.Memory         include "Source/Memory/Determine.asm"
.KernelMinimal  include "Builder/Assets/Code/Original/Kernel/Pack_KernelMinimal.inc"    ; минимальный блок кернела
.EntryPoint     include "Source/EntryPoint/Include.inc"                         ; точка входа
.TRDOS          include "Source/TR-DOS/Include.inc"                             ; драйвер TR-DOS
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
