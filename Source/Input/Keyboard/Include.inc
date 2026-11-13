        
                ifndef _INPUT_KEYBOARD_INCLUDE_
                define _INPUT_KEYBOARD_INCLUDE_

                module Keyboard
Begin:          EQU $

                include "SpectrumVirtualKeys.inc"
                include "CheckKeyState.asm"
                include "PressedKey_All.asm"
                include "PressedKey_1_5.asm"

                ; формирование записи клавиши для проверки бита порта
KEY_ENTRY       macro Key?, HalfRow?
                DB ((Key?) << 3) | INSTRUCTION_BIT, HalfRow?
                endm
VirtKeysTable:  KEY_ENTRY SVK_CAPS_SHIFT, HalfRow_CS_V
                KEY_ENTRY SVK_Z, HalfRow_CS_V
                KEY_ENTRY SVK_X, HalfRow_CS_V
                KEY_ENTRY SVK_C, HalfRow_CS_V
                KEY_ENTRY SVK_V, HalfRow_CS_V

                KEY_ENTRY SVK_A, HalfRow_A_G
                KEY_ENTRY SVK_S, HalfRow_A_G
                KEY_ENTRY SVK_D, HalfRow_A_G
                KEY_ENTRY SVK_F, HalfRow_A_G
                KEY_ENTRY SVK_G, HalfRow_A_G

                KEY_ENTRY SVK_Q, HalfRow_Q_T
                KEY_ENTRY SVK_W, HalfRow_Q_T
                KEY_ENTRY SVK_E, HalfRow_Q_T
                KEY_ENTRY SVK_R, HalfRow_Q_T
                KEY_ENTRY SVK_T, HalfRow_Q_T

                KEY_ENTRY SVK_1, HalfRow_1_5
                KEY_ENTRY SVK_2, HalfRow_1_5
                KEY_ENTRY SVK_3, HalfRow_1_5
                KEY_ENTRY SVK_4, HalfRow_1_5
                KEY_ENTRY SVK_5, HalfRow_1_5

                KEY_ENTRY SVK_0, HalfRow_6_0
                KEY_ENTRY SVK_9, HalfRow_6_0
                KEY_ENTRY SVK_8, HalfRow_6_0
                KEY_ENTRY SVK_7, HalfRow_6_0
                KEY_ENTRY SVK_6, HalfRow_6_0

                KEY_ENTRY SVK_P, HalfRow_Y_P
                KEY_ENTRY SVK_O, HalfRow_Y_P
                KEY_ENTRY SVK_I, HalfRow_Y_P
                KEY_ENTRY SVK_U, HalfRow_Y_P
                KEY_ENTRY SVK_Y, HalfRow_Y_P

                KEY_ENTRY SVK_ENTER, HalfRow_H_ENT
                KEY_ENTRY SVK_L, HalfRow_H_ENT
                KEY_ENTRY SVK_K, HalfRow_H_ENT
                KEY_ENTRY SVK_J, HalfRow_H_ENT
                KEY_ENTRY SVK_H, HalfRow_H_ENT

                KEY_ENTRY SVK_SPACE, HalfRow_B_SPC
                KEY_ENTRY SVK_SYMBOL_SHIFT, HalfRow_B_SPC
                KEY_ENTRY SVK_M, HalfRow_B_SPC
                KEY_ENTRY SVK_N, HalfRow_B_SPC
                KEY_ENTRY SVK_B, HalfRow_B_SPC

                display "\t - Keybord:\t\t\t\t\t", /A, Begin, "\t= busy [ ", /D, $ - Begin, " byte(s)  ]"

                endmodule

                endif ; ~_INPUT_KEYBOARD_INCLUDE_
