
                ifndef _CONST_OBJECT_HERO_
                define _CONST_OBJECT_HERO_
HERO_ID_NONE        EQU #FF                                                     ; идентификатор героя отсутствует
PATH_ID_NONE        EQU #FF                                                     ; индекс в массиве пути отсутствует

; значения для поля FObject.Sprite
ANIM_STATE_BIT      EQU 0x06                                                    ; флаг,  состояния анимации
                                                                                ;   0 - бездействие/поворот
                                                                                ;   1 - перемещение
SPRITE_DIR_BIT      EQU 0x03                                                    ; налальный бит направления анимации (3 бита)
SPRITE_FRAME_BIT    EQU 0x00                                                    ; налальный бит кадра анимации (3 бита)

; состояния анимации
ANIM_STATE_IDLE     EQU 0 << ANIM_STATE_BIT                                     ; бездействие
ANIM_STATE_TURN     EQU 0 << ANIM_STATE_BIT                                     ; поворот
ANIM_STATE_MOVE     EQU 1 << ANIM_STATE_BIT                                     ; перемещения

; направления анимации/движения
DIR_UP              EQU 0x00                                                    ; вверх
DIR_UP_RIGHT        EQU 0x01                                                    ; вверх-вправо
DIR_RIGHT           EQU 0x02                                                    ; вправо
DIR_DOWN_RIGHT      EQU 0x03                                                    ; вниз-вправо
DIR_DOWN            EQU 0x04                                                    ; вниз
DIR_DOWN_LEFT       EQU 0x05                                                    ; вниз-влево
DIR_LEFT            EQU 0x06                                                    ; влево
DIR_UP_LEFT         EQU 0x07                                                    ; вверх-влево
DIR_MASK            EQU %00000111

                endif ; ~_CONST_OBJECT_HERO_
