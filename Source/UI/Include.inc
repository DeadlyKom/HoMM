
                ifndef _UI_INCLUDE_
                define _UI_INCLUDE_

                module UI
                include "Layer/Update.asm"
                include "Runtime/Include.inc"
TooltipTimer    DB UI_TOOLTIP_HOVER_DELAY
                endmodule

                endif ; ~_UI_INCLUDE_
