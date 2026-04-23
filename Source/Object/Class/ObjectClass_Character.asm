
                ifndef _OBJECT_CLASS_CHARACTER_
                define _OBJECT_CLASS_CHARACTER_
; -----------------------------------------
; инициализация объекта - персонаж
; In:
;   A' - идентификатор объекта
;   IX - адрес структуры FObjectDefaultSettings
;   IY - адрес структуры FObject (FObjectCharacter)
; Out:
; Corrupt:
; Note:
; -----------------------------------------
Character:      XOR A
                ; -----------------------------------------
                LD (IY + FObject.Flags),  OBJECT_DIRTY | OBJECT_TICK_ENABLED
                LD (IY + FObject.Sprite), ANIM_STATE_IDLE | (DIR_DOWN_LEFT << SPRITE_DIR_BIT)
                ; обнуление размеров bound спрайта
                LD (IY + FObject.Bound.Size.Width), A
                LD (IY + FObject.Bound.Size.Height), A
                ; -----------------------------------------

                LD (IY + FObjectCharacter.CharacterID), CHARACTER_ID_NONE
                LD (IY + FObjectCharacter.PathID), PATH_ID_NONE
                LD (IY + FObjectCharacter.WayPointID), WAY_POINT_NONE

                LD (IY + FObjectCharacter.Delta.X), A
                LD (IY + FObjectCharacter.Delta.Y), A
                LD (IY + FObjectCharacter.Direction.X), A
                LD (IY + FObjectCharacter.Direction.Y), A

                OR A                                                            ; сброс флага переполнения, успешная инициализация
                RET
                
                endif ; ~_OBJECT_CLASS_CHARACTER_
