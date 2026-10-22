
                ifndef _KERNEL_FUNCTIONS_
                define _KERNEL_FUNCTIONS_
Func
.PopPage                EQU Kernel.Functions.PopPage                            ; восстановление страницы
.PreLaunchCheck         EQU Kernel.Functions.PreLaunchCheck                     ; проверка перед запуском ресурса
.ExeAssetCode           EQU Kernel.Functions.ExeAssetCode                       ; выполнить код ресурса (продвинутая компиляция кода)
.LaunchAsset            EQU Kernel.Functions.LaunchAsset                        ; запуск загруженного модуля
.RestoreAsset           EQU Kernel.Functions.RestoreAsset                       ; восстановление (перезагрузка) ранее загруженного ресурса из стека
.LoadAssetInPage        EQU Kernel.Functions.LoadAsset.InPage                   ; загрузка ресурса                                          (находясь в странице)
.LoadAssetBlockInPage   EQU Kernel.Functions.LoadAsset.BlockInPage              ; загрузка ресурса, с копированием блока ресурса в буфер    (находясь в странице)
.ReleaseAssetInPage     EQU Kernel.Functions.ReleaseAssetInPage                 ; освобождение ресурса                                      (находясь в странице)
.MarkAsUnclaimedInPage  EQU Kernel.Functions.MarkAsUnclaimed                    ; пометка ресурса как невостребованного                     (находясь в странице)

.JumpTable              EQU Kernel.Functions.JumpTable                          ; переход по таблице переходов
.JumpTable.NoShift      EQU Kernel.Functions.JumpTable.NoShift                  ; переход по таблице переходов
.CallInPage             EQU Kernel.Functions.Call.InPage                        ; вызов функции с включением страницы                       (находясь в странице)
.RET                    EQU Kernel.Functions.Call.RET
.JP_HL                  EQU Kernel.Functions.Call.JP_HL
.JP_IX                  EQU Kernel.Functions.Call.JP_IX
.JP_IY                  EQU Kernel.Functions.Call.JP_IY
.Delay                  EQU Kernel.Functions.Delay                              ; задержка 4 фрейма
.CustomDelay            EQU Kernel.Functions.Delay.DelayLoop                    ; кастомная задержка

.BaseClear              EQU Kernel.Functions.BaseClear                          ; очистка базового экрана
.BaseFillATTR           EQU Kernel.Functions.BaseFillATTR                       ; заполнение атрибутов базового экрана
.BaseScrcpy             EQU Kernel.Functions.BaseScrcpy                         ; копирование в базовый экран
.ShadowClear            EQU Kernel.Functions.ShadowClear                        ; очистка теневого экрана
.ShadowClearInPage      EQU Kernel.Functions.ShadowClear.InPage                 ; очистка теневого экрана                                   (находясь в странице)
.ShadowFillATTR         EQU Kernel.Functions.ShadowFillATTR                     ; заполнение атрибутов теневого экрана
.ShadowScrcpy           EQU Kernel.Functions.ShadowScrcpy                       ; копирование в теневой экран
.ShadowScrcpyInPage     EQU Kernel.Functions.ShadowScrcpyInPage                 ; копирование в теневой экран                               (находясь в странице)

.CopyFromPage           EQU Kernel.Functions.CopyFromPage                       ; копирование данных в фиксированный буфер                  (находясь в странице)

                endif ; ~_KERNEL_FUNCTIONS_
