
                ifndef _PAGE_3_FONT_
                define _PAGE_3_FONT_
Font:
.Load           EQU Page3.Font.Load                                             ; загрузка шрифта
.Draw           EQU Page3.Font.Draw                                             ; отображение символа без поддержки обрезки
.DrawString     EQU Page3.Font.Draw.String                                      ; отображение строки без поддержки обрезки

                endif ; ~_PAGE_3_FONT_
