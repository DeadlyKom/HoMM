
                ifndef _DECOMPRESSOR_BACKWARD_
                define _DECOMPRESSOR_BACKWARD_

                module Decompressor
; -----------------------------------------------------------------------------
; ZX0 decoder by Einar Saukas
; "Standard" version (69 byte(s) only) - BACKWARDS VARIANT
; decompressor  https://github.com/einar-saukas/ZX0
; -----------------------------------------------------------------------------
; Parameters:
;   HL: last source address (compressed data)
;   DE: last destination address (decompressing)
; -----------------------------------------------------------------------------
Backward:       LD BC, #0001                                                    ; preserve default offset 1
                PUSH BC
                LD A, #80

.Literals       CALL .Elias                                                     ; obtain length
                LDDR                                                            ; copy literals
                INC C
                ADD A, A                                                        ; copy from last offset or new offset?
                JR C, .NewOffset
                CALL .Elias                                                     ; obtain length

.Copy           EX (SP), HL                                                     ; preserve source, restore offset
                PUSH HL                                                         ; preserve offset
                ADD HL, DE                                                      ; calculate destination - offset
                LDDR                                                            ; copy from offset
                INC C
                POP HL                                                          ; restore offset
                EX (SP), HL                                                     ; preserve offset, restore source
                ADD A, A                                                        ; copy from literals or new offset?
                JR NC, .Literals

.NewOffset      INC SP                                                          ; discard last offset
                INC SP
                CALL .Elias                                                     ; obtain offset MSB
                DEC B
                RET Z                                                           ; check end marker
                DEC C                                                           ; adjust for positive offset
                LD B, C
                LD C, (HL)                                                      ; obtain offset LSB
                DEC HL
                SRL B                                                           ; last offset bit becomes first length bit
                RR C
                INC BC
                PUSH BC                                                         ; preserve new offset
                LD BC, #0001                                                    ; obtain length
                CALL C, .EliasBacktrack
                INC BC
                JR .Copy

.EliasBacktrack ADD A, A
                RL C
                RL B

.Elias          ADD A, A                                                        ; inverted interlaced Elias gamma coding
                JR NZ, .Elias_skip
                LD A, (HL)                                                      ; load another group of 8 bits
                DEC HL
                RLA

.Elias_skip     JR C, .EliasBacktrack
                RET
Backward.Size   EQU $-Backward
                display " - Decompressor backward: \t\t\t\t", /A, Backward, "\t= busy [ ", /D, Backward.Size, " byte(s)  ]"

                endmodule

                endif ; ~ _DECOMPRESSOR_BACKWARD_
