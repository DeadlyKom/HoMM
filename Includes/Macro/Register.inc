
                ifndef _MACRO_REGISTER_
                define _MACRO_REGISTER_
SET_REGISTER    macro IndexReg?, RegPair?
                LD A, LOW RegPair?
                LD LOW IndexReg?, A
                LD A, HIGH RegPair?
                LD HIGH IndexReg?, A
                endm

                endif ; ~_MACRO_REGISTER_
