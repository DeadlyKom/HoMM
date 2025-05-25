
                ifndef _HERO_UTILS_MEMORY_COPY_PATH_
                define _HERO_UTILS_MEMORY_COPY_PATH_
; -----------------------------------------
; копирование пути в буфер Adr.HeroPath
; In:
; Out:
;   C - длина пути
; Corrupt:
; Note:
; -----------------------------------------
MemcpyHeroPath  ;
                LD HL, Adr.SharedBuffer
                LD DE, Adr.HeroPath
                LD C, (HL)
                INC L
                LD B, (HL)
                INC L
                PUSH BC
                CALL Memcpy.FastLDIR
                POP BC
                RR B
                RR C
                RET

                endif ; ~_HERO_UTILS_MEMORY_COPY_PATH_
