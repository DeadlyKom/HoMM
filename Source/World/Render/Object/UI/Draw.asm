
                ifndef _WORLD_RENDER_OBJECT_UI_DRAW_
                define _WORLD_RENDER_OBJECT_UI_DRAW_
; -----------------------------------------
; отображение объекта UI
; In:
;   IX - адрес функции обработки спрайта
;   IY - адрес структуры объекта (FObjectUI)
; Out:
; Corrupt:
; Note:
; -----------------------------------------
Draw:           ; опредение объекта привязки
                LD A, (IY + FObjectUI.Anchor)
                CP UI_ANCHOR_NONE
                JR Z, .NotAnchor                                                ; переход, если объект не имеет объекта привязки

                ; расчёт экранного положения объекта привязки
                PUSH IY                                                         ; сохранение адреса UI объекта
                CALL Object.Utilities.GetAdr.IY
                CALL World.Base.Render.Object.IsVisible
                JR C, .NotVisible                                               ; переход, если объект привязки не виден

                ; определение типа объекта привязки (OBJECT_CLASS_CHARACTER и OBJECT_CLASS_CHARACTER_AI)
                LD A, (IY + FObjectUI.Layer.Super.Class)
                CP OBJECT_CLASS_CHARACTER_AI+1

                ; ToDo: добавить обработку других типов объектов привязки,
                ;       текущая реализация поддерживает только привязку к персонажу
                ifdef _DEBUG
                DEBUG_BREAK_POINT_NC                                            ; ошибка, объект привязки не является персонажем
                else
                RET NC                                                          ; выход, если объект привязки не является персонажем
                endif
                JP Draw.IconChar                                                ; отображениt иконки персонажа

.NotVisible     POP IY                                                          ; восстановление адреса UI объекта
                RET

.NotAnchor      ;
                RET

                endif ; ~_WORLD_RENDER_OBJECT_UI_DRAW_
