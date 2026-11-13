
                    ifndef _INPUT_KEYBOARD_VIRTUAL_KEYS_
                    define _INPUT_KEYBOARD_VIRTUAL_KEYS_
VK_CAPS_SHIFT       EQU 0x01
VK_Z                EQU 0x02
VK_X                EQU 0x03
VK_C                EQU 0x04
VK_V                EQU 0x05

VK_A                EQU 0x06
VK_S                EQU 0x07
VK_D                EQU 0x08
VK_F                EQU 0x09
VK_G                EQU 0x0A

VK_Q                EQU 0x0B
VK_W                EQU 0x0C
VK_E                EQU 0x0D
VK_R                EQU 0x0E
VK_T                EQU 0x0F

VK_1                EQU 0x10
VK_2                EQU 0x11
VK_3                EQU 0x12
VK_4                EQU 0x13
VK_5                EQU 0x14

VK_0                EQU 0x15
VK_9                EQU 0x16
VK_8                EQU 0x17
VK_7                EQU 0x18
VK_6                EQU 0x19

VK_P                EQU 0x1A
VK_O                EQU 0x1B
VK_I                EQU 0x1C
VK_U                EQU 0x1D
VK_Y                EQU 0x1E

VK_ENTER            EQU 0x1F
VK_L                EQU 0x20
VK_K                EQU 0x21
VK_J                EQU 0x22
VK_H                EQU 0x23

VK_SPACE            EQU 0x24
VK_SYMBOL_SHIFT     EQU 0x25
VK_M                EQU 0x26
VK_N                EQU 0x27
VK_B                EQU 0x28

; специальные
VK_BASIC_COUNT      EQU VK_B - VK_CAPS_SHIFT + 1
VK_BASIC_MAX        EQU VK_B + 1
VK_COMBO_FIRST      EQU VK_BASIC_MAX
VK_NONE             EQU 0x00

; дополнительные
VK_EDIT             EQU VK_BASIC_COUNT + VK_1                                   ; EDIT
VK_CAPS_LOCK        EQU VK_BASIC_COUNT + VK_2                                   ; CAPS LOCK
VK_TRUE_VIDEO       EQU VK_BASIC_COUNT + VK_3                                   ; TRUE VIDEO
VK_INV_VIDEO        EQU VK_BASIC_COUNT + VK_4                                   ; INV VIDEO
VK_CURSOR_LEFT      EQU VK_BASIC_COUNT + VK_5                                   ; курсор влево
VK_CURSOR_DOWN      EQU VK_BASIC_COUNT + VK_6                                   ; курсор вниз
VK_CURSOR_UP        EQU VK_BASIC_COUNT + VK_7                                   ; курсор вверх
VK_CURSOR_RIGHT     EQU VK_BASIC_COUNT + VK_8                                   ; курсор вправо
VK_GRAPHICS         EQU VK_BASIC_COUNT + VK_9                                   ; GRAPHICS
VK_DELETE           EQU VK_BASIC_COUNT + VK_0                                   ; DELETE
VK_BREAK            EQU VK_BASIC_COUNT + VK_SPACE                               ; BREAK
VK_EXTEND_MODE      EQU VK_BASIC_COUNT + VK_SYMBOL_SHIFT                        ; EXTEND MODE

; символы
VK_EXCLAMATION      EQU VK_BASIC_COUNT * 2 + VK_1                               ; !
VK_AT_SIGN          EQU VK_BASIC_COUNT * 2 + VK_2                               ; @
VK_HASH             EQU VK_BASIC_COUNT * 2 + VK_3                               ; #
VK_DOLLAR           EQU VK_BASIC_COUNT * 2 + VK_4                               ; $
VK_PERCENT          EQU VK_BASIC_COUNT * 2 + VK_5                               ; %
VK_AMPERSAND        EQU VK_BASIC_COUNT * 2 + VK_6                               ; &
VK_APOSTROPHE       EQU VK_BASIC_COUNT * 2 + VK_7                               ; апостроф
VK_LPAREN           EQU VK_BASIC_COUNT * 2 + VK_8                               ; левая круглая скобка
VK_RPAREN           EQU VK_BASIC_COUNT * 2 + VK_9                               ; правая круглая скобка
VK_UNDERSCORE       EQU VK_BASIC_COUNT * 2 + VK_0                               ; _
VK_LESS_EQUAL       EQU VK_BASIC_COUNT * 2 + VK_Q                               ; <=
VK_NOT_EQUAL        EQU VK_BASIC_COUNT * 2 + VK_W                               ; <>
VK_GREATER_EQ       EQU VK_BASIC_COUNT * 2 + VK_E                               ; >=
VK_LESS             EQU VK_BASIC_COUNT * 2 + VK_R                               ; <
VK_GREATER          EQU VK_BASIC_COUNT * 2 + VK_T                               ; >
VK_SEMICOLON        EQU VK_BASIC_COUNT * 2 + VK_O                               ; точка с запятой
VK_QUOTE            EQU VK_BASIC_COUNT * 2 + VK_P                               ; двойная кавычка
VK_POWER            EQU VK_BASIC_COUNT * 2 + VK_H                               ; возведение в степень
VK_MINUS            EQU VK_BASIC_COUNT * 2 + VK_J                               ; -
VK_PLUS             EQU VK_BASIC_COUNT * 2 + VK_K                               ; +
VK_EQUALS           EQU VK_BASIC_COUNT * 2 + VK_L                               ; =
VK_COLON            EQU VK_BASIC_COUNT * 2 + VK_Z                               ; двоеточие
VK_POUND            EQU VK_BASIC_COUNT * 2 + VK_X                               ; £
VK_QUESTION         EQU VK_BASIC_COUNT * 2 + VK_C                               ; ?
VK_SLASH            EQU VK_BASIC_COUNT * 2 + VK_V                               ; /
VK_ASTERISK         EQU VK_BASIC_COUNT * 2 + VK_B                               ; *
VK_COMMA            EQU VK_BASIC_COUNT * 2 + VK_N                               ; запятая
VK_PERIOD           EQU VK_BASIC_COUNT * 2 + VK_M                               ; точка

                    endif ; ~_INPUT_KEYBOARD_VIRTUAL_KEYS_
