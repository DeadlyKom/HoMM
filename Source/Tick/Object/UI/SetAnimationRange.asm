
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
;   AF
; Note:
;   диапазон копируется из настроек в состояние объекта
;   Animation.Offset синхронизирует первый кадр диапазона с текущим FTick.Objects:
;     Offset = -FTick.Objects
;
;   при отрисовке первый кадр диапазона будет выбран следующим образом:
;     FrameNum   = (Range & UI_ANIMATION_RANGE_FRAME_MAX_MASK) + 1
;     LocalFrame = (FTick.Objects + Offset) % FrameNum
;
;   ℹ️ код расположен в странице 0
; ----------------------------------------
UI.SetAnimRange:; сохранение диапазона кадров в состоянии UI объекта
                LD A, (DE)                                                      ; FUISettings_AnimationRange.Range
                LD (IX + FObjectUI.Animation.Range), A

                ; синхронизация первого кадра диапазона с текущим тиком объектов
                LD A, (GameState.TickCounter + FTick.Objects)
                NEG
                LD (IX + FObjectUI.Animation.Offset), A                         ; Offset = -FTick.Objects
                SCF                                                             ; флаг переполнения установлен, фаза завершена
                JP UI.MarkDirty                                                 ; обновление области объекта после смены диапазона

                endif ; ~_TICK_OBJECT_UI_SET_ANIMATION_RANGE_
