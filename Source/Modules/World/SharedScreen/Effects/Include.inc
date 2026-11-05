                ifndef _WORLD_SCREEN_EFFECTS_INCLUDE_
                define _WORLD_SCREEN_EFFECTS_INCLUDE_

                module Effects
                include "Source/Modules/World/SharedScreen/Effects/Rain.asm"
                include "Source/Modules/World/SharedScreen/Effects/Snow.asm"
                include "Source/Modules/World/SharedScreen/Effects/Weather.asm"
                ; исключение кода грозы на время снежной пробы
                if WEATHER_STORM_ON
                include "Source/Modules/World/SharedScreen/Effects/LightningBolt.asm"
                include "Source/Modules/World/SharedScreen/Effects/Lightning.asm"
                endif
                endmodule

                endif                                                           ; ~_WORLD_SCREEN_EFFECTS_INCLUDE_
