
                ifndef _OBJECT_CLASS_CHARACTER_AI_
                define _OBJECT_CLASS_CHARACTER_AI_
; -----------------------------------------
; инициализация объекта - AI-персонаж
; In:
;   A' - идентификатор объекта
;   IX - адрес структуры FObjectDefaultSettings
;   IY - адрес структуры FObject (FObjectCharacter)
; Out:
; Corrupt:
; Note:
; -----------------------------------------
CharacterAI:    XOR A
                ; -----------------------------------------
                LD (IY + FObject.Flags), OBJECT_SIGNIFIC_NONE | OBJECT_DIRTY | OBJECT_EVALUATE_SIGNIF
                LD (IY + FObject.Sprite), ANIM_STATE_IDLE | (DIR_DOWN_LEFT << SPRITE_DIR_BIT)
                ; обнуление размера bound спрайта
                LD (IY + FObject.Bound.Size.Width), A
                LD (IY + FObject.Bound.Size.Height), A
                ; отключение уровеня значимости locomotion и AI
                LD (IY + FObject.Significance), \
                    (OBJECT_SIGNIFIC_NONE << OBJECT_SIGNIFICANCE_LOCOMOTION_BIT) |\
                    (OBJECT_SIGNIFIC_NONE << OBJECT_SIGNIFICANCE_AI_BIT)
                ; -----------------------------------------

                LD (IY + FObjectCharacter.CharacterID), CHARACTER_ID_NONE
                LD (IY + FObjectCharacter.PathID), PATH_ID_NONE
                LD (IY + FObjectCharacter.WayPointID), WAY_POINT_NONE

                LD (IY + FObjectCharacter.Delta.X), A
                LD (IY + FObjectCharacter.Delta.Y), A
                LD (IY + FObjectCharacter.Direction.X), A
                LD (IY + FObjectCharacter.Direction.Y), A

                ; -----------------------------------------
                LD (IY + FObjectCharacterAI.AIContextID), CONTEXT_NONE          ; отсутствие идентификатора AI-контекста,
                                                                                ; выдаётся/забирается в реальном времени методами Possess/Unpossess

                OR A                                                            ; сброс флага переполнения, успешная инициализация
                RET
                
                endif ; ~_OBJECT_CLASS_CHARACTER_AI_
