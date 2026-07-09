
                ifndef _CONST_CHARACTER_SECONDARY_SKILL_
                define _CONST_CHARACTER_SECONDARY_SKILL_
; уровни навыка
SKILL_LEVEL_NONE        EQU 0                                                   ; 0 - нет навыка
SKILL_LEVEL_BASIC       EQU 1                                                   ; 1 - базовый
SKILL_LEVEL_ADVANCED    EQU 2                                                   ; 2 - продвинутый
SKILL_LEVEL_EXPERT      EQU 3                                                   ; 3 - эксперт
SKILL_LEVEL_MAX         EQU SKILL_LEVEL_EXPERT + 1                              ; максимальный

; множители PathfindingScale, fixed point 4.4:
                lua allpass
                local function pathfinding_scale(name, multiplier)
                    sj.insert_define_i(name, math.floor(multiplier * 16 + 0.5))
                end

                pathfinding_scale("PATHFINDING_SCALE_NONE",     1.0)            -- x1.0
                pathfinding_scale("PATHFINDING_SCALE_BASIC",    0.875)          -- x0.875
                pathfinding_scale("PATHFINDING_SCALE_ADVANCED", 0.75)           -- x0.75
                pathfinding_scale("PATHFINDING_SCALE_EXPERT",   0.5)            -- x0.5
                endlua

                endif ; ~_CONST_CHARACTER_SECONDARY_SKILL_
