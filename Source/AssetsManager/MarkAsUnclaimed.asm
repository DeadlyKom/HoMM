
                ifndef _ASSETS_MANAGER_MARK_AS_UNCLAIMED_
                define _ASSETS_MANAGER_MARK_AS_UNCLAIMED_
; -----------------------------------------
; пометить как невостребованный ресурс
; In:
;   A  - идентификатор ресурса
;   флаг переаолнения Carry, указывает необходимость сброса флага загрузки
; Out:
;   IX - адрес структуры FAssets
; Corrupt:
;   IX
; Note:
;   - необходимо включить страницу с данными о доступной ОЗУ
; -----------------------------------------
MarkAsUnclaimed:PUSH AF

                ASSETS_ADR_A                                                    ; расчёт адреса информации о ресурсе
                SET ASSETS_MARKED_BIT, (IX + FAssets.Address.Page)              ; установка флага невостребованный

                POP AF
                RET NC                                                          ; выход, если не нужно сбросить флаг загрузки ресурса

                RES ASSETS_LOAD_BIT, (IX + FAssets.Flags)                       ; сброс флага загрузки ресурса
                RET

                endif ; ~ _ASSETS_MANAGER_RELEASE_
