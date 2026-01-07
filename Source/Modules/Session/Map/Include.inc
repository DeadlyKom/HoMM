
                ifndef _MODULE_SESSION_MAP_INCLUDE_
                define _MODULE_SESSION_MAP_INCLUDE_

                include "Load_Map.asm"
                include "Load_BaseGraphics.asm"
                include "Load_GraphicsPackages.asm"
                
                include "Initialize_Objects.asm"
                include "Initialize_BaseGraphics.asm"
                include "Initialize_GraphicsPackages.asm"

                align 256, #55
BaseGraphicsBuffer: DS 256, 0
                
                endif ; ~_MODULE_SESSION_MAP_INCLUDE_
