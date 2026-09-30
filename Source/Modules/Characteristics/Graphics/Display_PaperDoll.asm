
                ifndef _MODULE_CHARACTERISTICS_GRAPHICS_DISPLAY_PAPER_DOLL_
                define _MODULE_CHARACTERISTICS_GRAPHICS_DISPLAY_PAPER_DOLL_
; -----------------------------------------
; отображение "образа персонажа"
; In:
; Out:
; Corrupt:
; Note:
;    ℹ️ адрес исполнения неизвестен
; -----------------------------------------
PaperDoll:      ; отображение "образа персонажа"
                PUSH_PAGE                                                       ; сохранить текущую страницу кода
                LD HL, Func.PopPage
                PUSH HL                                                         ; сохранить адрес функции востановления страницы
                
                LD HL, Draw.SpriteNotBound
                PUSH HL                                                         ; сохранение адреса функции

.Page           EQU $+1
                LD A, #00

.Address        EQU $+1
                LD HL, #0000
                JP_SET_PAGE_A                                                   ; включение страниц
                
                endif ; ~_MODULE_CHARACTERISTICS_GRAPHICS_DISPLAY_PAPER_DOLL_
