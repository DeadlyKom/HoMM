
                ifndef _MACRO_FONT_
                define _MACRO_FONT_
FONT_PROFILE    macro Profile?, Advance?, Baseline?
                FFont {
                    Profile?, \
                    Advance?, \
                    Baseline?
                }
                endm
FONT_NOT_SPRITE macro Profile?, Advance?, Baseline?
                FONT_PROFILE \
                    Profile?, \
                    Advance?, \
                    Baseline?
                DW #0000                                                        ; OR+XOR не могут быть нулевыми,
                                                                                ; что говорит об отсутствии данных спрайта
                endm
FONT            macro LU?, LL?, RU?, RL?, Advance?, Baseline?, Sprite?
                FONT_PROFILE \
                    ((LU? & 0x03) << 6) | \
                    ((LL? & 0x03) << 4) | \
                    ((RU? & 0x03) << 2) | \
                    ((RL? & 0x03) << 0), \
                    Advance?, \
                    Baseline?
                incbin Sprite?
                endm

                endif ; ~_MACRO_FONT_
