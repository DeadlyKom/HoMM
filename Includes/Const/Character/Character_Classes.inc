
                ifndef _CONST_CHARACTER_CLASSES_
                define _CONST_CHARACTER_CLASSES_
; флаги структуры FCharacterSettings.Class и FCharacter.Class
CHARACTER_GENDER_BIT    EQU 0x07                                                ; флаг, гендера персонажа, где
                                                                                ;   0 - муржской
                                                                                ;   1 - женский
Character.Gender:
.Male           EQU 0 << CHARACTER_GENDER_BIT                                   ; муржской
.Female         EQU 1 << CHARACTER_GENDER_BIT                                   ; женский
Character.Class:
.Druid          EQU 0x00                                                        ; друид
.Wizard         EQU 0x00                                                        ; волшебник
.Warlock        EQU 0x00                                                        ; колдун
.Witch          EQU 0x00                                                        ; ведьмак
.DeathKnight    EQU 0x00                                                        ; рыцарь смерти
.Overlord       EQU 0x00                                                        ; повелитель
.Necromancer    EQU 0x00                                                        ; некромант

                endif ; ~_CONST_CHARACTER_CLASSES_
