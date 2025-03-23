
                ifndef _MACRO_FUNCTIONS_
                define _MACRO_FUNCTIONS_
DELAY           macro Sec?
                LD B, Sec? * 50
                CALL Func.CustomDelay
                endm

                endif ; ~_MACRO_FUNCTIONS_
