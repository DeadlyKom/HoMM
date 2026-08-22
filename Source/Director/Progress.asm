                ifndef _AI_DIRECTOR_PROGRESS_
                define _AI_DIRECTOR_PROGRESS_
; -----------------------------------------
; продвижение прогресса работы директора
; In:
;   BC — шаг прогресса в формате fixed-point 8.8
; Out:
; Corrupt:
; Note:
;   ℹ️ код расположен в "общей памяти"
;
;   функция сохраняет регистры вызывающего кода
;   активная страница восстанавливается механизмом Progress
; -----------------------------------------
ProgressIncrement:
                PUSH AF
                PUSH BC
                PUSH DE
                PUSH HL

                LAUNCH_ASSET_FUNCTION Progress.EnterProgress, ExecuteModule.Progress

                POP HL
                POP DE
                POP BC
                POP AF
                RET
; -----------------------------------------
; установка точного порога прогресса работы директора
; In:
;   BC — порог прогресса в формате fixed-point 8.8
; Out:
; Corrupt:
;   HL, DE, BC, AF
; Note:
;   ℹ️ код расположен в "общей памяти"
; -----------------------------------------
ProgressToPercent:
                JP_LAUNCH_ASSET_FUNCTION Progress.ToPercent, ExecuteModule.Progress

                endif ; ~_AI_DIRECTOR_PROGRESS_
