
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
;     - обновляет прогресс падения штандарта
;     - в том же тике временно переходит к обновлению анимации
;     - после завершения прогресса сохраняет фазу анимации
;     - анимация выполняется циклически
; -----------------------------------------
UI.Behavior:
.Default        FUIBehaviorPhase {
                    /*Function*/ UI_BEHAVIOR_PHASE_FUNCTION_DEFAULT,
                    /*Flags*/    UI_BEHAVIOR_PHASE_LOOP | UI_BEHAVIOR_PHASE_STOP,
                    /*Settings*/ #0000
                }

.Standard       FUIBehaviorPhase {
                    /*Function*/ UI_BEHAVIOR_PHASE_FUNCTION_UPDATE_PROGRESS,
                    /*Flags*/    UI_BEHAVIOR_PHASE_NEXT | UI_BEHAVIOR_PHASE_CONTINUE,
                    /*Settings*/ .StandardProgress
                }
                FUIBehaviorPhase {
                    /*Function*/ UI_BEHAVIOR_PHASE_FUNCTION_UPDATE_ANIMATION,
                    /*Flags*/    UI_BEHAVIOR_PHASE_LOOP | UI_BEHAVIOR_PHASE_STOP,
                    /*Settings*/ #0000
                }

.StandardProgress
                FUIProgressSettings {
                    /*Step*/          #01,
                    /*Flags*/         UI_PROGRESS_AXIS_Y,
                    /*AxisFunctions*/ UI_AXIS_FUNCTION_Y_EASE_OUT
                }

                endif ; ~_TICK_OBJECT_UI_BEHAVIOR_
