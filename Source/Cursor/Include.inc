
                ifndef _CURSOR_INCLUDE_
                define _CURSOR_INCLUDE_

                module Cursor
                include "Update.asm"
                include "Initialize.asm"
StateTable:
.Idle           ; CURSOR_STATE_IDLE
                DB #00
.Idle.SpriteID  DB #00
                DB DURATION.IDLE_CURSOR
                DB #03
.Click          ; CURSOR_STATE_CLICK
                DB #01
.Click.SpriteID DB #00
                DB DURATION.CLICK_CURSOR
                DB #02
                endmodule

                endif ; ~_CURSOR_INCLUDE_
