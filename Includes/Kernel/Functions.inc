
                ifndef _KERNEL_FUNCTIONS_
                define _KERNEL_FUNCTIONS_
Func
.PopPage            EQU Kernel.Functions.PopPage                                ; востановление страницы
.ExeAssetCode       EQU Kernel.Functions.ExeAssetCode                           ; выполнить код ресурса (продвинутая компиляция кода)

.JumpTable          EQU Kernel.Functions.JumpTable                              ; переход по таблице переходов
.JumpTable.NoShift  EQU Kernel.Functions.JumpTable.NoShift                      ; переход по таблице переходов
.Delay              EQU Kernel.Functions.Delay                                  ; задержка 4 фрейма
.CustomDelay        EQU Kernel.Functions.Delay.DelayLoop                        ; кастомная задержка

                endif ; ~_KERNEL_FUNCTIONS_
