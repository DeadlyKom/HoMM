
                ifndef _MACRO_REGISTER_
                define _MACRO_REGISTER_
SET_REGISTER    macro DstRegPair?, SrcRegPair?
                LD A, LOW SrcRegPair?
                LD LOW DstRegPair?, A
                LD A, HIGH SrcRegPair?
                LD HIGH DstRegPair?, A
                endm

                endif ; ~_MACRO_REGISTER_
