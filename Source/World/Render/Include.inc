
                ifndef _WORLD_RENDER_INCLUDE_
                define _WORLD_RENDER_INCLUDE_

                module Render

                include "Draw.asm"
                include "Cursor.asm"
                include "Object/Include.inc"

Cursor.Indexes  DB #00                                                          ; "Idle"
                DB #00                                                          ; "Click"

                endmodule

                endif ; ~_WORLD_RENDER_INCLUDE_
