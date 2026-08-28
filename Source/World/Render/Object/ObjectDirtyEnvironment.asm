
                ifndef _WORLD_OBJECTS_DIRTY_ENVIRONMENT_
                define _WORLD_OBJECTS_DIRTY_ENVIRONMENT_
; -----------------------------------------
; построение света объектов и формирование принудительного обновления вокруг объект-спрайта
; In:
;   A - количество видимых объектов в Adr.SortBuffer
; Out:
; Corrupt:
; Note:
;   ℹ️ необходимо включить страницу 0
;   обход SortBuffer начинается с области Decal
;   при переполнении младшего байта адреса обход автоматически продолжается с начала SortBuffer,
;   что позволяет добавлять Decal с конца, а World и UI с начала буфера без перемещения области Decal
; -----------------------------------------
DirtyEnvir:     ; инициализация
                LD B, A

                ; проверка смены общего кадра анимации простых объектов
                LD A, (GameState.TickCounter + FTick.Objects)
.LastAnimationTick EQU $+1
                CP #00

                ; сохранение текущего кадра для следующего прохода
                LD (.LastAnimationTick), A
                LD A, #00                                                       ; по умолчанию кадр анимации не изменился
                JR Z, .StoreAnimationTickChanged                               ; сохранить нулевой признак, если кадр остался прежним
                INC A                                                           ; отметить необходимость обновить анимированные объекты

.StoreAnimationTickChanged
                ; сохранение признака независимо от переключения страницы объектов
                LD (.AnimationTickChanged), A
                LD D, HIGH Adr.SortBuffer                                       ; старший байт адреса SortBuffer
                LD A, (AddObjects.OffsetDecal)                                  ; смещение начала области Decal
                LD E, A                                                         ; адрес первого элемента списка

.Loop           ; чтение адреса объекта
                LD A, (DE)
                LD IYL, A
                INC E
                LD A, (DE)
                LD IYH, A
                INC E

                PUSH BC
                SET_PAGE_OBJECT                                                 ; включить страницу работы с объектами

.CheckAnimation
                ; проверка смены общего кадра анимации в текущем проходе
.AnimationTickChanged EQU $+1
                LD A, #00
                OR A
                JR Z, .CheckLight                                               ; пропустить обработку, если кадр анимации не изменился

                ; проверка класса простого статического объекта
                LD A, (IY + FObject.Class)
                AND OBJECT_CLASS_MASK
                CP OBJECT_CLASS_CONSTRUCTION
                JR NZ, .CheckLight                                              ; пропустить объект другого класса

                ; проверка ссылочного спрайта с массивом кадров
                BIT SPRITE_REF_BIT, (IY + FObject.Sprite)
                JR Z, .CheckLight                                               ; пропустить одиночный спрайт без массива кадров

                ; расчёт адреса структуры FSpritesRef в Adr.SpriteInfoBuffer
                LD A, (IY + FObject.Sprite)
                ADD A, A    ; x2                                                ; отбросить флаг ссылки и получить удвоенный индекс
                LD L, A
                LD H, HIGH Adr.SpriteInfoBuffer >> 2
                ADD HL, HL  ; x4
                ADD HL, HL  ; x8

                ; проверка обычного некомпозитного массива кадров
                LD A, (HL)
                BIT SPRITE_CS_BIT, A
                JR NZ, .CheckLight                                              ; пропустить композитный спрайт с собственным способом отрисовки
                AND #3F                                                        ; оставить количество кадров FSpritesRef
                CP #02
                JR C, .CheckLight                                               ; пропустить ссылку без сменяемых кадров

                ; обновление фона и спрайта после смены кадра анимации
                SET OBJECT_DIRTY_BIT, (IY + FObject.FastFlags)

.CheckLight     ; проверка флага источника света объекта
                BIT OBJECT_LIGHT_SOURCE_BIT, (IY + FObject.FastFlags)
                JR Z, .CheckDirty                                               ; перейти к обычной обработке, если объект не излучает свет
                PUSH DE                                                         ; сохранение адреса обхода SortBuffer

                ; проверка самостоятельного расчёта экранного положения объекта
                BIT OBJECT_SELF_CALCULATED_POSITION_BIT, (IY + FObject.FastFlags)
                JR NZ, .LightDone                                               ; пропустить свет, если основание объекта не связано с картой

                ; проверка фактической видимости гексагона с источником света
                CALL IsVisible
                JR C, .LightDone                                                ; пропустить свет, если гексагон объекта не отображается

                ; получение адреса настроек текущего источника света
                LD A, (IY + FObject.Settings)
                CALL Object.Utilities.GetSettingsAdr.HL

                ; переход к радиусу света в FObjectDefaultSettings.Variable_B
                INC L                                                           ; пропуск FObjectDefaultSettings.Class
                INC L                                                           ; пропуск FObjectDefaultSettings.Flags
                INC L                                                           ; пропуск FObjectDefaultSettings.Variable_A
                LD A, (HL)
                CALL Object.LightmapSource                                      ; добавить свет объекта во временную карту

.LightDone      POP DE                                                          ; восстановление адреса обхода SortBuffer

.CheckDirty
                ; проверка флага обновления объекта
                BIT OBJECT_DIRTY_BIT, (IY + FObject.FastFlags)
                JR Z, .NextObject                                               ; переход, если флаг не установлен
                PUSH DE

                ;   DE - позиция спрайта в пикселях (D - y, E - x)
                ;   BC - размер bound спрайта в пикселях (B - y, C - x)
                LD DE, (IY + FObject.Bound + FSpriteBound.Location)
                LD BC, (IY + FObject.Bound + FSpriteBound.Size)

                ; проверка наличия bound спрайта
                LD A, C
                OR B
                JR Z, .Failed                                                   ; перейти, если обе стороны отсутствующего bound нулевые

                PUSH BC
                SET_PAGE_MAP                                                    ; включить страницу работы с картой
                POP BC
                CALL BufferUtilities.SpriteBound                                ; обновление Render-буфера указанного bound спрайта

.Failed         POP DE
.NextObject     POP BC
                DJNZ .Loop                                                      ; продолжить, если остались объекты в SortBuffer
.RET            SCF                                                             ; флаг для таблицы вызова,
                                                                                ; говорит что bound спрайта неопределён
                RET

                display " - Object dirty environment:\t\t\t\t", /A, DirtyEnvir, "\t= busy [ ", /D, $-DirtyEnvir, " byte(s)  ]"

                endif ; ~_WORLD_OBJECTS_DIRTY_ENVIRONMENT_
