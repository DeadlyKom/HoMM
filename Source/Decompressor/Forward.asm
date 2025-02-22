
                ifndef _DECOMPRESSOR_FORWARD_
                define _DECOMPRESSOR_FORWARD_

                module Decompressor
; -----------------------------------------------------------------------------
; ZX0 decoder by Einar Saukas & Urusergi
; "Standard" version (68 byte(s) only)
; decompressor  https://github.com/einar-saukas/ZX0
; -----------------------------------------------------------------------------
; Parameters:
;   HL: source address (compressed data)
;   DE: destination address (decompressing)
; -----------------------------------------------------------------------------
Forward:        LD BC, #FFFF                                                    ; preserve default offset 1
                PUSH BC
                INC BC
                LD A, #80

.Literals       CALL .Elias                                                     ; obtain length
                LDIR                                                            ; copy literals
                ADD A, A                                                        ; copy from last offset or new offset?
                JR C, .NewOffset
                CALL .Elias                                                     ; obtain length

.Copy           EX (SP), HL                                                     ; preserve source, restore offset
                PUSH HL                                                         ; preserve offset
                ADD HL, DE                                                      ; calculate destination - offset
                LDIR                                                            ; copy from offset
                POP HL                                                          ; restore offset
                EX (SP), HL                                                     ; preserve offset, restore source
                ADD A, A                                                        ; copy from literals or new offset?
                JR NC, .Literals

.NewOffset      POP BC                                                          ; discard last offset
                LD C, #FE                                                       ; prepare negative offset
                CALL .EliasLoop                                                 ; obtain offset MSB
                INC C
                RET Z                                                           ; check end marker
                LD B, C
                LD C, (HL)                                                      ; obtain offset LSB
                INC HL
                RR B                                                            ; last offset bit becomes first length bit
                RR C
                PUSH BC                                                         ; preserve new offset
                LD BC, #0001                                                    ; obtain length
                CALL NC, .EliasBacktrack
                INC BC
                JR .Copy

.Elias          INC C                                                           ; interlaced Elias gamma coding
.EliasLoop      ADD A, A
                JR NZ, .EliasSkip
                LD A, (HL)                                                      ; load another group of 8 bits
                INC HL
                RLA
.EliasSkip      RET C

.EliasBacktrack ADD A, A
                RL C
                RL B
                JR .EliasLoop
Forward.Size    EQU $-Forward
                display " - Decompressor forward: \t\t\t\t", /A, Forward, "\t= busy [ ", /D, Forward.Size, " byte(s)  ]"
                endmodule

                endif ; ~ _DECOMPRESSOR_FORWARD_
