
                ifndef _CHARACTER_UTILITIES_CHARACTER_POSITION_
                define _CHARACTER_UTILITIES_CHARACTER_POSITION_
; -----------------------------------------
; получить позицию персонажа в гексагонах (обёртка)
; In:
;   E - индекс персонажа (CharacterID)
; Out:
;   DE - координаты персонажа (D - y, E - x) в гексах
; Corrupt:
; Note:
; -----------------------------------------
Character.Position.Wrap:
                LD A, E
; -----------------------------------------
; получить позицию персонажа в гексагонах
; In:
;   A  - индекс персонажа (CharacterID)
; Out:
;   DE - координаты персонажа (D - y, E - x) в гексах
; Corrupt:
; Note:
; -----------------------------------------
Character.Position:
                ; -----------------------------------------
                ; получить адреса персонажа
                ; In:
                ;   A  - индекс персонажа
                ; Out:
                ;   IX - адрес персонажа            (FCharacter)
                ;   IY - адрес объекта персонажа    (FObjectCharacter)
                ; Corrupt:
                ;   HL, AF, IX, IY
                ; Note:
                ;   ℹ️ код расположен в странице 0
                ; -----------------------------------------
                CALL Character.Utilities.GetAdr

                LD D, (IY + FObject.Position.Y.High)
                LD E, (IY + FObject.Position.X.High)
                RET

                endif ; ~_CHARACTER_UTILITIES_CHARACTER_POSITION_
