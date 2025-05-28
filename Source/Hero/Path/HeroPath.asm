
                ifndef _HERO_PATH_HERO_PATH_
                define _HERO_PATH_HERO_PATH_
; -----------------------------------------
; получить длину пути героя
; In:
;   A - идентификатор героя
; Out:
;   A - длина пути
; Corrupt:
; Note:
; -----------------------------------------
GetHeroPath:    ; получить адрес героя
                CALL Hero.Utils.GetAdrIX 

                ; получить адрес объекта
                LD A, (IX + FHero.ObjectID)
                CALL Object.Utils.GetAdrIY

                LD A, (IY + FObjectHero.PathID)
                RET
; -----------------------------------------
; установить длины пути героя
; In:
;   A - идентификатор героя
;   C - длина пути
; Out:
; Corrupt:
; Note:
; -----------------------------------------
SetHeroPath:    ; получить адрес героя
                CALL Hero.Utils.GetAdrIX 

                ; получить адрес объекта
                LD A, (IX + FHero.ObjectID)
                CALL Object.Utils.GetAdrIY

                ; установка длины пути
                DEC C
                LD (IY + FObjectHero.PathID), C
                RET

                endif ; ~_HERO_PATH_HERO_PATH_
