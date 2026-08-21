
                ifndef _CONST_UI_BEHAVIOR_
                define _CONST_UI_BEHAVIOR_

; значения для поля FUIBehaviorPhase.Function
UI_BEHAVIOR_PHASE_FUNCTION_NONE                 EQU #00                                     ; не выполнять никаких действий
UI_BEHAVIOR_PHASE_FUNCTION_DEFAULT              EQU #01                                     ; выполнить поведение UI по умолчанию
UI_BEHAVIOR_PHASE_FUNCTION_UPDATE_PROGRESS      EQU #02                                     ; обновить прогресс и смещения осей
UI_BEHAVIOR_PHASE_FUNCTION_SET_ANIMATION_RANGE  EQU #03                                     ; установить диапазон кадров анимации
UI_BEHAVIOR_PHASE_FUNCTION_SET_FLAGS            EQU #04                                     ; установить флаги UI объекта
UI_BEHAVIOR_PHASE_FUNCTION_RESET_FLAGS          EQU #05                                     ; сбросить флаги UI объекта
UI_BEHAVIOR_PHASE_FUNCTION_MAX                  EQU #06                                     ; максимальное недоступное значение функции фазы

; значения для поля FUIBehaviorPhase.Flags
UI_BEHAVIOR_PHASE_LOOP_BIT                      EQU 0x00                                    ; флаг, повтора фазы после её завершения
UI_BEHAVIOR_PHASE_STOP_BIT                      EQU 0x01                                    ; флаг, остановки дальнейшего выполнения текущего тика

UI_BEHAVIOR_PHASE_NEXT                          EQU 0 << UI_BEHAVIOR_PHASE_LOOP_BIT         ; после завершения перейти к следующей фазе
UI_BEHAVIOR_PHASE_LOOP                          EQU 1 << UI_BEHAVIOR_PHASE_LOOP_BIT         ; после завершения запустить текущую фазу заново
UI_BEHAVIOR_PHASE_CONTINUE                      EQU 0 << UI_BEHAVIOR_PHASE_STOP_BIT         ; продолжить выполнение со следующей фазы в текущем тике
UI_BEHAVIOR_PHASE_STOP                          EQU 1 << UI_BEHAVIOR_PHASE_STOP_BIT         ; остановить выполнение цепочки до следующего тика

; значения функций преобразования Progress
UI_AXIS_FUNCTION_NONE                           EQU #00                                     ; применить Progress без преобразования
UI_AXIS_FUNCTION_EASE_IN                        EQU #01                                     ; применить EaseIn
UI_AXIS_FUNCTION_EASE_OUT                       EQU #02                                     ; применить EaseOut
UI_AXIS_FUNCTION_EASE_IN_OUT                    EQU #03                                     ; применить EaseInOut
UI_AXIS_FUNCTION_MAX                            EQU #04                                     ; максимальное недоступное значение функции преобразования
UI_AXIS_FUNCTION_MASK                           EQU #0F                                     ; маска функции одной оси

; значения для поля FUISettings_Progress.Flags
UI_PROGRESS_AXIS_Y_BIT                          EQU 0x00                                    ; флаг, обновления оси (обновлять AxisOffset.Y)
UI_PROGRESS_AXIS_X_BIT                          EQU 0x01                                    ; флаг, обновления оси (обновлять AxisOffset.X)
UI_PROGRESS_AXIS_Y                              EQU 1 << UI_PROGRESS_AXIS_Y_BIT             ; обновлять AxisOffset.Y
UI_PROGRESS_AXIS_X                              EQU 1 << UI_PROGRESS_AXIS_X_BIT             ; обновлять AxisOffset.X
UI_PROGRESS_AXIS_NONE                           EQU (0 << UI_PROGRESS_AXIS_Y_BIT) | \
                                                    (0 << UI_PROGRESS_AXIS_X_BIT)           ; не обновлять смещения осей
UI_PROGRESS_AXIS_XY                             EQU UI_PROGRESS_AXIS_Y | \
                                                    UI_PROGRESS_AXIS_X                      ; обновлять AxisOffset.X и AxisOffset.Y

