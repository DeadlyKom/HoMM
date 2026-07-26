
                ifndef _MODULE_PROGRESS_HINT_TEXT_
                define _MODULE_PROGRESS_HINT_TEXT_
Hint            DW .Text_1
.Num            EQU ($-Hint) / 2

.Text_1         DB #02                                                          ; количество строк в подсказке
                lua allpass
                Convert ("Мꙋдрый ратникъ знаѥтъ, когда")
                endlua
                DW #8F37                                                        ; позиция строки

                lua allpass
                Convert ("вложить мечь въ ножны.")
                endlua
                DW #9F4A                                                        ; позиция строки

                endif ; ~_MODULE_PROGRESS_HINT_TEXT_
