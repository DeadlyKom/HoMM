
                ifndef _HERO_PATH_MEMORY_COPY_PATH_
                define _HERO_PATH_MEMORY_COPY_PATH_
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
                LD DE, Adr.HeroPath + 2                                         ; +2 добавлен для цикла в функции ReificationPath
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

                endif ; ~_HERO_PATH_MEMORY_COPY_HERO_PATH_
