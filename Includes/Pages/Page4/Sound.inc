
                ifndef _PAGE_4_SOUND_
                define _PAGE_4_SOUND_
Sound:
.Initialize     EQU Page4.Player.AY.Initialize                                  ; инициализация
.Tick           EQU Page4.Player.AY.Play                                        ; проигрывание тик проигрывания
.Mute           EQU Page4.Player.AY.Mute                                        ; заглушить проигрывание
.Settings       EQU Page4.Player.AY.Setup                                       ; настройки

                endif ; ~_PAGE_4_SOUND_
