
                ifndef _MODULE_MAP_LOAD_OBJECTS_
                define _MODULE_MAP_LOAD_OBJECTS_
; -----------------------------------------
; инициализация объектов карты после загрузки
; In:
;   HL - адрес FMapHeader.ObjectNum`
; Out:
; Corrupt:
; Note:
; -----------------------------------------
Load_Objects:   ; восстановление страницы расположения загруженого ассетаа карты
                LD A, (MapPage)
                CALL SetPage

                LD B, (HL)                                                      ; FMapHeader.ObjectNum
                INC HL
                LD E, (HL)                                                      ; FMapHeader.ObjectOffset.Low
                INC HL
                LD D, (HL)                                                      ; FMapHeader.ObjectOffset.High
                ADD HL, DE

; .Loop           LD A, (HL)                                                      ; FMapObject.Type
;                 BIT MAP_OBJECT_TYPE_BIT, A
                RET

                endif ; ~_MODULE_MAP_LOAD_OBJECTS_
