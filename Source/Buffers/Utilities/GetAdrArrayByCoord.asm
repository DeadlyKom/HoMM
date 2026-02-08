
                ifndef _BUFFERS_GET_ADDRESS_ARRAY_BY_COORDINATES_
                define _BUFFERS_GET_ADDRESS_ARRAY_BY_COORDINATES_
; -----------------------------------------
; получение адреса массива карты по координатам
; In:
;   DE - координаты гексагона под крсором (D - y, E - x)
; Out:
;   HL - адрес карты
; Corrupt:
;   HL, AF
; Note:
;   код расположен рядом с картой (страница 1)
; -----------------------------------------
GetMapArrayAdr: ; расчёт адреса метаданных
                LD L, D
                RES 6, L                    ; 6 бит отвечает за адреса карты/метаданных
                LD H, HIGH Adr.MapAdrTable
                LD A, (HL)
                SET 7, L                    ; 7 бит отвечает за младший/старший адрес
                LD H, (HL)
                ADD A, E
                LD L, A
                RET NC                      ; переполнение младшего байта?
                INC H
                RET
; -----------------------------------------
; получение адреса массива метаданных карты по координатам
; In:
;   DE - координаты гексагона под крсором (D - y, E - x)
; Out:
;   HL - адрес метаданных карты
; Corrupt:
;   HL, AF
; Note:
;   код расположен рядом с картой (страница 1)
; -----------------------------------------
GetMetaArrayAdr:; расчёт адреса метаданных
                LD L, D
                SET 6, L                    ; 6 бит отвечает за адреса карты/метаданных
                LD H, HIGH Adr.MapAdrTable
                LD A, (HL)
                SET 7, L                    ; 7 бит отвечает за младший/старший адрес
                LD H, (HL)
                ADD A, E
                LD L, A
                RET NC                      ; переполнение младшего байта?
                INC H
                RET

                display " - Get address array by coordinates:\t\t\t", /A, GetMapArrayAdr, "\t= busy [ ", /D, $-GetMapArrayAdr, " byte(s)  ]"

                endif ; ~_BUFFERS_GET_ADDRESS_ARRAY_BY_COORDINATES_
