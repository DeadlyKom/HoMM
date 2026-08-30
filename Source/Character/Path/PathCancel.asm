
                ifndef _CHARACTER_PATH_CANCEL_
                define _CHARACTER_PATH_CANCEL_
; -----------------------------------------
; отменить путь персонажа (обёртка)
; In:
;   E' - индекс персонажа (CharacterID)
; Out:
; Corrupt:
;   HL, AF, IX, IY
; Note:
;   ℹ️ код расположен в странице 0
; -----------------------------------------
PathCancel.Wrap:
                EXX
                LD A, E
                CALL Character.Utilities.GetAdr
; -----------------------------------------
; отменить путь персонажа
; In:
;   IY - адрес объекта персонажа (FObjectCharacter)
; Out:
; Corrupt:
;   AF
; Note:
;   объект остаётся в фактической позиции, включая положение внутри гексагона;
;   ℹ️ код расположен в странице 0
; -----------------------------------------
PathCancel:     LD (IY + FObjectCharacter.PathID), PATH_ID_NONE

                RES CHARACTER_ACTION_BIT, (IY + FObjectCharacter.CharacterID)   ; сброс флага, выполнение действия завершённо
                RES ANIM_STATE_BIT, (IY + FObjectCharacter.Super.Sprite)

                XOR A
                LD (IY + FObjectCharacter.Movement.RemainingSteps.Low), A
                LD (IY + FObjectCharacter.Movement.RemainingSteps.High), A
                LD (IY + FObjectCharacter.MovementBudget.Low), A
                LD (IY + FObjectCharacter.MovementBudget.High), A
                LD (IY + FObjectCharacter.MovementPending.Low), A
                LD (IY + FObjectCharacter.MovementPending.High), A

                SET OBJECT_DIRTY_BIT, (IY + FObject.FastFlags)                  ; обновить спрайт после остановки движения
                RET

                endif ; ~_CHARACTER_PATH_CANCEL_
