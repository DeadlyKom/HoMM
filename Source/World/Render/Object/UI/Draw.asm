
                ifndef _WORLD_RENDER_OBJECT_UI_DRAW_
                define _WORLD_RENDER_OBJECT_UI_DRAW_
; -----------------------------------------
; отображение объекта UI
; In:
;   IX - адрес функции обработки спрайта
;   IY - адрес структуры объекта (FObjectUI)
; Out:
;   флаг переполнения установлен, если спрайт виден
; Corrupt:
; Note:
; -----------------------------------------
Draw:           ; опредение объекта привязки
                LD A, (IY + FObjectUI.Anchor)
                CP UI_ANCHOR_NONE
                JR Z, .NoneAnchor                                               ; переход, если объект не имеет объекта привязки

                ; расчёт экранного положения объекта привязки
                PUSH IY                                                         ; сохранение адреса UI объекта
                CALL Object.Utilities.GetAdr.IY
                CALL World.Base.Render.Object.IsVisible
                JR C, .NotVisible                                               ; переход, если объект привязки не виден

                ; преобразование положения объекта относительно экрана
                ;   IY - адрес структуры FObject
                CALL Utilities.TransformToScr
                ;   HL - позиция по вертикали
                ;   DE - позиция по горизонтали
                ; флаг переполнения должен быть сброшен после вызова TransformToScr

                LD A, (IY + FObject.Class)                                      ; чтение типа объекта привязки

.NotVisible     POP IY                                                          ; восстановление адреса UI объекта
                CCF                                                             ; предустановка флага переполнения, объект привязки не виден
                RET NC                                                          ; выход, если объект привязки не виден

                ; определение типа объекта привязки (OBJECT_CLASS_CHARACTER и OBJECT_CLASS_CHARACTER_AI)
                ; ToDo: добавить обработку других типов объектов привязки,
                ;       текущая реализация поддерживает только привязку к персонажу
                CP OBJECT_CLASS_CHARACTER_AI+1
                JP C, Draw.IconChar                                             ; отображениt иконки персонажа

                ifdef _DEBUG
                DEBUG_BREAK_POINT                                               ; ошибка, объект привязки не является персонажем
                else
                RET                                                             ; выход, если объект привязки не является персонажем
                endif

.NoneAnchor     ; проверка видимости объекта
                CALL World.Base.Render.Object.IsVisible
                JR NC, Draw.NotAnchor                                           ; переход, если объект виден

                OR A                                                            ; сброс флага переполнения, объект не виден
                RET

.UI             ; выравнивание экранного положения по знакоместу
                BIT LAYER_OBJECT_ATTR_ALIGN_BIT, (IY + FObjectUI.Layer.Flags)
                CALL NZ, World.Base.Render.Object.LayerObject.AlignToAttr

                ; опредление типа объекта UI (в старшем полубайте, храниться смещение индекса)
                LD A, (IY + FObject.Settings)                                   ; настройки объекта по умолчанию
                CALL Object.Utilities.GetSettingsAdr.HL
                LD A, (HL)                                                      ; FObjectDefaultSettings.Class
                RRCA
                RRCA
                RRCA
                RRCA
                AND OBJECT_CLASS_MASK

                ; расчёт адреса структуры FSpritesRef в Adr.SpriteInfoBuffer
                LD HL, Indexes
                ADD A, (HL)
                ADD A, A    ; x2                                                ; старший флаг игнорируем, т.к. ставим его самостоятельно
                LD L, A
                LD H, HIGH Adr.SpriteInfoBuffer >> 2
                ADD HL, HL  ; x4
                ADD HL, HL  ; x8

                LD A, (IY + FObject.Sprite)                                     ; номер кадра внутри выбранного пакета спрайтов

                ; отображение спрайта
                SCF                                                             ; указываем на структуру FSpritesRef
                PUSH IY                                                         ; сохранение адреса UI объекта
                CALL_IX                                                         ; отображение спрайта
                POP IY                                                          ; восстановление адреса UI объекта
                RET NC                                                          ; выход, если спрайт отсечён

                SET_PAGE_OBJECT                                                 ; восстановление страницы работы с объектами
                CALL World.Base.Render.Object.Draw.StoreBound                   ; сохранение рассчитанного bound в UI объекте
                SCF                                                             ; установка флага переполнения, спрайт виден
                RET

                endif ; ~_WORLD_RENDER_OBJECT_UI_DRAW_
