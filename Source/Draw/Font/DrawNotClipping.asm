
                ifndef _DRAW_FONT_SPRITE_NOT_CLIPPING_
                define _DRAW_FONT_SPRITE_NOT_CLIPPING_
; -----------------------------------------
; отображение символа (без ограничений)
; In:
; Out:
; Corrupt:
; Note:
;   ⚠️ ВАЖНО ⚠️
;   - спрайт не проверяется на границы экрана и не обрезается
;   - спрайт перед отрисовкой не копируется в буфер
;   - спрайт выводится только в основное окно (#4000)
;
;   функция временно использует стек для чтения данных спрайта через POP BC
;   защита при разрешённых прерываниях устанавливается внутри функции через RESTORE_BC
;
;   ℹ️ структура шрифта, см FFont
; -----------------------------------------
DrawNotClipping:
                RET

                display " - Draw font not clipping:\t\t\t\t", /A, DrawNotClipping, "\t= busy [ ", /D, $-DrawNotClipping, " byte(s)  ]"

                endif ; ~ _DRAW_FONT_SPRITE_NOT_CLIPPING_
