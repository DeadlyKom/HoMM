
                ifndef _CHARACTER_UTILITIES_GET_VIEW_RADIUS_
                define _CHARACTER_UTILITIES_GET_VIEW_RADIUS_
; -----------------------------------------
; получение радиуса обзора персонажа
; In:
; Out:
;   A - радиус обзора в тайлах
; Corrupt:
; Note:
;   ℹ️ код расположен в странице 0
; -----------------------------------------
GetViewRadius:  ; ToDo: используя данные о персонаже FCharacter, получить
                ;       радиус обзора с учётом класса и навыков FSecondarySkill
                LD A, 1
                RET

                endif ; ~_CHARACTER_UTILITIES_GET_VIEW_RADIUS_
