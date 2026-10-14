
                ifndef _MACRO_UI_
                define _MACRO_UI_
SET_UI_MODE     macro Mode?
                LD A, Mode?
                LD (GameState.UIRuntime + FUIRuntime.Mode), A
                LD (GameState.UIRuntime + FUIRuntime.PreviousMode), A
                XOR A                                                           ; UI_MODE_NONE 
                LD (GameState.UIRuntime + FUIRuntime.RequestedMode), A
                LD (GameState.UIRuntime + FUIRuntime.Flags), A                  ; сброс флагов
                endm
SET_UI_LAYER    macro LayerAdr?, LayersNum?
                LD A, LayersNum?
                LD (GameState.UIRuntime + FUIRuntime.LayersNum), A
                LD HL, LayerAdr?
                LD (GameState.UIRuntime + FUIRuntime.LayerAdr), HL
                endm
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

                endif ; ~_MACRO_UI_
