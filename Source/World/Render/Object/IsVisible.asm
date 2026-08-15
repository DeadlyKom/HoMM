
                ifndef _WORLD_RENDER_OBJECT_IS_VISIBLE_
                define _WORLD_RENDER_OBJECT_IS_VISIBLE_
; -----------------------------------------
; проверка видимости объекта в RenderBuffer
; In:
;   IY - адрес структуры объекта (FObject)
; Out:
;   флаг переполнения установлен, если объект не виден
; Corrupt:
;   HL, BC, AF
; Note:
;   функция самостоятельно переключает страницу карты
;   и восстанавливает страницу работы с объектами
; -----------------------------------------
IsVisible:      ; получение индекса гекса в RenderBuffer
                LD C, (IY + FObject.Position.X.High)
                LD B, (IY + FObject.Position.Y.High)
                PUSH BC
                SET_PAGE_MAP
                POP BC

                ; определение индекса гекса в RenderBuffer
                CALL BufferUtilities.GetIndexRender
                JR C, .RestorePage                                              ; переход, если гекс не попал в RenderBuffer

                ; проверка видимости гекса
                LD H, HIGH Adr.RenderBuffer
                LD L, A
                BIT RENDER_FLAG_HEX_FOG_BIT, (HL)
                SCF                                                             ; установка флага переполнения, объект не виден
                JR Z, .RestorePage                                              ; переход, если гекс закрыт туманом

                OR A                                                            ; сброс флага переполнения, объект виден
.RestorePage    PUSH AF                                                         ; сохранение результата проверки
                SET_PAGE_OBJECT                                                 ; восстановление страницы работы с объектами
                POP AF                                                          ; восстановление результата проверки
                RET

                endif ; ~_WORLD_RENDER_OBJECT_IS_VISIBLE_
