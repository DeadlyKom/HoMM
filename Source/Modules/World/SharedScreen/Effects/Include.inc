                ifndef _WORLD_SCREEN_EFFECTS_INCLUDE_
                define _WORLD_SCREEN_EFFECTS_INCLUDE_

                module Effects
                ; выбор единственного погодного эксперимента для размещения в странице 7
                if WEATHER_TORNADO_ON
                include "Source/Modules/World/SharedScreen/Effects/ParticleDraw.asm"
                include "Source/Modules/World/SharedScreen/Effects/Tornado.asm"
                else
                if WEATHER_RAIN_ON || WEATHER_SNOW_ON || WEATHER_STORM_ON
                include "Source/Modules/World/SharedScreen/Effects/Rain.asm"
                endif
                if WEATHER_SNOW_ON
                include "Source/Modules/World/SharedScreen/Effects/Snow.asm"
                endif
                endif
                include "Source/Modules/World/SharedScreen/Effects/Weather.asm"
                ; исключение кода грозы на время пробы смерча
                if WEATHER_STORM_ON
                include "Source/Modules/World/SharedScreen/Effects/LightningBolt.asm"
                include "Source/Modules/World/SharedScreen/Effects/Lightning.asm"
                endif
                endmodule

                endif                                                           ; ~_WORLD_SCREEN_EFFECTS_INCLUDE_
