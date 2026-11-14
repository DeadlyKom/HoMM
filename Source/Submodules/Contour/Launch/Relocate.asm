                ifndef _SUBMODULES_CONTOUR_LAUNCH_RELOCATE_
                define _SUBMODULES_CONTOUR_LAUNCH_RELOCATE_
; -----------------------------------------
; настройка адресов таблицы и рабочего буфера обводки
; In:
;   HL - адрес таблицы расширения, выровненный по 256 байт
; Out:
; Corrupt:
;   AF
; Note:
;   рабочий буфер расположен после таблицы расширения
; -----------------------------------------
Relocate:       ; настройка частей таблицы расширения
                LD A, H

                ; настройка базового адреса таблицы
                LD (Submodules.Contour.Sprite.AddContour.Table), A

                ; настройка базового адреса внешней таблицы
                ADD A, #03
                LD (Submodules.Contour.Sprite.AddContour.Outer), A

                ; настройка адресов рабочих масок
                PUSH HL
                ADD A, #06
                LD H, A
                LD (Submodules.Contour.Sprite.AddContour.BufferH), A
                LD (Submodules.Contour.Sprite.AddContour.BufferO), A
                LD (Submodules.Contour.Sprite.AddContour.BufferV), HL
                POP HL
                RET

                endif                                                           ; ~_SUBMODULES_CONTOUR_LAUNCH_RELOCATE_
