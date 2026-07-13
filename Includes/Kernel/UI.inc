
                ifndef _KERNEL_UI_
                define _KERNEL_UI_
UI:
.Update         EQU Kernel.UI.Update                                            ; обновление UI
UI.Runtime:
.Request            EQU Kernel.UI.Runtime.Request                               ; запрос смены UI режима
.Process            EQU Kernel.UI.Runtime.Process                               ; обработка запроса смены UI режима
.Complete           EQU Kernel.UI.Runtime.Complete                              ; завершить перехода запроса смены UI режима
.Resume             EQU Kernel.UI.Runtime.Complete.Resume                       ; завершить перехода запроса смены UI режима (полное восстановление)
.StartTransition    EQU Kernel.UI.Runtime.StartTransition                       ; начать перехода запроса смены UI режима

                endif ; ~_KERNEL_UI_
