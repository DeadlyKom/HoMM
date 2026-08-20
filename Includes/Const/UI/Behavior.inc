
                ifndef _CONST_UI_BEHAVIOR_
                define _CONST_UI_BEHAVIOR_

; значения для поля FUIBehaviorPhase.Function
UI_BEHAVIOR_PHASE_FUNCTION_DEFAULT          EQU #00                             ; выполнить поведение UI по умолчанию
UI_BEHAVIOR_PHASE_FUNCTION_UPDATE_PROGRESS  EQU #01                             ; обновить прогресс и смещения осей
UI_BEHAVIOR_PHASE_FUNCTION_UPDATE_ANIMATION EQU #02                             ; обновить кадр анимации
UI_BEHAVIOR_PHASE_FUNCTION_MAX              EQU #03                             ; максимальное недоступное значение функции фазы

; значения для поля FUIBehaviorPhase.Flags
UI_BEHAVIOR_PHASE_LOOP_BIT                  EQU 0x00                            ; флаг, повтора фазы после её завершения
UI_BEHAVIOR_PHASE_STOP_BIT                  EQU 0x01                            ; флаг, остановки дальнейшего выполнения текущего тика

UI_BEHAVIOR_PHASE_NEXT                      EQU 0 << UI_BEHAVIOR_PHASE_LOOP_BIT         ; после завершения перейти к следующей фазе
UI_BEHAVIOR_PHASE_LOOP                      EQU 1 << UI_BEHAVIOR_PHASE_LOOP_BIT         ; после завершения запустить текущую фазу заново
UI_BEHAVIOR_PHASE_CONTINUE                  EQU 0 << UI_BEHAVIOR_PHASE_STOP_BIT         ; продолжить выполнение со следующей фазы в текущем тике
UI_BEHAVIOR_PHASE_STOP                      EQU 1 << UI_BEHAVIOR_PHASE_STOP_BIT         ; остановить выполнение цепочки до следующего тика

; значения функций преобразования Progress
UI_AXIS_FUNCTION_NONE                       EQU #00                             ; применить Progress без преобразования
UI_AXIS_FUNCTION_EASE_IN                    EQU #01                             ; применить EaseIn
UI_AXIS_FUNCTION_EASE_OUT                   EQU #02                             ; применить EaseOut
UI_AXIS_FUNCTION_EASE_IN_OUT                EQU #03                             ; применить EaseInOut
UI_AXIS_FUNCTION_MAX                        EQU #04                             ; максимальное недоступное значение функции преобразования
UI_AXIS_FUNCTION_MASK                       EQU #0F                             ; маска функции одной оси

; значения для поля FUIProgressSettings.Flags
UI_PROGRESS_AXIS_Y_BIT                      EQU 0x00                            ; флаг, обновления оси (обновлять AxisOffset.Y)
UI_PROGRESS_AXIS_X_BIT                      EQU 0x01                            ; флаг, обновления оси (обновлять AxisOffset.X)
UI_PROGRESS_AXIS_Y                          EQU 1 << UI_PROGRESS_AXIS_Y_BIT     ; обновлять AxisOffset.Y
UI_PROGRESS_AXIS_X                          EQU 1 << UI_PROGRESS_AXIS_X_BIT     ; обновлять AxisOffset.X
UI_PROGRESS_AXIS_NONE                       EQU (0 << UI_PROGRESS_AXIS_Y_BIT) | \
                                                (0 << UI_PROGRESS_AXIS_X_BIT)   ; не обновлять смещения осей
UI_PROGRESS_AXIS_XY                         EQU UI_PROGRESS_AXIS_Y | \
                                                UI_PROGRESS_AXIS_X              ; обновлять AxisOffset.X и AxisOffset.Y

; значения для поля FUIProgressSettings.AxisFunctions
UI_AXIS_FUNCTIONS_X_BIT                     EQU 0x04                            ; смещение в байте положения функции преобразования для оси X
UI_AXIS_FUNCTIONS_Y_BIT                     EQU 0x00                            ; смещение в байте положения функции преобразования для оси Y
UI_AXIS_FUNCTION_Y_NONE                     EQU UI_AXIS_FUNCTION_NONE           << UI_AXIS_FUNCTIONS_Y_BIT
UI_AXIS_FUNCTION_Y_EASE_IN                  EQU UI_AXIS_FUNCTION_EASE_IN        << UI_AXIS_FUNCTIONS_Y_BIT
UI_AXIS_FUNCTION_Y_EASE_OUT                 EQU UI_AXIS_FUNCTION_EASE_OUT       << UI_AXIS_FUNCTIONS_Y_BIT
UI_AXIS_FUNCTION_Y_EASE_IN_OUT              EQU UI_AXIS_FUNCTION_EASE_IN_OUT    << UI_AXIS_FUNCTIONS_Y_BIT

UI_AXIS_FUNCTION_X_NONE                     EQU UI_AXIS_FUNCTION_NONE           << UI_AXIS_FUNCTIONS_X_BIT
UI_AXIS_FUNCTION_X_EASE_IN                  EQU UI_AXIS_FUNCTION_EASE_IN        << UI_AXIS_FUNCTIONS_X_BIT
UI_AXIS_FUNCTION_X_EASE_OUT                 EQU UI_AXIS_FUNCTION_EASE_OUT       << UI_AXIS_FUNCTIONS_X_BIT
UI_AXIS_FUNCTION_X_EASE_IN_OUT              EQU UI_AXIS_FUNCTION_EASE_IN_OUT    << UI_AXIS_FUNCTIONS_X_BIT

                endif ; ~_CONST_UI_BEHAVIOR_
