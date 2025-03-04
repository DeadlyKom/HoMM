
                    ifndef _INPUT_KEYBOARD_SPECTRUM_VIRTUAL_KEYS_
                    define _INPUT_KEYBOARD_SPECTRUM_VIRTUAL_KEYS_

HalfRow_CS_V        EQU #FE
HalfRow_A_G         EQU #FD
HalfRow_Q_T         EQU #FB
HalfRow_1_5         EQU #F7
HalfRow_6_0         EQU #EF
HalfRow_Y_P         EQU #DF
HalfRow_H_ENT       EQU #BF
HalfRow_B_SPC       EQU #7F

; bit flags
SVK_0               EQU 0                   ; HalfRow_6_0
SVK_1               EQU 0                   ; HalfRow_1_5
SVK_2               EQU 1                   ; HalfRow_1_5
SVK_3               EQU 2                   ; HalfRow_1_5
SVK_4               EQU 3                   ; HalfRow_1_5
SVK_5               EQU 4                   ; HalfRow_1_5
SVK_6               EQU 4                   ; HalfRow_6_0
SVK_7               EQU 3                   ; HalfRow_6_0
SVK_8               EQU 2                   ; HalfRow_6_0
SVK_9               EQU 1                   ; HalfRow_6_0

SVK_A               EQU 0                   ; HalfRow_A_G
SVK_B               EQU 4                   ; HalfRow_B_SPC
SVK_C               EQU 3                   ; HalfRow_CS_V
SVK_D               EQU 2                   ; HalfRow_A_G
SVK_E               EQU 2                   ; HalfRow_Q_T
SVK_F               EQU 3                   ; HalfRow_A_G
SVK_G               EQU 4                   ; HalfRow_A_G
SVK_H               EQU 4                   ; HalfRow_H_ENT
SVK_I               EQU 2                   ; HalfRow_Y_P
SVK_J               EQU 3                   ; HalfRow_H_ENT
SVK_K               EQU 2                   ; HalfRow_H_ENT
SVK_L               EQU 1                   ; HalfRow_H_ENT
SVK_M               EQU 2                   ; HalfRow_B_SPC
SVK_N               EQU 3                   ; HalfRow_B_SPC
SVK_O               EQU 1                   ; HalfRow_Y_P
SVK_P               EQU 0                   ; HalfRow_Y_P
SVK_Q               EQU 0                   ; HalfRow_Q_T
SVK_R               EQU 3                   ; HalfRow_Q_T
SVK_S               EQU 1                   ; HalfRow_A_G
SVK_T               EQU 4                   ; HalfRow_Q_T
SVK_U               EQU 3                   ; HalfRow_Y_P
SVK_V               EQU 4                   ; HalfRow_CS_V
SVK_W               EQU 1                   ; HalfRow_Q_T
SVK_X               EQU 2                   ; HalfRow_CS_V
SVK_Y               EQU 4                   ; HalfRow_Y_P
SVK_Z               EQU 1                   ; HalfRow_CS_V


SVK_ENTER           EQU 0                   ; HalfRow_H_ENT
SVK_SYMBOL_SHIFT    EQU 1                   ; HalfRow_B_SPC
SVK_CAPS_SHIFT      EQU 0                   ; HalfRow_CS_V
SVK_SPACE           EQU 0                   ; HalfRow_B_SPC

                    endif ; ~_INPUT_KEYBOARD_SPECTRUM_VIRTUAL_KEYS_
