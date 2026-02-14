
                ifndef _CONST_EVENT_TYPE_
                define _CONST_EVENT_TYPE_
; тыпы событий
EVENT_TYPE_RECONNAISSANCE       EQU 0x00                                        ; тип события - рекогносцировка

; ToDo на раздумья категории:
EVENT_TYPE_INPUT                EQU 0xFF                                        ; тип события - инпут
EVENT_TYPE_GAME_LOGIC           EQU 0xFF                                        ; тип события - игровая логика
EVENT_TYPE_DOMAIN               EQU 0xFF                                        ; тип события - 
EVENT_TYPE_VFX                  EQU 0xFF                                        ; тип события - визуальный эффект
EVENT_TYPE_SFX                  EQU 0xFF                                        ; тип события - звуковой эффект

                endif ; ~_CONST_EVENT_TYPE_
