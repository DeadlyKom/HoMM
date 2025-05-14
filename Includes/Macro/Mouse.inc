
                ifndef _MACRO_MOUSE_
                define _MACRO_MOUSE_
SET_MOUSE_POSITION macro X?, Y?
                LD HL, ((Y?) << 8) | (X?)
                LD (Mouse.Position), HL
                CALL Mouse.Init.Reset
                endm

                endif ; ~_MACRO_MOUSE_
