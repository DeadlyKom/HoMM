
                ifndef _OBJECT_UTILITIES_INVALIDATE_BOUND_
                define _OBJECT_UTILITIES_INVALIDATE_BOUND_
; -----------------------------------------
; обновить область последнего bound объекта перед удалением
; In:
;   IX - адрес структуры объекта (FObject)
; Out:
;   IX - сохраняет исходное значение
; Corrupt:
;   все регистры, кроме IX
; Note:
;   ℹ️ код расположен в странице 0
; -----------------------------------------
InvalidateBound:; получение последнего bound объекта
                LD DE, (IX + FObject.Bound + FSpriteBound.Location)
                LD BC, (IX + FObject.Bound + FSpriteBound.Size)
                EXX                                                             ; передача положения и размера через альтернативные регистры

                PUSH IX                                                         ; сохранение адреса объекта
                CALL_IN_PAGE \
                    Page.Page1, \
                    BufferUtilities.SpriteBound.Wrap                            ; обновление Render-буфера указанного bound
                POP IX                                                          ; восстановление адреса объекта
                RET

                endif ; ~_OBJECT_UTILITIES_INVALIDATE_BOUND_
