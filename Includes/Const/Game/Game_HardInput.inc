
                ifndef _CONST_GAME_HARD_INPUT_FLAGS_
                define _CONST_GAME_HARD_INPUT_FLAGS_

HARD_INPUT_KEMPSTON_BIT         EQU 0x00                                        ; бит наличия кемстон джойстика
HARD_INPUT_KEMPSTON_BUTTON_BIT  EQU 0x01                                        ; бит тип кемстон джойстика
                                                                                ;   0 - 5 кнопок (классический)
                                                                                ;   1 - 8 кнопок
HARD_INPUT_KEMPSTON_MOUSE_BIT   EQU 0x02                                        ; наличие кемпстон мыши

                endif ; ~_CONST_GAME_HARD_INPUT_FLAGS_
