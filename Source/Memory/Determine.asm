
                ifndef _MEMORY_DETERMINE_
                define _MEMORY_DETERMINE_

                module Memory
                DISP Adr.SharedPoint
Begin:          EQU $
Const:          ; константные значения
.ValuePagesBuf  EQU Adr.MemoryMap                                               ; адрес расположения буфера значений для переключения страниц (выровнен 256 байтам)
.MaxPages       EQU 64                                                          ; максимальное количество страниц памяти по 16кб
.MinPagesAllow  EQU 8                                                          ; минимальное допустимое количество страниц памяти по 16кб
.CheckPageAdr   EQU #FFFF                                                       ; адрес для проверкаи записи/чтения номера страниц
.INDEX_NONE     EQU #FF                                                         ; недоступный индекс

; -----------------------------------------
; определение доступной памяти
; In:
; Out:
;   A  - флаг выбраного порта памяти
;   A' - количество доступных страниц
; Corrupt:
; Note:
; -----------------------------------------
Determine:      ; инициализация битового массива доступного ОЗУ (не доступно)
                LD HL, Adr.ExtraBuffer
                LD DE, Adr.ExtraBuffer+1
                LD BC, Size.AvailableMem-1
                LD (HL), C
                LDIR
                
                ; проверка порта #7FFD
                CALL _7FFD
                CP Const.MinPagesAllow
                CALL NC, _7FFD.Select                                           ; выбрать порт, если количество страниц памяти достаточно
                JR NC, .PortFound

                ; проверка порта #1FFD
                CALL _1FFD
                CP Const.MinPagesAllow
                CALL NC, _1FFD.Select                                           ; выбрать порт, если количество страниц памяти достаточно
                JR NC, .PortFound

                ; проверка порта #DFFD
                CALL _DFFD
                CP Const.MinPagesAllow
                CALL NC, _DFFD.Select                                           ; выбрать порт, если количество страниц памяти достаточно
                JR NC, .PortFound

                ; проверка порта #FDFD
                CALL _FDFD
                CP Const.MinPagesAllow
                CALL NC, _FDFD.Select                                           ; выбрать порт, если количество страниц памяти достаточно
                JR NC, .PortFound

                ; проверка порта #FFF7
                CALL _FFF7
                CP Const.MinPagesAllow
                CALL NC, _FFF7.Select                                           ; выбрать порт, если количество страниц памяти достаточно
                JR NC, .PortFound

                ; -----------------------------------------
                ; неудалось определить порт и минимальное количество страниц
                ; -----------------------------------------

                ; корректировка доступных страниц памяти
                DEC A
                JR NZ, $+4                                                      ; переход, если доступно больше одной страницы по 16кб
                LD A, #02                                                       ; доступно 3 страницы по 16 кб (5, 2, 0) для 48кб
                INC A
                
.PortFound      ; порты найден и выбран
                EX AF, AF'
.MemPort        EQU $+1
                LD A, #00

                RET
; -----------------------------------------
; првоерка порта, на возможность переключать страницы памяти
; In:
;   HL - адрес функции переключения страниц, проверяемог порта
; Out:
; Corrupt:
; Note:
; -----------------------------------------
CheckPort:      ; инициализация функций переключения страниц
                LD (.Func_A), HL
                LD (.Func_B), HL

                ; инициализация буфера значений переключения страниц
                LD HL, Const.ValuePagesBuf
                LD DE, Const.ValuePagesBuf + 1
                LD BC, (Const.MaxPages << 1) - 1
                LD (HL), Const.INDEX_NONE
                LDIR

                ; -----------------------------------------
                ; нумерация страниц
                ; -----------------------------------------
                LD HL, Const.CheckPageAdr
                LD D, Const.MaxPages

.Func_A         EQU $+1
.SetPage_Loop   CALL $

                DEC D
                LD (HL), D
                JR NZ, .SetPage_Loop

                ; -----------------------------------------
                ;  проверка нумерации строк
                ; -----------------------------------------
                XOR A
                EX AF, AF'
                LD D, Const.MaxPages

                LD BC, (HIGH Const.ValuePagesBuf << 8) | (LOW Const.ValuePagesBuf - 1) & 0xFF
                PUSH BC

