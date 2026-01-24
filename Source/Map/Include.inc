
                ifndef _MAP_INCLUDE_
                define _MAP_INCLUDE_

                module Map

;                 LD HL, Adr.MapMetadata
;                 LD BC, HIGH Size.MapMetadata
; .Loop           RES MAP_META_CLOSE_LIST_BIT, (HL)
;                 INC L
;                 DJNZ .Loop
;                 INC H
;                 DEC C
;                 JR NZ, .Loop

;                 LD HL, Adr.MapMetadata
;                 LD DE, #0008
;                 XOR A
;                 LD B, A
; .Loop_256       LD (HL), A
;                 ADD HL, DE
;                 DJNZ .Loop_256
; .Loop_512       LD (HL), A
;                 ADD HL, DE
;                 DJNZ .Loop_512

;                 LD HL, Adr.MapBiome + смещение
;                 LD A, L
;                 AND #07
;                 ADD A, A    ; x2
;                 ADD A, A    ; x4
;                 ADD A, A    ; x8
;                 OR #46                                                          ; BIT n, (HL)
;                 LD (.BIT), A
;                 LD A, L
;                 AND %11111000
;                 OR MAP_META_CLOSE_LIST_BIT
; .BIT            EQU $+1                                                         ; BIT n, (HL)
;                 DB #CB, #00



                endmodule

                endif ; ~ _MAP_INCLUDE_