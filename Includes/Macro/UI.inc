
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
                
                endif ; ~_MACRO_UI_
