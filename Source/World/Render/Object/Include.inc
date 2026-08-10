
                ifndef _WORLD_RENDER_OBJECT_INCLUDE_
                define _WORLD_RENDER_OBJECT_INCLUDE_

                module Object
                include "BoundScreenBlock.asm"
                include "Draw.asm"
                include "UI/Include.inc"
                include "Decal/Include.inc"
                include "Simple/Include.inc"
                include "Character/Include.inc"
                include "LayerObject/Include.inc"
                include "ObjectsInView.asm"
                include "ObjectDirtyEnvironment.asm"
                endmodule

                endif ; ~_WORLD_RENDER_OBJECT_INCLUDE_
