
                ifndef _MEMORY_SWITCH_
                define _MEMORY_SWITCH_

                module Memory
Begin:          EQU $
; -----------------------------------------
; установка страницы в 3 банк памяти (#C000-#FFFF) из стека
; In:
;   A - номер страницы памяти (0-31)
; Out:
; Corrupt:
;   BC, AF
; Note:
; -----------------------------------------
SetPageStack:   POP AF
; -----------------------------------------
; установка страницы в 3 банк памяти (#C000-#FFFF)
; In:
;   A - номер страницы памяти (0-31)
; Out:
; Corrupt:
;   BC, AF
; Note:
;   ~время переключения страниц для разных портов до 150 тактов
; -----------------------------------------
SetPage:        PUSH HL
                LD BC, Adr.Port_7FFD + 1
                LD (BC), A
                DEC C

                ADD A, A    ; x2
                LD L, A
                LD H, HIGH Adr.MemoryMap

                LD A, (BC)
._5_bit         EQU $+1
                AND PAGE_MASK_INV                                               ; %00111000
                OR (HL)
                LD (BC), A
                OUT (C), A

.Extended       ; дополнительный блок кода, дополняющий основную функцию переключения страниц памяти
                POP HL
                RET
                DS 11, 0                                                        ; резервирование области для кода
; -----------------------------------------
; установка страницы видимого экрана
; In:
; Out:
; Corrupt:
;   BC, AF
; Note:
; -----------------------------------------
ScrPageToC000:  LD BC, Adr.Port_7FFD
                LD A, (BC)
                BIT SCREEN_BIT, A
                LD A, PAGE_5
                JR Z, SetPage
                LD A, PAGE_7
                JR SetPage
; -----------------------------------------
; установка страницы невидимого экрана
; In:
; Out:
; Corrupt:
;   BC, AF
; Note:
; -----------------------------------------
ScrPageToC000_: LD BC, Adr.Port_7FFD
                LD A, (BC)
                BIT SCREEN_BIT, A
                LD A, PAGE_5
                JR NZ, SetPage
                LD A, PAGE_7
                JR SetPage
; -----------------------------------------
; установка экрана расположенного в #C000
; In:
; Out:
; Corrupt:
;   BC, AF
; Note:
;   проверяется 1 бит, 
;   для 5 страницы равен 0
;   для 7 страницы равен 1
;   если будут другие страницы, ну сам дурак!
; -----------------------------------------
ScrFromPageC000 LD BC, Adr.Port_7FFD
                LD A, (BC)
                BIT 1, A
                JR Z, ShowBaseScreen
                JR ShowShadowScreen
; -----------------------------------------
; переключение экранов
; In:
; Out:
; Corrupt:
;   BC, AF
; Note:
; -----------------------------------------
SwapScreens:    LD BC, Adr.Port_7FFD
                LD A, (BC)
                XOR SCREEN
                LD (BC), A
                OUT (C), A
                RET
; -----------------------------------------
; отображение базового экрана
; In:
; Out:
; Corrupt:
;   BC, AF
; Note:
; -----------------------------------------
ShowBaseScreen: LD BC, Adr.Port_7FFD
                LD A, (BC)
                AND SCREEN_INV
                LD (BC), A
                OUT (C), A
                RET
; -----------------------------------------
; отображение теневого экрана
; In:
; Out:
; Corrupt:
;   BC, AF
; Note:
; -----------------------------------------
ShowShadowScreen: LD BC, Adr.Port_7FFD
                LD A, (BC)
                OR SCREEN
                LD (BC), A
                OUT (C), A
                RET
; -----------------------------------------
; получение текущего номера страницы
; In:
; Out:
;   A - номер страницы памяти (0-31)
; Corrupt:
;   AF
; Note:
; -----------------------------------------
GetPage:        PUSH HL
                LD HL, Adr.Port_7FFD + 1
                LD A, (HL)
                POP HL
                RET

                display " - Memory switch:\t\t\t\t\t", /A, Begin, "\t= busy [ ", /D, $ - Begin, " byte(s)  ]"
                endmodule

                endif ; ~_MEMORY_SWITCH_
