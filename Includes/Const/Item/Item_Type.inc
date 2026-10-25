
                ifndef _CONST_ITEM_TYPE_
                define _CONST_ITEM_TYPE_
; -----------------------------------------
;   типы предметов, значения используются как номера битов
; -----------------------------------------
ITEM_TYPE_HEAD                          EQU 0x00                                ; тип предмета - "голова"
ITEM_TYPE_BREAST                        EQU 0x01                                ; тип предмета - "грудь"
ITEM_TYPE_AMULET                        EQU 0x02                                ; тип предмета - "амулет"
ITEM_TYPE_RING                          EQU 0x03                                ; тип предмета - "кольцо"
ITEM_TYPE_LEFT_HAND                     EQU 0x04                                ; тип предмета - "левая рука"
ITEM_TYPE_RIGHT_HAND                    EQU 0x05                                ; тип предмета - "правая рука"
ITEM_TYPE_TWO_HANDED                    EQU 0x06                                ; тип предмета - "двуручный"
ITEM_TYPE_BELT                          EQU 0x07                                ; тип предмета - "пояс"
ITEM_TYPE_SHOULDER_PAD                  EQU 0x08                                ; тип предмета - "наплечник/плащ"
ITEM_TYPE_BOOT                          EQU 0x09                                ; тип предмета - "обувь"

                endif ; ~_CONST_ITEM_TYPE_
