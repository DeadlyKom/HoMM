
                ifndef _WORLD_TIME_INCLUDE_
                define _WORLD_TIME_INCLUDE_

                module WorldTime
                include "Tick.asm"
                include "IsWorldTick.asm"
                include "AdvanceEpoch.asm"

                ifdef _DEBUG
                include "DebugRender.asm"
                endif

                endmodule

                endif ; ~_WORLD_TIME_INCLUDE_
