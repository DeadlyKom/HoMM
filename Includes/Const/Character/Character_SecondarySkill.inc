
                ifndef _CONST_CHARACTER_SECONDARY_SKILL_
                define _CONST_CHARACTER_SECONDARY_SKILL_
;   Уровни навыка:
SKILL_LEVEL_NONE        EQU 0                                                   ; 0 - нет навыка
SKILL_LEVEL_BASIC       EQU 1                                                   ; 1 - базовый
SKILL_LEVEL_ADVANCED    EQU 2                                                   ; 2 - продвинутый
SKILL_LEVEL_EXPERT      EQU 3                                                   ; 3 - эксперт
SKILL_LEVEL_MAX         EQU SKILL_LEVEL_EXPERT + 1                              ; максимальный

;   Множители PathfindingScale, fixed point 4.4:
PATHFINDING_SCALE_NONE      EQU 1.0   * 16                                      ; x1.0
PATHFINDING_SCALE_BASIC     EQU 0.875 * 16                                      ; x0.875
PATHFINDING_SCALE_ADVANCED  EQU 0.75  * 16                                      ; x0.75
PATHFINDING_SCALE_EXPERT    EQU 0.5   * 16                                      ; x0.5

                endif ; ~_CONST_CHARACTER_SECONDARY_SKILL_
