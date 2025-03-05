
                ifndef _MACRO_TR_DOS_
                define _MACRO_TR_DOS_
SET_TR_DOS_FLAG macro FlagBit?
                LD HL, Adr.Stash_TRDOS
                SET_FLAG (FlagBit?)
                endm

                endif ; ~_MACRO_TR_DOS_
