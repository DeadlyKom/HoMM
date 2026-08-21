
                ifndef _STRUCT_OBJECT_UI_
                define _STRUCT_OBJECT_UI_
; -----------------------------------------
;   варианты поведения объекта UI формируются при его инициализации
;   и могут использоваться совместно:
;
;   Static      - Anchor равен UI_ANCHOR_NONE
;                 Layer.Super.Position хранит положение объекта UI на карте
;
;   Attached    - Anchor содержит идентификатор объекта привязки
;                 положение формируется из позиции объекта привязки
;                 и смещения Layer.Super.Position
;
;   Animated    - в Layer.Flags установлен LAYER_OBJECT_ANIMATION_ENABLED
;                 Animation.Range хранит диапазон кадров
;                 Animation.LastTick хранит последний обработанный FTick.Objects
;                 кадр анимации рассчитывается во время тика UI объекта
;
;   Hover       - в FODS_UI.Flags установлен OBJECT_UI_HOVER и разрешён тик объекта
;                 Anchor содержит идентификатор объекта привязки
;                 во время тика проверяется OBJECT_CURSOR_HIT_STATE
;                 объекта привязки и обновляется Lifetime
;
;   Temporary   - Lifetime содержит оставшееся время жизни объекта
;                 при завершении времени жизни объект удаляется
;
;   Persistent  - Lifetime равен UI_LIFETIME_INFINITE
;                 время жизни объекта не ограничено
;
;   тик объекта разрешается при обработке поведения, наведении
;   или ограниченном времени жизни
; -----------------------------------------
                struct FObjectUI                                                ; объект - элемент UI                                       [24 байта]
Layer           FLayerObject                                                    ; базовый класс объекта слоя                                [17 байт]
ZOrder          DB #00                                                          ; порядок отображения среди объектов UI                     [1 байт]
Anchor          DB #00                                                          ; идентификатор объекта привязки                            [1 байт]
                                                                                ; UI_ANCHOR_NONE - привязка отсутствует
Lifetime        DB #00                                                          ; оставшееся время жизни                                    [1 байт]
                                                                                ; UI_LIFETIME_INFINITE - время жизни не ограничено
Phase           DB #00                                                          ; индекс текущей фазы поведения                             [1 байт]
Progress        DB #00                                                          ; прогресс, промежуточные данные                            [1 байт]
Animation       FUIAnimation                                                    ; состояние анимации                                        [2 байта]
                ends

                endif ; ~_STRUCT_OBJECT_UI_
