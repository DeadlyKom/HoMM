
                ifndef _MAIN_MENU_MAIN_INTERRUPT_
                define _MAIN_MENU_MAIN_INTERRUPT_
; -----------------------------------------
; обработчик прерывания "гланого меню"
; In:
; Out:
; Corrupt:
; Note:
; -----------------------------------------
Interrupt:      RET

                display " - Main interrupt:\t\t\t\t\t", /A, Interrupt, "\t= busy [ ", /D, $-Interrupt, " byte(s)  ]"
    
                endif ; ~ _MAIN_MENU_MAIN_INTERRUPT_
