
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
                ; -----------------------------------------

                ; -----------------------------------------
                ; копирование флага предварительного тика из настроек объекта по умолчанию
                LD A, (IX + FObjectDefaultSettings.Flags)
                AND OBJECT_DEFAULT_PRE_TICK
                OR OBJECT_DIRTY | \
                    OBJECT_TICK_ENABLED | \
                    OBJECT_CURSOR_HIT_TEST
                LD (IY + FObject.FastFlags), A
                LD (IY + FObject.Sprite), ANIM_STATE_IDLE | \
                                            (DIR_DOWN_LEFT << SPRITE_DIR_BIT)
                ; -----------------------------------------

                ; -----------------------------------------
                ; инициализация состояния персонажа на карте
                LD (IY + FObjectCharacter.CharacterID), CHARACTER_ID_NONE
                LD (IY + FObjectCharacter.PathID), PATH_ID_NONE
                ; -----------------------------------------

                ; -----------------------------------------
                ; инициализация расширения AI-персонажа
                LD (IY + FObjectCharacterAI.AIContextID), CONTEXT_NONE          ; отсутствие идентификатора AI-контекста,
                                                                                ; выдаётся/забирается в реальном времени методами Possess/Unpossess
                ; -----------------------------------------

                OR A                                                            ; сброс флага переполнения, успешная инициализация
                RET
                
                endif ; ~_OBJECT_CLASS_CHARACTER_AI_
