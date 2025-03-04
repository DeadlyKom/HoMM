
                ifndef _MACRO_MOUSE_
                define _MACRO_MOUSE_
SET_MOUSE_POSITION macro X?, Y?
                LD BC, ((Y?) << 8) | (X?)
                LD (Mouse.Position), BC
                endm

                endif ; ~_MACRO_MOUSE_
