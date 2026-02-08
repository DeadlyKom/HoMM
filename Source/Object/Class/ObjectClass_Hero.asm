
                ifndef _OBJECT_CLASS_HERO_
                define _OBJECT_CLASS_HERO_
; -----------------------------------------
; инициализация объекта - герой
; In:
;   A' - идентификатор объекта
;   IX - адрес структуры FObjectDefaultSettings
;   IY - адрес структуры FObject (FObjectHero)
; Out:
; Corrupt:
; Note:
; -----------------------------------------
Hero:           ; -----------------------------------------
                LD (IY + FObject.Flags), OBJECT_DIRTY | OBJECT_TICK
                LD (IY + FObject.Sprite), ANIM_STATE_IDLE | (DIR_DOWN_LEFT << SPRITE_DIR_BIT)
                ; -----------------------------------------

                LD (IY + FObjectHero.HeroID), HERO_ID_NONE
                LD (IY + FObjectHero.PathID), PATH_ID_NONE
                LD (IY + FObjectHero.WayPointID), WAY_POINT_NONE

                XOR A
                LD (IY + FObjectHero.Delta.X.Low), A
                LD (IY + FObjectHero.Delta.X.High), A
                LD (IY + FObjectHero.Delta.Y.Low), A
                LD (IY + FObjectHero.Delta.Y.High), A

                OR A                                                            ; сброс флага переполнения, успешная инициализация
                RET
                
                endif ; ~_OBJECT_CLASS_HERO_
