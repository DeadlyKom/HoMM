
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
CharacterAI:    ; -----------------------------------------
                ; инициализация базового состояния объекта
                LD (IY + FObject.Flags), OBJECT_DIRTY | OBJECT_TICK_ENABLED
                LD (IY + FObject.Sprite), ANIM_STATE_IDLE | (DIR_DOWN_LEFT << SPRITE_DIR_BIT)
                ; -----------------------------------------

                ; -----------------------------------------
                ; инициализация состояния персонажа на карте
                LD (IY + FObjectCharacter.CharacterID), CHARACTER_ID_NONE
                LD (IY + FObjectCharacter.PathID), PATH_ID_NONE
                LD (IY + FObjectCharacter.WayPointID), WAY_POINT_NONE
                ; -----------------------------------------

                ; -----------------------------------------
                ; инициализация расширения AI-персонажа
                LD (IY + FObjectCharacterAI.AIContextID), CONTEXT_NONE          ; отсутствие идентификатора AI-контекста,
                                                                                ; выдаётся/забирается в реальном времени методами Possess/Unpossess
                ; -----------------------------------------

                OR A                                                            ; сброс флага переполнения, успешная инициализация
                RET
                
                endif ; ~_OBJECT_CLASS_CHARACTER_AI_
