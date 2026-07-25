
                ifndef _MACRO_FONT_
                define _MACRO_FONT_
FONT_OFFSET     macro Offset?
                DW Offset? - $-1
                endm
FONT_PROFILE    macro Height?, Profile?, Advance?, Baseline?
                FFont {
                    Height?, \
                    Advance?, \
                    Profile?, \
                    Baseline?
                }
                endm
FONT_NOT_SPRITE macro Advance?
                ; OR+XOR не могут быть нулевыми, по этому высота равна 0
                FONT_PROFILE \
                    0, \
                    0, \
                    Advance?, \
                    0
                endm
FONT            macro Height?, LU?, LL?, RU?, RL?, Advance?, Baseline?, Sprite?
                FONT_PROFILE \
                    Height?, \
                    ((LU? & 0x03) << 6) | \
                    ((LL? & 0x03) << 4) | \
                    ((RU? & 0x03) << 2) | \
                    ((RL? & 0x03) << 0), \
                    Advance?, \
                    Baseline?
                incbin Sprite?
                endm

                endif ; ~_MACRO_FONT_
