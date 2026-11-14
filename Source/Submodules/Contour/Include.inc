
                ifndef _SUBMODULES_CONTOUR_INCLUDE_
                define _SUBMODULES_CONTOUR_INCLUDE_

                include "Memory/Size.inc"                                       ; размеры дополнительной памяти сабмодуля
                include "Kernel/Bind.inc"                                       ; (0)
                include "Launch.asm"
                include "Release.asm"
                include "Launch/Include.inc"
                include "Source/Draw/Sprite/Contour/Include.inc"
                include "Source/TableGeneration/TG_ContourTable.asm"

                endif ; ~_SUBMODULES_CONTOUR_INCLUDE_
