
                ifndef _MODULE_MAP_INCLUDE_
                define _MODULE_MAP_INCLUDE_

                include "Kernal.asm"                                            ; (0)
                include "Load.asm"
                include "Load_Objects.asm"
                include "Save.asm"
MapPage         DB #00                                                          ; страница расположения загруженого FAssets'а карты

                endif ; ~_MODULE_WORLD_INCLUDE_
