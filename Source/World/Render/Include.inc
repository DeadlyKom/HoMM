
                ifndef _WORLD_RENDER_INCLUDE_
                define _WORLD_RENDER_INCLUDE_

                module Render
                include "Draw.asm"
                include "Object/Include.inc"
                include "UpdateMinimap.asm"
                include "PipelineHexagons.asm"
                ; исключение проверки всплесков при временно отключённом дожде
                if WEATHER_RAIN_ON
                include "RainVisible.asm"
                endif
                include "WeatherInput.asm"
                include "SetViewWorldBound.asm"

                ifdef _DEBUG
                include "DebugInfo.asm"
                endif

                endmodule

                endif ; ~_WORLD_RENDER_INCLUDE_
