
                ifndef _MACRO_MEMSET_
                define _MACRO_MEMSET_
; -----------------------------------------
; заполнение области значением
; In:
; Out:
;   Destination? - адрес назначения
;   Value?       - заполняемое значение (байт)
;   Size?        - размер заполнения
; Corrupt:
;   HL, DE, AF, IX
; Note:
; -----------------------------------------
MEMSET_BYTE:    macro Destination?, Value?, Size?
                LD HL, (Destination? + Size?) & 0xFFFF
                LD DE, (((Value?) << 8) | (Value?)) & 0xFFFF

                if     (Size?) == 32
                CALL SafeFill.b32
                elseif (Size?) == 64
                CALL SafeFill.b64
                elseif (Size?) == 128
                CALL SafeFill.b128
                elseif (Size?) == 192
                CALL SafeFill.b192
                elseif (Size?) == 256
                CALL SafeFill.b256
                elseif (Size?) == 512
                CALL SafeFill.b512
                elseif (Size?) == 768
                CALL SafeFill.b768
                elseif (Size?) == 1024
                CALL SafeFill.b1024
                elseif (Size?) == 2048
                CALL SafeFill.b2048
                elseif (Size?) == 4096
                CALL SafeFill.b4096
                elseif (Size?) == 6144
                CALL SafeFill.Screen
                else
                display "# set size: ", Size?
                error "memset: is no suitable case!"
                DS 3, 0     ; CALL xxxx
                endif
                endm
JP_MEMSET_BYTE: macro Destination?, Value?, Size?
                LD HL, (Destination? + Size?) & 0xFFFF
                LD DE, (((Value?) << 8) | (Value?)) & 0xFFFF

                if     (Size?) == 32
                JP SafeFill.b32
                elseif (Size?) == 64
                JP SafeFill.b64
                elseif (Size?) == 128
                JP SafeFill.b128
                elseif (Size?) == 192
                JP SafeFill.b192
                elseif (Size?) == 256
                JP SafeFill.b256
                elseif (Size?) == 512
                JP SafeFill.b512
                elseif (Size?) == 768
                JP SafeFill.b768
                elseif (Size?) == 1024
                JP SafeFill.b1024
                elseif (Size?) == 2048
                JP SafeFill.b2048
                elseif (Size?) == 4096
                JP SafeFill.b4096
                elseif (Size?) == 6144
                JP SafeFill.Screen
                else
                display "# set size: ", Size?
                error "memset: is no suitable case!"
                DS 3, 0     ; JP xxxx
                endif
                endm
MEMSET_WORD:    macro Destination?, Value?, Size?
                LD HL, (Destination? + Size?) & 0xFFFF
                LD DE, (Value?) & 0xFFFF

                if     (Size?) == 32
                CALL SafeFill.b32
                elseif (Size?) == 64
                CALL SafeFill.b64
                elseif (Size?) == 128
                CALL SafeFill.b128
                elseif (Size?) == 192
                CALL SafeFill.b192
                elseif (Size?) == 256
                CALL SafeFill.b256
                elseif (Size?) == 512
                CALL SafeFill.b512
                elseif (Size?) == 768
                CALL SafeFill.b768
                elseif (Size?) == 1024
                CALL SafeFill.b1024
                elseif (Size?) == 2048
                CALL SafeFill.b2048
                elseif (Size?) == 4096
                CALL SafeFill.b4096
                elseif (Size?) == 6144
                CALL SafeFill.Screen
                else
                display "# set size: ", Size?
                error "memset: is no suitable case!"
                DS 3, 0     ; CALL xxxx
                endif
                endm
JP_MEMSET_WORD: macro Destination?, Value?, Size?
                LD HL, (Destination? + Size?) & 0xFFFF
                LD DE, (Value?) & 0xFFFF

                if     (Size?) == 32
                JP SafeFill.b32
                elseif (Size?) == 64
                JP SafeFill.b64
                elseif (Size?) == 128
                JP SafeFill.b128
                elseif (Size?) == 192
                JP SafeFill.b192
                elseif (Size?) == 256
                JP SafeFill.b256
                elseif (Size?) == 512
                JP SafeFill.b512
                elseif (Size?) == 768
                JP SafeFill.b768
                elseif (Size?) == 1024
                JP SafeFill.b1024
                elseif (Size?) == 2048
                JP SafeFill.b2048
                elseif (Size?) == 4096
                JP SafeFill.b4096
                elseif (Size?) == 6144
                JP SafeFill.Screen
                else
                display "# set size: ", Size?
                error "memset: is no suitable case!"
                DS 3, 0     ; JP xxxx
                endif
                endm

                endif ; ~_MACRO_MEMSET_
