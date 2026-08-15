
                ifndef _OBJECT_UTILITIES_ADDRESS_SETTINGS_
                define _OBJECT_UTILITIES_ADDRESS_SETTINGS_
; -----------------------------------------
; получение адреса настроек объекта по умолчанию
; In:
;   A  - ID настроек объекта по умолчанию
; Out:
;   HL - адрес структуры FObjectDefaultSettings
; Corrupt:
;   HL, AF
; Note:
;   ℹ️ код расположен в странице 0
; -----------------------------------------
SettingsAdr.HL: ADD A, A    ; x2
                LD L, A
                LD H, #00
                ADD HL, HL  ; x4
                ADD HL, HL  ; x8
                LD A, H
                ADD A, HIGH Adr.ObjectDefaultSettings
                LD H, A
                RET
; -----------------------------------------
; получение адреса настроек объекта по умолчанию
; In:
;   A  - ID настроек объекта по умолчанию
; Out:
;   IX - адрес структуры FObjectDefaultSettings
; Corrupt:
;   HL, AF, IX
; Note:
;   ℹ️ код расположен в странице 0
; -----------------------------------------
SettingsAdr.IX: ADD A, A    ; x2
                LD L, A
                LD H, #00
                ADD HL, HL  ; x4
                ADD HL, HL  ; x8
                LD A, H
                ADD A, HIGH Adr.ObjectDefaultSettings
                LD IXH, A
                LD A, L
                LD IXL, A
                RET

                endif ; ~_OBJECT_UTILITIES_ADDRESS_SETTINGS_
