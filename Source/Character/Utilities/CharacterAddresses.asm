
                ifndef _CHARACTER_UTILITIES_HERO_ADDRESSES_
                define _CHARACTER_UTILITIES_HERO_ADDRESSES_
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
Character.Addresses: ; получить адрес героя
                CALL Character.Utilities.GetAdr.IX

                ; получить адрес объекта
                LD A, (IX + FCharacter.ObjectID)
                JP Object.Utilities.GetAdr.IY
; -----------------------------------------
; получить контекст героя для построения маршрута
; In:
;   BC' - координаты назначения; сохраняются без изменений
; Out:
;   DE' - текущие координаты героя (D - y, E - x)
;   IX  - адрес персонажа            (FCharacter)
;   IY  - адрес объекта персонажа    (FObjectCharacter)
; Corrupt:
;   HL, DE, AF, IX, IY
; Note:
;   ℹ️ код расположен в странице 0;
;   IX/IY остаются идентификатором конкретных слотов до завершения
;   синхронного Pathfinding.Request и проверяются перед записью маршрута
; -----------------------------------------
Character.RouteContext:
                LD A, (GameState.PlayerActions + FPlayerActions.SelectedHeroID)
                CALL Character.Addresses

                LD E, (IY + FObject.Position.X.High)
                LD D, (IY + FObject.Position.Y.High)

                ; вернуть позицию в альтернативном DE, не затронув target в BC'
                PUSH DE
                EXX
                POP DE
                EXX
                RET

                endif ; ~_CHARACTER_UTILITIES_HERO_ADDRESSES_
