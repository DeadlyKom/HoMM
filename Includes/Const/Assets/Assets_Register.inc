
                ifndef _CONST_ASSETS_REGISTER_
                define _CONST_ASSETS_REGISTER_
ASSETS_ID_COUNTER   defl 0
REG_ASSETS_ID       macro Label?
Label?              EQU ASSETS_ID_COUNTER
ASSETS_ID_COUNTER   = ASSETS_ID_COUNTER + 1
                    endm
REG_ASSETS_ID_DEBUG macro Label?

                    ifdef _DEBUG
                    REG_ASSETS_ID Label?
                    endif

                    endm

                    REG_ASSETS_ID       ASSETS_ID_KERNEL                        ; кернел
                    REG_ASSETS_ID       ASSETS_ID_CORE                          ; ядро
                    REG_ASSETS_ID       ASSETS_ID_WORLD                         ; мир
                    REG_ASSETS_ID       ASSETS_ID_TILE_BIOME_GRASS_SAND         ; графика тайлов биома "трава-песок"
                    REG_ASSETS_ID       ASSETS_ID_MAP_DEBUG                     ; карта "отладочная"

                endif ; ~_CONST_ASSETS_REGISTER_
