
                ifndef _DRAW_FONT_INCLUDE_
                define _DRAW_FONT_INCLUDE_

                module Font
                include "GetWidth.asm"
                include "DrawColorGlyph.asm"                                    ; (0)
                include "DrawGlyph.asm"                                         ; (1)
                include "DrawString.asm"
                endmodule

                endif ; ~ _DRAW_FONT_INCLUDE_
