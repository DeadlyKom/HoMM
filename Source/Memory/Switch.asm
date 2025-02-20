
                ifndef _MEMORY_SWITCH_
                define _MEMORY_SWITCH_

                module Memory
Begin:          EQU $
; -----------------------------------------
; установка страницы в 3 банк памяти (#C000-#FFFF) из стека
; In:
;   A - номер страницы памяти (0-7)
; Out:
; Corrupt:
;   BC, AF
; Note:
; -----------------------------------------
SetPageStack:   POP AF
; -----------------------------------------
; установка страницы в 3 банк памяти (#C000-#FFFF)
; In:
;   A - номер страницы памяти (0-7)
; Out:
; Corrupt:
;   BC, AF
; Note:
; -----------------------------------------
SetPage:        PUSH HL
                LD HL, Adr.Port_7FFD + 1
                LD (HL), A
                DEC L

                XOR (HL)
                AND PAGE_MASK                                                   ; %11000111
                XOR (HL)
                LD (HL), A

                LD B, H
                LD C, L
                OUT (C), A
                POP HL
                RET
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
;   A - номер страницы памяти (0-63)
; Corrupt:
;   AF
; Note:
; -----------------------------------------
GetPage:        PUSH HL
                LD HL, Adr.Port_7FFD + 1
                LD A, (HL)
                POP HL
                RET

                display " - Memory switch: \t\t\t\t\t", /A, Begin, " = busy [ ", /D, $ - Begin, " byte(s)  ]"
                endmodule

                endif ; ~_MEMORY_SWITCH_
