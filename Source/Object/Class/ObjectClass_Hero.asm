
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
Hero:           XOR A
                ; -----------------------------------------
                LD (IY + FObject.Flags), OBJECT_DIRTY | OBJECT_TICK
                LD (IY + FObject.Sprite), ANIM_STATE_IDLE | (DIR_DOWN_LEFT << SPRITE_DIR_BIT)
                ; обнуление размера bound спрайта
                LD (IY + FObject.Bound.Size.Width), A
                LD (IY + FObject.Bound.Size.Height), A
                ; -----------------------------------------

                LD (IY + FObjectHero.HeroID), HERO_ID_NONE
                LD (IY + FObjectHero.PathID), PATH_ID_NONE
                LD (IY + FObjectHero.WayPointID), WAY_POINT_NONE

                LD (IY + FObjectHero.Delta.X), A
                LD (IY + FObjectHero.Delta.Y), A
                LD (IY + FObjectHero.Direction.X), A
                LD (IY + FObjectHero.Direction.Y), A

                OR A                                                            ; сброс флага переполнения, успешная инициализация
                RET
                
                endif ; ~_OBJECT_CLASS_HERO_
