
                ifndef _MACRO_FONT_
                define _MACRO_FONT_
FONT_OFFSET     macro Offset?
                OFFSET Offset?
                endm
FONT_PROFILE    macro Height?, Width?, SpacingProfile?, Baseline?
                FFontGlyph {
                    Height?, \
                    Width?, \
                    SpacingProfile?, \
                    Baseline?
                }
                endm
FONT_NOT_SPRITE macro Width?
                ; у глифа отсутствуют данные OR/XOR, поэтому высота равна 0
                FONT_PROFILE \
                    0, \
                    Width?, \
                    0, \
                    0
                endm
FONT            macro Height?, Width?, LU?, LL?, RU?, RL?, Baseline?, Sprite?
                FONT_PROFILE \
                    Height?, \
                    Width?, \
                    ((LU? & 0x03) << 6) | \
                    ((LL? & 0x03) << 4) | \
                    ((RU? & 0x03) << 2) | \
                    ((RL? & 0x03) << 0), \
                    Baseline?
                incbin Sprite?
                endm

                endif ; ~_MACRO_FONT_
