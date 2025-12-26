
                ifndef _CONST_MAP_HEXTILE_
                define _CONST_MAP_HEXTILE_
; флаги работы с метаданными карты
MAP_HEXTILE_USABLE_BIT      EQU 0x07                                            ; флаг, указывающий на пригодность тайла для использования

MAP_HEXTILE_USABLE          EQU 0 << MAP_HEXTILE_USABLE_BIT
MAP_HEXTILE_NOT_USABLE      EQU 1 << MAP_HEXTILE_USABLE_BIT
                endif ; ~_CONST_MAP_HEXTILE_
