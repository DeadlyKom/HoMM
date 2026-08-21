
                ifndef _TICK_OBJECT_UI_SET_ANIMATION_RANGE_
                define _TICK_OBJECT_UI_SET_ANIMATION_RANGE_
; -----------------------------------------
; установка диапазона кадров анимации UI объекта
; In:
;   IX - адрес структуры объекта (FObjectUI)
;   DE - адрес структуры настроек (FUISettings_AnimationRange)
; Out:
;   флаг переполнения установлен, фаза завершена
; Corrupt:
;   BC, DE, AF
; Note:
;   - диапазон и режим проигрывания копируются из настроек в состояние объекта
;   - начальный кадр определяется направлением проигрывания
;   - Animation.LastTick исключает смену кадра до следующего FTick.Objects
;
;   ℹ️ код расположен в странице 0
; ----------------------------------------
UI.SetAnimRange:; сохранение диапазона кадров в состоянии UI объекта
                LD A, (DE)                                                      ; FUISettings_AnimationRange.Range
                LD (IX + FObjectUI.Animation.Range), A

                ; установка режима проигрывания анимации в состоянии UI объекта
                INC DE                                                          ; переход к FUISettings_AnimationRange.Mode
                LD A, (DE)
                AND UI_ANIMATION_MODE_MASK                                      ; получение режима проигрывания анимации
                LD B, A

                LD A, (IX + FObjectUI.Layer.Flags)
                AND ~UI_ANIMATION_MODE_MASK                                     ; сброс предыдущего режима проигрывания
                OR B                                                            ; установка нового режима проигрывания
                LD (IX + FObjectUI.Layer.Flags), A

                ; получение первого кадра диапазона
                LD A, (IX + FObjectUI.Animation.Range)
                LD B, A
                AND UI_ANIMATION_RANGE_FIRST_MASK
                RRCA
                RRCA
                RRCA
                RRCA                                                            ; A = первый кадр диапазона
                LD C, A

                ; выбор начального кадра в зависимости от направления проигрывания
                BIT UI_ANIMATION_MODE_REVERSE_BIT, (IX + FObjectUI.Layer.Flags)
                JR Z, .StoreFrame                                               ; переход, если проигрывание начинается с первого кадра

                LD A, B
                AND UI_ANIMATION_RANGE_FRAME_MAX_MASK                           ; максимальный локальный номер кадра
                ADD A, C                                                        ; A = последний кадр диапазона

.StoreFrame     ; сохранение начального кадра проигрывания
                LD (IX + FObject.Sprite), A

                ; сохранение текущего тика объектов
                LD A, (GameState.TickCounter + FTick.Objects)
                LD (IX + FObjectUI.Animation.LastTick), A                       ; запрет смены кадра до следующего тика объектов
                SCF                                                             ; флаг переполнения установлен, фаза завершена
                JP UI.MarkDirty                                                 ; обновление области объекта после смены диапазона

                endif ; ~_TICK_OBJECT_UI_SET_ANIMATION_RANGE_
