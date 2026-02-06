
                ifndef _WORLD_UI_LAYERS_
                define _WORLD_UI_LAYERS_
MAKE_UI_LAYER   macro ArrayAdr?, ArraySize?, Flags?
                FUILayer {
                    Flags?,
                    ArraySize?,
                    ArrayAdr?
                }
                endm
MAKE_UI_ELEMENT macro LocationX?, LocationY?, SizeX?, SizeY?, HandlerAdr?, Flags?
                FUIElement {
                    Flags?,
                    HandlerAdr?,
                    {LocationX?, LocationY?},
                    {SizeX?, SizeY?}
                }
                endm
Layers:         ; слои игрового окна
                MAKE_UI_LAYER GameWorld, GameWorld.ElementNum, LAYER_UI_VISIBLE
.Num            EQU ($-Layers) / FUILayer

GameWorld:      ; игровой слой
                MAKE_UI_ELEMENT \
                SCR_WORLD_POS_X << 3, SCR_WORLD_POS_Y << 3, \
                SCR_WORLD_SIZE_X << 3, SCR_WORLD_SIZE_Y << 3, \
                World.UI.Handler.GameWindow, \
                UI_VISIBLE | UI_ENABLED
                
                MAKE_UI_ELEMENT \
                SCR_MINIMAP_POS_X << 3, SCR_MINIMAP_POS_Y << 3, \
                SCR_MINIMAP_SIZE_X << 3, SCR_MINIMAP_SIZE_Y << 3, \
                World.UI.Handler.Minimap, \
                UI_VISIBLE | UI_ENABLED
.ElementNum     EQU ($-GameWorld) / FUIElement

                display " - UI layers:\t\t\t\t\t\t", /A, Layers, "\t= busy [ ", /D, $-Layers, " byte(s)  ]"
    
                endif ; ~ _WORLD_UI_LAYERS_