; значения для поля FUISettings_Progress.AxisFunctions
UI_AXIS_FUNCTIONS_X_BIT                         EQU 0x04                                    ; смещение в байте положения функции преобразования для оси X
UI_AXIS_FUNCTIONS_Y_BIT                         EQU 0x00                                    ; смещение в байте положения функции преобразования для оси Y
UI_AXIS_FUNCTION_Y_NONE                         EQU UI_AXIS_FUNCTION_NONE           << UI_AXIS_FUNCTIONS_Y_BIT
UI_AXIS_FUNCTION_Y_EASE_IN                      EQU UI_AXIS_FUNCTION_EASE_IN        << UI_AXIS_FUNCTIONS_Y_BIT
UI_AXIS_FUNCTION_Y_EASE_OUT                     EQU UI_AXIS_FUNCTION_EASE_OUT       << UI_AXIS_FUNCTIONS_Y_BIT
UI_AXIS_FUNCTION_Y_EASE_IN_OUT                  EQU UI_AXIS_FUNCTION_EASE_IN_OUT    << UI_AXIS_FUNCTIONS_Y_BIT

UI_AXIS_FUNCTION_X_NONE                         EQU UI_AXIS_FUNCTION_NONE           << UI_AXIS_FUNCTIONS_X_BIT
UI_AXIS_FUNCTION_X_EASE_IN                      EQU UI_AXIS_FUNCTION_EASE_IN        << UI_AXIS_FUNCTIONS_X_BIT
UI_AXIS_FUNCTION_X_EASE_OUT                     EQU UI_AXIS_FUNCTION_EASE_OUT       << UI_AXIS_FUNCTIONS_X_BIT
UI_AXIS_FUNCTION_X_EASE_IN_OUT                  EQU UI_AXIS_FUNCTION_EASE_IN_OUT    << UI_AXIS_FUNCTIONS_X_BIT

UI_STANDARD_DROP_HEIGHT                         EQU #FF                                     ; начальная высота падения штандарта над гексом

; значения для поля FUIAnimation.Range и FUISettings_AnimationRange.Range
UI_ANIMATION_RANGE_FRAME_MAX_BIT                EQU 0x00                                    ; начальный бит - максимального локального номера кадра диапазона
UI_ANIMATION_RANGE_FIRST_BIT                    EQU 0x04                                    ; начальный бит - первого кадра диапазона
UI_ANIMATION_RANGE_FRAME_MAX_MASK               EQU #0F                                     ; маска - максимального локального номера кадра диапазона
UI_ANIMATION_RANGE_FIRST_MASK                   EQU #F0                                     ; маска - первого кадра диапазона

; значения для поля FUISettings_AnimationRange.Mode и FObjectUI.Layer.Flags
UI_ANIMATION_MODE_REVERSE_BIT                   EQU 0x04                                    ; флаг, направления проигрывания анимации
                                                                                             ;   0 - прямое
                                                                                             ;   1 - обратное
UI_ANIMATION_MODE_PING_PONG_BIT                 EQU 0x05                                    ; флаг, пинг-понга
                                                                                             ;   0 - выключен
                                                                                             ;   1 - включён

UI_ANIMATION_MODE_FORWARD                       EQU 0 << UI_ANIMATION_MODE_REVERSE_BIT       ; прямое проигрывание анимации
UI_ANIMATION_MODE_REVERSE                       EQU 1 << UI_ANIMATION_MODE_REVERSE_BIT       ; обратное проигрывание анимации
UI_ANIMATION_MODE_PING_PONG                     EQU 2 << UI_ANIMATION_MODE_REVERSE_BIT       ; прямое проигрывание анимации с пинг-понгом
UI_ANIMATION_MODE_PING_PONG_REVERSE             EQU 3 << UI_ANIMATION_MODE_REVERSE_BIT       ; обратное проигрывание анимации с пинг-понгом
UI_ANIMATION_MODE_MASK                          EQU 3 << UI_ANIMATION_MODE_REVERSE_BIT       ; маска режима проигрывания анимации

                endif ; ~_CONST_UI_BEHAVIOR_
