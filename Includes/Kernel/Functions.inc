
                ifndef _KERNEL_FUNCTIONS_
                define _KERNEL_FUNCTIONS_
Func
.PopPage            EQU Kernel.Functions.PopPage                                ; востановление страницы
.ExeAssetCode       EQU Kernel.Functions.ExeAssetCode                           ; выполнить код ресурса (продвинутая компиляция кода)
.RestoreAsset       EQU Kernel.Functions.RestoreAsset                           ; восстановлени (перезагрузка) ранее загруженого ассета из стека

.JumpTable          EQU Kernel.Functions.JumpTable                              ; переход по таблице переходов
.JumpTable.NoShift  EQU Kernel.Functions.JumpTable.NoShift                      ; переход по таблице переходов
.CallAnotherPage    EQU Kernel.Functions.CallAnotherPage                        ; вызов функции в другой странице
.Delay              EQU Kernel.Functions.Delay                                  ; задержка 4 фрейма
.CustomDelay        EQU Kernel.Functions.Delay.DelayLoop                        ; кастомная задержка

.BaseClear          EQU Kernel.Functions.BaseClear                              ; очистка базового экрана
.BaseFillATTR       EQU Kernel.Functions.BaseFillATTR                           ; заполнение атрибутов базового экрана
.BaseScrcpy         EQU Kernel.Functions.BaseScrcpy                             ; копирование в базовый экран
.ShadowClear        EQU Kernel.Functions.ShadowClear                            ; очистка теневого экрана
.ShadowFillATTR     EQU Kernel.Functions.ShadowFillATTR                         ; заполнение атрибутов теневого экрана
.ShadowScrcpy       EQU Kernel.Functions.ShadowScrcpy                           ; копирование в теневой экран
.ShadowScrcpyInPage EQU Kernel.Functions.ShadowScrcpyInPage                     ; функция копирования в теневой экран (находясь в странице)

                endif ; ~_KERNEL_FUNCTIONS_
