
                ifndef _SUBMODULES_CONTOUR_KERNEL_BIND_
                define _SUBMODULES_CONTOUR_KERNEL_BIND_
KERNEL_ID_COUNTER defl 0                                                        ; счётчик идентификаторов

; идентификаторы функций
                ; ⚠️ ВАЖНО ⚠️ функция с идентификатором 0 автоматически вызывается после релокации ресурса
                BIND_ID_KERNEL Contour.Initialize, Launch                       ; функция запуска (0)
                BIND_ID_KERNEL Contour.Release, Release                         ; освобождение памяти и ресурса сабмодуля
                BIND_ID_KERNEL Contour.AddContour, Sprite.AddContour            ; добавление контура к спрайту

                endif ; ~_SUBMODULES_CONTOUR_KERNEL_BIND_
