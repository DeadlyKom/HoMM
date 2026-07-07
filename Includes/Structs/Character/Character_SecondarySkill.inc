
                ifndef _STRUCTS_CHARACTER_SECONDARY_SKILL_
                define _STRUCTS_CHARACTER_SECONDARY_SKILL_

                struct FSecondarySkill                                          ; вторичные навыки героя                                    [байт]
; -----------------------------------------
;   Общий навык передвижения по сложным участкам маршрута.
;   Навык не хранит стоимость поверхности, а задаёт множитель,
;   участвующий в расчёте EffectiveStepCost.
;
;   EffectiveStepCost =
;       ceil(SurfaceStepCost * PathfindingScale / 16)
;
;   Уровни навыка задаются константами SKILL_LEVEL_*:
;     SKILL_LEVEL_NONE     - нет навыка
;     SKILL_LEVEL_BASIC    - базовый
;     SKILL_LEVEL_ADVANCED - продвинутый
;     SKILL_LEVEL_EXPERT   - эксперт
;
;   Предварительная таблица множителей стоимости:
;     SKILL_LEVEL_NONE     -> 16    x1.00
;     SKILL_LEVEL_BASIC    -> 14    x0.875
;     SKILL_LEVEL_ADVANCED -> 12    x0.75
;     SKILL_LEVEL_EXPERT   -> 8     x0.50
;
;   В дальнейшем к формуле могут последовательно добавляться
;   UnitTerrainScale, BuffScale и DebuffScale как отдельные
;   4.4-множители с делением на 16
; -----------------------------------------
Pathfinding     DB #00                                                          ; общий навык проходимости                                  [1 байт]

                ends

; -----------------------------------------
; Направление развития вторичных навыков движения
;
; Первая итерация использует только Pathfinding как общий навык проходимости.
; Он снижает EffectiveStepCost через PathfindingScale и позволяет проверить
; всю цепочку расчёта:
;
;   поверхность
;   базовая стоимость
;   уровень навыка персонажа
;   итоговая стоимость DDA-шага
;
; Следующие навыки добавляются только при появлении игровой необходимости:
;
;   Mountaineering - бонус к горным/каменистым участкам
;   Forestry       - бонус к лесным участкам
;   Marshwalking   - бонус к болотистым/топким участкам
;
; Каждый новый навык должен добавлять не новую стоимость поверхности,
; а отдельный множитель к расчёту EffectiveStepCost
; -----------------------------------------

                endif ; ~_STRUCTS_CHARACTER_SECONDARY_SKILL_
