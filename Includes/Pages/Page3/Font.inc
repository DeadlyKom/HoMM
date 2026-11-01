
                ifndef _PAGE_3_FONT_
                define _PAGE_3_FONT_
Font:
.Load                   EQU Page3.Font.Load                                     ; загрузка шрифта
.Draw.Glyph             EQU Page3.Font.Draw.Glyph                               ; отображение глифа без поддержки обрезки
.Draw.Color.Glyph       EQU Page3.Font.Draw.Color.Glyph                         ; отображение цветного глифа без поддержки обрезки
.Draw.Color.Attribute   EQU Page3.Font.Draw.Color.Glyph.Attribute               ; цвет глифа
.Draw.String            EQU Page3.Font.Draw.String                              ; отображение строки без поддержки обрезки
.Draw.Color.String      EQU Page3.Font.Draw.ColorString                         ; отображение цветной строки без поддержки обрезки
.GetWidth               EQU Page3.Font.GetWidth                                 ; ширина строки в пикселях с учётом кернинга

                endif ; ~_PAGE_3_FONT_
