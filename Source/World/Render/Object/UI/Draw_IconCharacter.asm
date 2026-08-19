
                ifndef _WORLD_RENDER_OBJECT_UI_DRAW_ICON_CHARACTER_
                define _WORLD_RENDER_OBJECT_UI_DRAW_ICON_CHARACTER_
; -----------------------------------------
; отображение объекта UI - иконка персонажа
; In:
;   IX - адрес функции обработки спрайта
;   IY - адрес структуры объекта (FObjectUI)
; Out:
; Corrupt:
; Note:
; -----------------------------------------
Draw.IconChar:  ; получение индекса иконки персонажа
                LD A, (IY + FObjectCharacter.CharacterID)
                CALL Character.Utilities.GetAdr.HL
                INC L                                                           ; пропуск FCharacter.Class
                LD A, (HL)                                                      ; FCharacter.RepresentID
                LD L, A
                LD H, #00
                ADD HL, HL  ; x2
                ADD HL, HL  ; x4
                ADD HL, HL  ; x8
                ADD HL, HL  ; x16                                               ; размер структуры FRepresentation
                LD DE, Page0.Characters + FRepresentation.HeroID
                ADD HL, DE
                LD A, (HL)                                                      ; FRepresentation.HeroID
                EX AF, AF'                                                      ; сохранение индекса лица персонажа
                CALL Utilities.TransformToScr                                   ; DE - положение X, HL - положение Y
                POP IY                                                          ; восстановление адреса UI объекта

                ; прибавление смещения UI объекта по вертикали
                LD BC, (IY + FObject.Position.Y)
                ADD HL, BC
                LD (Kernel.Sprite.DrawClipping.PositionY), HL

                ; прибавление смещения UI объекта по горизонтали
                EX DE, HL
                LD BC, (IY + FObject.Position.X)
                ADD HL, BC
                LD (Kernel.Sprite.DrawClipping.PositionX), HL

                ; выравнивание экранного положения по знакоместу
                BIT LAYER_OBJECT_ATTR_ALIGN_BIT, (IY + FObjectUI.Layer.Flags)
                CALL NZ, World.Base.Render.Object.LayerObject.AlignToAttr

                ; получение индекса спрайта объекта UI
                LD A, (IY + FObject.Sprite)

                ; расчёт адреса структуры FSpritesRef в Adr.SpriteInfoBuffer
                ADD A, A    ; x2                                                ; старший флаг игнорируем, т.к. ставим его самостоятельно
                LD L, A
                LD H, HIGH Adr.SpriteInfoBuffer >> 2
                ADD HL, HL  ; x4
                ADD HL, HL  ; x8

                ; выбор маленького лица персонажа
                EX AF, AF'                                                      ; восстановление индекса лица персонажа
                SCF                                                             ; указываем на структуру FSpritesRef
                PUSH IY                                                         ; сохранение адреса UI объекта
                CALL_IX                                                         ; отображение спрайта
                SET_PAGE_OBJECT                                                 ; восстановление страницы работы с объектами
                POP IY                                                          ; восстановление адреса UI объекта
                JP World.Base.Render.Object.Draw.StoreBound                     ; сохранение рассчитанного bound в UI объекте

                endif ; ~_WORLD_RENDER_OBJECT_UI_DRAW_ICON_CHARACTER_
