        
                    ifndef _INPUT_KEYBOARD_INCLUDE_
                    define _INPUT_KEYBOARD_INCLUDE_

                    module Keyboard
Begin:              EQU $

                    include "SpectrumVirtualKeys.inc"
                    include "CheckKeyState.asm"
                    include "PressedKey_All.asm"
                    include "PressedKey_1_5.asm"
VirtualKeysTable:   DB (SVK_CAPS_SHIFT << 3) | INSTRUCTION_BIT, HalfRow_CS_V
                    DB (SVK_Z << 3) | INSTRUCTION_BIT, HalfRow_CS_V
                    DB (SVK_X << 3) | INSTRUCTION_BIT, HalfRow_CS_V
                    DB (SVK_C << 3) | INSTRUCTION_BIT, HalfRow_CS_V
                    DB (SVK_V << 3) | INSTRUCTION_BIT, HalfRow_CS_V

                    DB (SVK_A << 3) | INSTRUCTION_BIT, HalfRow_A_G
                    DB (SVK_S << 3) | INSTRUCTION_BIT, HalfRow_A_G
                    DB (SVK_D << 3) | INSTRUCTION_BIT, HalfRow_A_G
                    DB (SVK_F << 3) | INSTRUCTION_BIT, HalfRow_A_G
                    DB (SVK_G << 3) | INSTRUCTION_BIT, HalfRow_A_G

                    DB (SVK_Q << 3) | INSTRUCTION_BIT, HalfRow_Q_T
                    DB (SVK_W << 3) | INSTRUCTION_BIT, HalfRow_Q_T
                    DB (SVK_E << 3) | INSTRUCTION_BIT, HalfRow_Q_T
                    DB (SVK_R << 3) | INSTRUCTION_BIT, HalfRow_Q_T
                    DB (SVK_T << 3) | INSTRUCTION_BIT, HalfRow_Q_T

                    DB (SVK_1 << 3) | INSTRUCTION_BIT, HalfRow_1_5
                    DB (SVK_2 << 3) | INSTRUCTION_BIT, HalfRow_1_5
                    DB (SVK_3 << 3) | INSTRUCTION_BIT, HalfRow_1_5
                    DB (SVK_4 << 3) | INSTRUCTION_BIT, HalfRow_1_5
                    DB (SVK_5 << 3) | INSTRUCTION_BIT, HalfRow_1_5

                    DB (SVK_0 << 3) | INSTRUCTION_BIT, HalfRow_6_0
                    DB (SVK_9 << 3) | INSTRUCTION_BIT, HalfRow_6_0
                    DB (SVK_8 << 3) | INSTRUCTION_BIT, HalfRow_6_0
                    DB (SVK_7 << 3) | INSTRUCTION_BIT, HalfRow_6_0
                    DB (SVK_6 << 3) | INSTRUCTION_BIT, HalfRow_6_0

                    DB (SVK_P << 3) | INSTRUCTION_BIT, HalfRow_Y_P
                    DB (SVK_O << 3) | INSTRUCTION_BIT, HalfRow_Y_P
                    DB (SVK_I << 3) | INSTRUCTION_BIT, HalfRow_Y_P
                    DB (SVK_U << 3) | INSTRUCTION_BIT, HalfRow_Y_P
                    DB (SVK_Y << 3) | INSTRUCTION_BIT, HalfRow_Y_P

                    DB (SVK_ENTER << 3) | INSTRUCTION_BIT, HalfRow_H_ENT
                    DB (SVK_L << 3) | INSTRUCTION_BIT, HalfRow_H_ENT
                    DB (SVK_K << 3) | INSTRUCTION_BIT, HalfRow_H_ENT
                    DB (SVK_J << 3) | INSTRUCTION_BIT, HalfRow_H_ENT
                    DB (SVK_H << 3) | INSTRUCTION_BIT, HalfRow_H_ENT

                    DB (SVK_SPACE << 3) | INSTRUCTION_BIT, HalfRow_B_SPC
                    DB (SVK_SYMBOL_SHIFT << 3) | INSTRUCTION_BIT, HalfRow_B_SPC
                    DB (SVK_M << 3) | INSTRUCTION_BIT, HalfRow_B_SPC
                    DB (SVK_N << 3) | INSTRUCTION_BIT, HalfRow_B_SPC
                    DB (SVK_B << 3) | INSTRUCTION_BIT, HalfRow_B_SPC

                    DB #00                                                      ; ToDo: добавить обработку VK_EDIT

                    display "\t - Keybord:\t\t\t\t\t", /A, Begin, "\t= busy [ ", /D, $ - Begin, " byte(s)  ]"

                    endmodule

                    endif ; ~_INPUT_KEYBOARD_INCLUDE_
