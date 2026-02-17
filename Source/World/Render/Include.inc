
                ifndef _WORLD_RENDER_INCLUDE_
                define _WORLD_RENDER_INCLUDE_

                module Render
                include "Draw.asm"
                include "Source/Cursor/Draw.asm"
                include "Object/Include.inc"
                include "UpdateMinimap.asm"
                include "PipelineHexagons.asm"
                include "SetViewWorldBound.asm"
                endmodule

                endif ; ~_WORLD_RENDER_INCLUDE_
