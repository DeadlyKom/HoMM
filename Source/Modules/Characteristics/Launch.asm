
                ifndef _MODULE_CHARACTERISTICS_LAUNCH_
                define _MODULE_CHARACTERISTICS_LAUNCH_
; -----------------------------------------
; запуск модуля "характеристик"
; In:
; Out:
; Corrupt:
;   AF
; Note:
;   пустышка, подготовка экрана пока отсутствует
; -----------------------------------------
Launch:         ; сохранение страницы загруженного модуля
                LD A, (GameState.Assets + FAssets.Address.Page)
                LD (Kernel.Modules.Characteristics.Page), A
                RET
                display " - Launch 'Characteristics':\t\t\t\t\t\t= busy [ ", /D, $-Launch, " byte(s) ]"

                endif ; ~_MODULE_CHARACTERISTICS_LAUNCH_
