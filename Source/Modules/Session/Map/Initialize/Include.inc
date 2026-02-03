
                ifndef _MODULE_SESSION_MAP_INITIALIZE_INCLUDE_
                define _MODULE_SESSION_MAP_INITIALIZE_INCLUDE_

                module Initialize
                include "Initial.asm"
                include "Objects.asm"
                include "BaseGraphics.asm"
                include "GraphicsPackages.asm"
                include "Source/TableGeneration/TG_MapAdrTable.asm"
                endmodule

                endif ; ~_MODULE_SESSION_MAP_INITIALIZE_INCLUDE_
