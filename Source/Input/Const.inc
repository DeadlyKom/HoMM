    
                ifndef _INPUT_CONST_
                define _INPUT_CONST_
; -----------------------------------------
;   флаги виртуальной клавиши
; -----------------------------------------

; -----------------------------------------
;      7    6    5    4    3    2    1    0
;   +----+----+----+----+----+----+----+----+
;   | IA | K6 | K5 | K4 | K3 | K2 | K1 | K0 |
;   +----+----+----+----+----+----+----+----+
;
;   IA      [7]     - флаг, принадлежности инпута
;                       0 - клавиатура
;                       1 - дополнительный Kempston-мышь/джойстик
;   K6-K0   [6-0]   - клавиша
; -----------------------------------------
INPUT_AFFILIATION_BIT   EQU 0x07                                                ; флаг, принадлежности инпута
INPUT_AFFILIATION       EQU 1 << INPUT_AFFILIATION_BIT

; -----------------------------------------
;      7    6    5    4    3    2    1    0
;   +----+----+----+----+----+----+----+----+
;   | 1  | KI | J2 | J1 | J0 | M2 | M1 | M0 |
;   +----+----+----+----+----+----+----+----+
;
;   KI      [6]     - флаг, принадлежности инпута
;                       0 - Kempston-джойстик
;                       1 - Kempston-мышь
;   J2-J0   [5-3]   - биты состояний для джойстика
;   M6-M0   [2-0]   - биты состояния для мыши
; -----------------------------------------
KEMPSTON_INPUT_BIT      EQU 0x06                                                ; флаг, принадлежности инпута к Kempston-мыши
KEMPSTON_JOYSTICK_SHIFT EQU 0x03                                                ; смещения битов для Kempston-джойстик
KEMPSTON_MOUSE_SHIFT    EQU 0x00                                                ; смещения битов для Kempston-мыши
KEMPSTON_JOYSTICK       EQU INPUT_AFFILIATION | (0 << KEMPSTON_INPUT_BIT)       ; Kempston-джойстик
KEMPSTON_MOUSE          EQU INPUT_AFFILIATION | (1 << KEMPSTON_INPUT_BIT)       ; Kempston-мыши

INSTRUCTION_BIT         EQU #40 + 0x07

                endif ; ~_INPUT_CONST_
