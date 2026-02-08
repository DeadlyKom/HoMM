
                ifndef _HERO_UTILITIES_MEMORY_COPY_HERO_OBJECT_
                define _HERO_UTILITIES_MEMORY_COPY_HERO_OBJECT_
; -----------------------------------------
; копировать объект "герой"
; In:
;   DE' - адрес копирования объекта
;   E'  - идентификатора героя
; Out:
; Corrupt:
; Note:
; -----------------------------------------
MemcpyHeroObject; 
                EXX
                ; -----------------------------------------
                ; получить адреса героя
                ; In:
                ;   A  - индекс героя
                ; Out:
                ;   IX - адрес героя            (FHero)
                ;   IY - адрес объекта героя    (FObjectHero)
                ; Corrupt:
                ; Note:
                ; -----------------------------------------
                LD A, E
                CALL Hero.Utilities.GetHeroAdr

                ; копирование FHero
                PUSH IX
                POP HL
                LD A, E
                LD IXL, A
                LD A, D
                LD IXH, A
                LD BC, HERO_SIZE
                CALL Memcpy.FastLDIR

                ; копирование FObjectHero
                PUSH IY
                POP HL
                LD A, E
                LD IYL, A
                LD A, D
                LD IYH, A
                LD C, OBJECT_SIZE
                JP Memcpy.FastLDIR

                endif ; ~_HERO_UTILITIES_MEMORY_COPY_HERO_OBJECT_
