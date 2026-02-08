
                ifndef _HERO_UTILITIES_HERO_ADDRESSES_
                define _HERO_UTILITIES_HERO_ADDRESSES_
; -----------------------------------------
; получить адреса героя
; In:
;   A  - индекс героя
; Out:
;   IX - адрес героя            (FHero)
;   IY - адрес объекта героя    (FObjectHero)
; Corrupt:
;   HL, AF, IX, IY
; Note:
; -----------------------------------------
Hero.Addresses: ; получить адрес героя
                CALL Hero.Utilities.GetHeroAdr.IX

                ; получить адрес объекта
                LD A, (IX + FHero.ObjectID)
                JP Object.Utilities.GetAdr.IY

                endif ; ~_HERO_UTILITIES_HERO_ADDRESSES_
