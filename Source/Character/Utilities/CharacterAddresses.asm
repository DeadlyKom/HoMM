
                ifndef _CHARACTER_UTILITIES_HERO_ADDRESSES_
                define _CHARACTER_UTILITIES_HERO_ADDRESSES_
; -----------------------------------------
; получить адреса персонажа
; In:
;   A  - индекс персонажа
; Out:
;   IX - адрес персонажа        (FCharacter)
;   IY - адрес объекта персонажа(FObjectCharacter)
; Corrupt:
;   HL, AF, IX, IY
; Note:
; -----------------------------------------
Character.Addresses: ; получить адрес героя
                CALL Character.Utilities.GetAdr.IX

                ; получить адрес объекта
                LD A, (IX + FCharacter.ObjectID)
                JP Object.Utilities.GetAdr.IY

                endif ; ~_CHARACTER_UTILITIES_HERO_ADDRESSES_
