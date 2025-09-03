
                ifndef _HERO_UTILS_HERO_ADDRESSES_
                define _HERO_UTILS_HERO_ADDRESSES_
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
Hero.Addresses: ; получить адрес героя
                CALL Hero.Utils.GetHeroAdr.IX

                ; получить адрес объекта
                LD A, (IX + FHero.ObjectID)
                JP Object.Utils.GetAdr.IY

                endif ; ~_HERO_UTILS_HERO_ADDRESSES_
