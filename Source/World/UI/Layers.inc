
                ifndef _WORLD_UI_LAYERS_
                define _WORLD_UI_LAYERS_
Layers:         ; слои игрового окна
.GameWorld      MAKE_UI_LAYER GameWorld, GameWorld.ElementNum, LAYER_UI_VISIBLE
.GameWorld.Num  EQU ($-Layers.GameWorld) / FUILayer
GameWorld:      ; игровой слой
                MAKE_UI_ELEMENT \
                SCR_WORLD_POS_X << 3, SCR_WORLD_POS_Y << 3, \
                SCR_WORLD_SIZE_X << 3, SCR_WORLD_SIZE_Y << 3, \
                World.UI.Handler.Layer_GameView, \
                UI_VISIBLE | UI_ENABLED

                MAKE_UI_ELEMENT \
                SCR_WORLD_ICONS_POS_X << 3, SCR_WORLD_ICONS_POS_Y << 3, \
                SCR_WORLD_ICONS_SIZE_X << 3, SCR_WORLD_ICONS_SIZE_Y << 3, \
                World.UI.Handler.Layer_GameUI, \
                UI_VISIBLE | UI_ENABLED
                
                MAKE_UI_ELEMENT \
                SCR_MINIMAP_POS_X << 3, SCR_MINIMAP_POS_Y << 3, \
                SCR_MINIMAP_SIZE_X << 3, SCR_MINIMAP_SIZE_Y << 3, \
                World.UI.Handler.Layer_Minimap, \
                UI_VISIBLE | UI_ENABLED
.ElementNum     EQU ($-GameWorld) / FUIElement
                display " - UI layers:\t\t\t\t\t\t", /A, Layers, "\t= busy [ ", /D, $-Layers, " byte(s)  ]"
    
                endif ; ~ _WORLD_UI_LAYERS_
