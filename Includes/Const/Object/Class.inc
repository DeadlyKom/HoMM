
                ifndef _CONST_OBJECT_CLASS_
                define _CONST_OBJECT_CLASS_
; классы структур объектов
OBJECT_CLASS_CHARACTER      EQU 0x00                                            ; персонаж
OBJECT_CLASS_CHARACTER_AI   EQU 0x01                                            ; AI-персонаж
OBJECT_CLASS_CONSTRUCTION   EQU 0x02                                            ; постройка
OBJECT_CLASS_PROPS          EQU 0x03                                            ; декорации
OBJECT_CLASS_INTERACTION    EQU 0x04                                            ; интерактивный
OBJECT_CLASS_PARTICLE       EQU 0x05                                            ; частица
OBJECT_CLASS_DECAL          EQU 0x06                                            ; деколь
OBJECT_CLASS_UI             EQU 0x07                                            ; UI элемент
OBJECT_CLASS_MAX            EQU 0x08                                            ; максимальное доступное значение для классов объектов

OBJECT_CLASS_MASK           EQU %00001111

                endif ; ~_CONST_OBJECT_CLASS_
