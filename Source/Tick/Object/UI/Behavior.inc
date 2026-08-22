
                ifndef _TICK_OBJECT_UI_BEHAVIOR_
                define _TICK_OBJECT_UI_BEHAVIOR_
; -----------------------------------------
; последовательности фаз поведения UI объектов
; Note:
;   Default:
;     - выполняет существующее поведение UI
;     - остаётся в единственной фазе
;
;   Standard:
;     - устанавливает диапазон кадров анимации падения и включает анимацию
;     - обновляет прогресс до завершения падения штандарта
;     - устанавливает диапазон кадров анимации после приземления
;     - остаётся в пустой фазе
; -----------------------------------------
UI.Behavior:
.Table          DW .Default                                                     ; OBJECT_UI_BEHAVIOR_DEFAULT
                DW .Standard                                                    ; OBJECT_UI_BEHAVIOR_STANDARD

.Default        FUIBehaviorPhase {
                    /*Function*/ UI_BEHAVIOR_PHASE_FUNCTION_DEFAULT,
                    /*Flags*/    UI_BEHAVIOR_PHASE_LOOP | UI_BEHAVIOR_PHASE_STOP,
                    /*Settings*/ #0000
                }

.Standard       FUIBehaviorPhase {
                    /*Function*/ UI_BEHAVIOR_PHASE_FUNCTION_SET_ANIMATION_RANGE,
                    /*Flags*/    UI_BEHAVIOR_PHASE_NEXT | UI_BEHAVIOR_PHASE_CONTINUE,
                    /*Settings*/ .StandardAnimationDrop
                }
                FUIBehaviorPhase {
                    /*Function*/ UI_BEHAVIOR_PHASE_FUNCTION_SET_FLAGS,
                    /*Flags*/    UI_BEHAVIOR_PHASE_NEXT | UI_BEHAVIOR_PHASE_CONTINUE,
                    /*Settings*/ .StandardLayerFlags
                }
                FUIBehaviorPhase {
                    /*Function*/ UI_BEHAVIOR_PHASE_FUNCTION_UPDATE_PROGRESS,
                    /*Flags*/    UI_BEHAVIOR_PHASE_NEXT | UI_BEHAVIOR_PHASE_STOP,
                    /*Settings*/ .StandardProgress
                }
                FUIBehaviorPhase {
                    /*Function*/ UI_BEHAVIOR_PHASE_FUNCTION_SET_ANIMATION_RANGE,
                    /*Flags*/    UI_BEHAVIOR_PHASE_NEXT | UI_BEHAVIOR_PHASE_CONTINUE,
                    /*Settings*/ .StandardAnimationLanded
                }
                FUIBehaviorPhase {
                    /*Function*/ UI_BEHAVIOR_PHASE_FUNCTION_NONE,
                    /*Flags*/    UI_BEHAVIOR_PHASE_LOOP | UI_BEHAVIOR_PHASE_STOP,
                    /*Settings*/ #0000
                }

.StandardAnimationDrop
                FUISettings_AnimationRange {
                    /*Range*/ (#00 << UI_ANIMATION_RANGE_FIRST_BIT) | \
                              (#03 << UI_ANIMATION_RANGE_FRAME_MAX_BIT),
                    /*Mode*/  UI_ANIMATION_MODE_PING_PONG
                }

.StandardProgress
                FUISettings_Progress {
                    /*Step*/          #20,
                    /*Duration*/      #00,
                    /*Flags*/         UI_PROGRESS_AXIS_Y,
                    /*AxisFunctions*/ UI_AXIS_FUNCTION_Y_EASE_OUT,
                    {
                        /*AxisY.A*/ UI_STANDARD_DROP_HEIGHT,
                        /*AxisY.B*/ #00
                    },
                    {
                        /*AxisX.A*/ #00,
                        /*AxisX.B*/ #00
                    }
                }

.StandardAnimationLanded
                FUISettings_AnimationRange {
                    /*Range*/ (#00 << UI_ANIMATION_RANGE_FIRST_BIT) | \
                              (#03 << UI_ANIMATION_RANGE_FRAME_MAX_BIT),
                    /*Mode*/  UI_ANIMATION_MODE_PING_PONG
                }

.StandardLayerFlags
                FUISettings_Flags {
                    /*Flags*/ LAYER_OBJECT_ANIMATION_ENABLED | LAYER_OBJECT_AXIS_Y_OFFSET_SUBTRACT
                }

                endif ; ~_TICK_OBJECT_UI_BEHAVIOR_
