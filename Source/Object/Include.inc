
                ifndef _OBJECT_INCLUDE_
                define _OBJECT_INCLUDE_

                module Object

                include "Initialize.asm"
                include "Spawn.asm"
                include "SmartRemove.asm"
                include "PlacementNew.asm"
                include "RemoveAtSwap.asm"
                include "FindLastByPredicate.asm"

                include "Class/Include.inc"
                include "Utils/Include.inc"

                endmodule

                endif ; ~_OBJECT_INCLUDE_
