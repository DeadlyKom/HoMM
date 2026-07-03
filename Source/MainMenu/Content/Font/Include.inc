
                ifndef _MAIN_MENU_CONTENT_FONT_INCLUDE_
                define _MAIN_MENU_CONTENT_FONT_INCLUDE_

                module Font
                include "Load.asm"
                include "Release.asm"
Page            DB #00                                                          ; страница расположения загруженого FAssets'а
Adr             DW #0000                                                        ; адрес расположения таблицы шрифта
                endmodule

                endif ; ~_MAIN_MENU_CONTENT_FONT_INCLUDE_