.Func_B         EQU $+1         
.CheckPage_Loop CALL $

                ; проверка разности значений номеров страниц
                LD A, (HL)
                INC A
                JR Z, .NextPage
                DEC A

                ; отметить свободные ячейки соответствующее странице ОЗУ
                PUSH HL
                LD H, HIGH Adr.ExtraBuffer
                ADD A, A    ; x2
                ADD A, A    ; x4
                ADD A, A    ; x8
                LD L, A
                XOR A
                LD (HL), A
                INC L
                LD (HL), A
                INC L
                LD (HL), A
                INC L
                LD (HL), A
                INC L
                LD (HL), A
                INC L
                LD (HL), A
                INC L
                LD (HL), A
                INC L
                LD (HL), A
                POP HL

                ; -----------------------------------------
                ; Out:
                ;   B - значение для основного порта (#7FFD)
                ;   C - значение для дополнительного порта (#1FFD/#7FFD/#DFFD/#FDFD/FFF7)
                ; -----------------------------------------

                ; сохранение значения переключившие страницу в буфере значений переключения страниц
                EX (SP), HL
                INC L
                LD (HL), B
                INC L
                LD (HL), C
                EX (SP), HL

                EX AF, AF'
                INC A                                                           ; увеличение счётчика доступных страниц
                LD (HL), #FF                                                    ; затереть номер определённой страницы
                EX AF, AF'

.NextPage       ; переход к следующей странице
                DEC D
                JR NZ, .CheckPage_Loop
                POP BC                                                          ; удалить со стека адрес последнего элемента в буфере доступных страниц
                EX AF, AF'                                                      ; количество доступных страниц

                RET
; -----------------------------------------
; проверка порта #1FFD
; In:
; Out:
; Corrupt:
; Note:
;   Scorpion    256К  - используется 4-ый бит
;   Scorpion    1024K - используются 4-ый, 6-ой и 7-ой биты
;   KAY         256К  - используются 4-ый бит
;   KAY         1024K - используются 4-ый, 6-ой и 7-ой биты
; -----------------------------------------
_1FFD:          LD HL, SetPage_1FFD
                JP CheckPort

.Select         ; установка флага выбора данного порта
                LD HL, Determine.MemPort
                SET SELECT_PORT_1FFD_BIT, (HL)

                ; копирование блок кода для переключения страниц, через дополнительный порт
                LD HL, .Extended
                LD DE, SetPage.Extended
                LD BC, .Size
                LDIR
                RET

.Extended       ; копируемый блок кода, дополняющий основную функцию переключения страниц памяти
                INC L
                LD A, (HL)
                LD B, #1F
                OUT (C), A
                POP HL
                RET
.Size           EQU $-.Extended
; -----------------------------------------
; проверка порта #7FFD
; In:
; Out:
; Corrupt:
; Note:
;   Pentagon    256K  - используется 6-ой бит
;   Pentagon    512K  - используются 6-ой и 7-ой биты
;   Pentagon    1024K - используются 5-ый, 6-ой и 7-ой биты
;                       перед использованием, необходимо убедиться чтобы 5-ый бит 
;                       не заблокировал доступ к памяти 48кб+
;                       проверив наличие порта #EFF7
; -----------------------------------------
_7FFD:          ; проверка наличия порта #EFF7, включением 0-ой страницу ОЗУ в область #0000..#3FFF
                LD BC, PORT_EFF7
                ifdef _DEBUG
                LD A, SET_RAM_To_ROM | DISABLE_TURBO
                else
                LD A, SET_RAM_To_ROM
                endif
                OUT (C), A

                ; проверка записи в установленную 0-ю страницу ОЗУ в области #0000..#3FFF
                LD A, #FF
                LD HL, #0000
                LD (HL), A
                CP (HL)
                JR NZ, .SetPort                                                 ; переход, если порт отсутствует
                
                ; сброс порта, отключение 0-ой страницы ОЗУ в области #0000..#3FFF
                ifdef _DEBUG
                LD A, DISABLE_TURBO
                else
                XOR A
                endif
                OUT (C), A

                ; установка вспомогательного флага наличия порта #EFF7
                LD HL, Determine.MemPort
                SET SELECT_PORT_EFF7_BIT, (HL)                                  ; вкл бит наличия порта

                ; ToDo сделать включение только в ручном режиме
                ; 5-ый бит порта #7FFD можно использовать
                ; LD HL, SetPage_7FFD._5_bit
                ; SET 5, (HL)
                ; LD HL, SetPort_7FFD._5_bit
                ; RES 5, (HL)
                ; LD HL, SetPage._5_bit
                ; RES 5, (HL)

.SetPort        LD HL, SetPage_7FFD
                JP CheckPort

.Select         ; установка флага выбора данного порта
                LD HL, Determine.MemPort
                SET SELECT_PORT_7FFD_BIT, (HL)                                  ; вкл бит наличия порта
                RET
; -----------------------------------------
; проверка порта #DFFD
; In:
; Out:
; Corrupt:
; Note:
;   Profi       256К-1024К - используются 0-ой, 1-ый и 2-ой биты
; -----------------------------------------
_DFFD:          LD HL, SetPage_DFFD
                JP CheckPort

.Select         ; установка флага выбора данного порта
                LD HL, Determine.MemPort
                SET SELECT_PORT_DFFD_BIT, (HL)

                ; копирование блок кода для переключения страниц, через дополнительный порт
                LD HL, .Extended
                LD DE, SetPage.Extended
                LD BC, .Size
                LDIR
                RET

.Extended       ; копируемый блок кода, дополняющий основную функцию переключения страниц памяти
                INC L
                LD A, (HL)
                LD B, #DF
                OUT (C), A
                POP HL
                RET
.Size           EQU $-.Extended
; -----------------------------------------
; проверка порта #FDFD
; In:
; Out:
; Corrupt:
; Note:
;   ATM1        512K  - используются 0-ой и 1-ый биты
;   ATM1        1024K - используются 0-ой, 1-ый и 2-ой биты
; -----------------------------------------
_FDFD:          LD HL, SetPage_FDFD
                JP CheckPort

.Select         ; установка флага выбора данного порта
                LD HL, Determine.MemPort
                SET SELECT_PORT_FDFD_BIT, (HL)

                ; копирование блок кода для переключения страниц, через дополнительный порт
                LD HL, .Extended
                LD DE, SetPage.Extended
                LD BC, .Size
                LDIR
                RET

.Extended       ; копируемый блок кода, дополняющий основную функцию переключения страниц памяти
                INC L
                LD A, (HL)
                LD B, #FD
                OUT (C), A
                POP HL
                RET
.Size           EQU $-.Extended
; -----------------------------------------
; проверка порта #FFF7
; In:
; Out:
; Corrupt:
; Note:
;   ATM2        1024K - используются 3-ой, 4-ый b 5-ый биты
; -----------------------------------------
_FFF7:          LD HL, SetPage_FFF7
                JP CheckPort

.Select         ; установка флага выбора данного порта
                LD HL, Determine.MemPort
                SET SELECT_PORT_FFF7_BIT, (HL)

                ; копирование блок кода для переключения страниц, через дополнительный порт
                LD HL, .Extended
                LD DE, SetPage.Extended
                LD BC, .Size
                LDIR
                RET

.Extended       ; копируемый блок кода, дополняющий основную функцию переключения страниц памяти
                INC L
                LD A, (HL)
                POP HL
.Out_FFF7       LD BC, TRDOS.EXE_OUT_C                                          ; адрес OUT (C), A : RET
                PUSH BC
                LD BC, #FFF7
                JP TRDOS.EXE_RET
.Size           EQU $-.Extended
; -----------------------------------------
; установка страницы используя порт #1FFD
; In:
;   D - номер страницы
; Out:
; Corrupt:
;   BC, AF
; Note:
;   Scorpion    256К  - используется 4-ый бит
;   Scorpion    1024K - используются 4-ый, 6-ой и 7-ой биты
;   KAY         256К  - используются 4-ый бит
;   KAY         1024K - используются 4-ый, 6-ой и 7-ой биты
; -----------------------------------------
SetPage_1FFD    LD A, Const.MaxPages
                SUB D
                LD E, A             ; xx543210
                ADD A, A            ; x543210x
                XOR E
                AND %01110000
                XOR E               ; x5433210
                ADD A, A            ; 5433210x
                AND %11010000       ; 54030000
                LD BC, PORT_1FFD
                OUT (C), A
                JR SetPort_7FFD
; -----------------------------------------
; установка страницы используя порт #DFFD
; In:
;   D - номер страницы
; Out:
; Corrupt:
;   BC, AF
; Note:
;   Profi       256К-1024К - используются 0-ой, 1-ый и 2-ой биты
; -----------------------------------------
SetPage_DFFD    LD A, Const.MaxPages
                SUB D
                LD E, A     ; xx543210
                RRA         ; xxx54321
                RRA         ; xxxx5432
                RRA         ; xxxxx543
                AND %00000111
                LD BC, PORT_DFFD
                OUT (C), A
                JR SetPort_7FFD
; -----------------------------------------
; установка страницы используя порт #FDFD
; In:
;   D - номер страницы
; Out:
; Corrupt:
;   BC, AF
; Note:
;   ATM1        512K  - используются 0-ой и 1-ый биты
;   ATM1        1024K - используются 0-ой, 1-ый и 2-ой биты
; -----------------------------------------
SetPage_FDFD    LD A, Const.MaxPages
                SUB D
                LD E, A     ; xx543210
                RRA         ; xxx54321
                RRA         ; xxxx5432
                RRA         ; xxxxx543
                AND %00000111
                LD BC, PORT_FDFD
                OUT (C), A
                JR SetPort_7FFD
; -----------------------------------------
; установка страницы используя порт #FFF7
; In:
;   D - номер страницы
; Out:
; Corrupt:
;   BC, AF
; Note:
;   ATM2        1024K - используются 3-ой, 4-ый b 5-ый биты
; -----------------------------------------
SetPage_FFF7    LD A, Const.MaxPages
                SUB D
                LD E, A         ; xx543210
                AND %00111000   ; 00543000
                CPL
.Out_FFF7       LD BC, SetPort_7FFD
                PUSH BC
                LD BC, TRDOS.EXE_OUT_C                                          ; адрес OUT (C), A : RET
                PUSH BC
                LD BC, #FFF7
                JP TRDOS.EXE_RET
; -----------------------------------------
; установка страницы используя порт #7FFD
; In:
;   D - номер страницы
; Out:
; Corrupt:
;   BC, AF
; Note:
;   Pentagon    256K  - используется 6-ой бит
;   Pentagon    512K  - используются 6-ой и 7-ой биты
;   Pentagon    1024K - используются 5-ый, 6-ой и 7-ой биты
;                       перед использованием, необходимо убедиться чтобы 5-ый бит 
;                       не заблокировал доступ к памяти 48кб+
;                       проверив наличие порта #EFF7
; -----------------------------------------
SetPage_7FFD    LD A, Const.MaxPages
                SUB D
                LD E, A     ; xx543210
                ADD A, A    ; x543210x
                ADD A, A    ; 543210xx
                XOR E
._5_bit         EQU $+1
                AND %11000000
                XOR E
                LD E, A
; -----------------------------------------
; установка страницы используя порт #7FFD
; In:
;   E - значение для записи в порт
; Out:
;   B - значение для основного порта (#7FFD)
;   C - значение для дополнительного порта (#1FFD/#7FFD/#DFFD/#FDFD/FFF7)
; Corrupt:
;   BC, AF
; Note:
; -----------------------------------------
SetPort_7FFD    PUSH AF
                LD BC, PORT_7FFD
                LD A, (BC)
                XOR E
._5_bit         EQU $+1
                AND %00111000                                                   ; PAGE_MASK_INV
                XOR E
                LD (BC), A
                OUT (C), A
                POP AF
                LD C, A

                ; корректировка значения основного порта
                LD A, (._5_bit)
                CPL
                AND E
                LD B, A

                RET

                include "Source/Memory/Message_InsufficientRAM.asm"
Determine.Size  EQU $-Begin

                display "\t- Memory determine:\t\t\t\t\t\t= busy [ ", /D, Determine.Size, " byte(s) ]"
                ENT
                endmodule

                endif ; ~ _MEMORY_DETERMINE_
