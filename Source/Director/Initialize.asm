                
                ifndef _AI_DIRECTOR_INITIALIZE_
                define _AI_DIRECTOR_INITIALIZE_
; -----------------------------------------
; однократная инициализация директора после загрузки карты
; In:
; Out:
; Corrupt:
; Note:
;   код расположен в общей
; -----------------------------------------
Initialize:     ; проверка наличия списка "точек спавна"
                LD A, (AIDirector + FAIDirector.SpawnPointNum)
                OR A
                RET NZ                                                          ; выход, т.к. список "точек спавна" уже существует

                CALL LocationSearch.Launch
                JP SpawnPointFormation.Launch

                endif ; ~_AI_DIRECTOR_INITIALIZE_
