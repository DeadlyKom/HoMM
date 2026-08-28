
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
Character:      ; -----------------------------------------
                ; инициализация базового состояния объекта
                ; -----------------------------------------

                ; -----------------------------------------
                ; копирование флагов предварительного тика и источника света из настроек объекта по умолчанию
                LD A, (IX + FObjectDefaultSettings.Flags)
                AND OBJECT_DEFAULT_PRE_TICK | OBJECT_DEFAULT_LIGHT_SOURCE
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

                OR A                                                            ; сброс флага переполнения, успешная инициализация
                RET
                
                endif ; ~_OBJECT_CLASS_CHARACTER_
