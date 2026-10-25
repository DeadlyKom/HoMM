
                ifndef _CONST_ITEM_PROPERTY_
                define _CONST_ITEM_PROPERTY_

; -----------------------------------------
;   идентификаторы свойств предметов
;   значения назначаются последовательно в порядке регистрации
; -----------------------------------------

ITEM_PROPERTY_ID_COUNTER defl 0
REG_ITEM_PROPERTY_ID macro Label?
Label?              EQU ITEM_PROPERTY_ID_COUNTER
ITEM_PROPERTY_ID_COUNTER = ITEM_PROPERTY_ID_COUNTER + 1
                    endm
ITEM_PROPERTY_NONE  EQU 0xFF                                                    ; свойство отсутствует

; -----------------------------------------
;   основные характеристики героя
; -----------------------------------------
                REG_ITEM_PROPERTY_ID ITEM_PROPERTY_ATTACK                       ; навык атаки
                REG_ITEM_PROPERTY_ID ITEM_PROPERTY_DEFESE                       ; навык защиты
                REG_ITEM_PROPERTY_ID ITEM_PROPERTY_POWER                        ; сила заклинаний
                REG_ITEM_PROPERTY_ID ITEM_PROPERTY_KNOWLEDGE                    ; навык знаний

; -----------------------------------------
;   вспомогательные свойства героя
; -----------------------------------------
                REG_ITEM_PROPERTY_ID ITEM_PROPERTY_PATHFINDING                  ; поиск пути на карте приключений
                REG_ITEM_PROPERTY_ID ITEM_PROPERTY_MAXMANA                      ; максимальная мана героя
                REG_ITEM_PROPERTY_ID ITEM_PROPERTY_GOLDBONUS                    ; бонус к золоту за победу
                REG_ITEM_PROPERTY_ID ITEM_PROPERTY_MAGICBONUS                   ; бонус поиска магических предметов
                REG_ITEM_PROPERTY_ID ITEM_PROPERTY_ADDCLASSSKILLS               ; бонус умениям класса
                REG_ITEM_PROPERTY_ID ITEM_PROPERTY_SINGLESKILL                  ; бонус отдельному умению
                REG_ITEM_PROPERTY_ID ITEM_PROPERTY_ALLSKILLS                    ; бонус всем умениям
                REG_ITEM_PROPERTY_ID ITEM_PROPERTY_CHARGED_SKILL                ; заряды умения

; -----------------------------------------
;   свойства, распространяющиеся на существ
; -----------------------------------------
                REG_ITEM_PROPERTY_ID ITEM_PROPERTY_MAXHP                        ; максимальное здоровье (существам)
                REG_ITEM_PROPERTY_ID ITEM_PROPERTY_TOHIT                        ; рейтинг атаки существ, используется против защиты цели при расчёте шанса попадания, не процент
                REG_ITEM_PROPERTY_ID ITEM_PROPERTY_ARMOR_PERCENT                ; увеличение показателя защиты в процентах, Enhanced Defense (существам)
                REG_ITEM_PROPERTY_ID ITEM_PROPERTY_DAMAGE_PERCENT               ; увеличение минимального и максимального урона в процентах, Enhanced Damage (существам)
                REG_ITEM_PROPERTY_ID ITEM_PROPERTY_MAXDAMAGE_PERCENT            ; увеличение только максимального урона в процентах (существам)
                REG_ITEM_PROPERTY_ID ITEM_PROPERTY_MINDAMAGE                    ; минимальный урон (существам)
                REG_ITEM_PROPERTY_ID ITEM_PROPERTY_MAXDAMAGE                    ; максимальный урон (существам)
                REG_ITEM_PROPERTY_ID ITEM_PROPERTY_DAMAGERESIST                 ; уменьшение входящего физического урона в процентах (существам)
                REG_ITEM_PROPERTY_ID ITEM_PROPERTY_MAGICRESIST                  ; сопротивление магическому урону (существам)
                REG_ITEM_PROPERTY_ID ITEM_PROPERTY_FIRERESIST                   ; сопротивление огню (существам)
                REG_ITEM_PROPERTY_ID ITEM_PROPERTY_LIGHTRESIST                  ; сопротивление молнии (существам)
                REG_ITEM_PROPERTY_ID ITEM_PROPERTY_COLDRESIST                   ; сопротивление холоду (существам)
                REG_ITEM_PROPERTY_ID ITEM_PROPERTY_POISONRESIST                 ; сопротивление яду (существам)
                REG_ITEM_PROPERTY_ID ITEM_PROPERTY_FIREMINDAM                   ; минимальный урон огнём (существам)
                REG_ITEM_PROPERTY_ID ITEM_PROPERTY_FIREMAXDAM                   ; максимальный урон огнём (существам)
                REG_ITEM_PROPERTY_ID ITEM_PROPERTY_COLDMINDAM                   ; минимальный урон холодом (существам)
                REG_ITEM_PROPERTY_ID ITEM_PROPERTY_COLDMAXDAM                   ; максимальный урон холодом (существам)
                REG_ITEM_PROPERTY_ID ITEM_PROPERTY_FASTERATTACKRATE             ; скорость атаки (существам)
                REG_ITEM_PROPERTY_ID ITEM_PROPERTY_FASTERMOVEVELOCITY           ; скорость передвижения (существам и герою)
                REG_ITEM_PROPERTY_ID ITEM_PROPERTY_OPENWOUNDS                   ; шанс открытых ран (существам)
                REG_ITEM_PROPERTY_ID ITEM_PROPERTY_CRUSHINGBLOW                 ; шанс сокрушительного удара (существам)
                REG_ITEM_PROPERTY_ID ITEM_PROPERTY_DEADLYSTRIKE                 ; шанс смертельного удара (существам)
                REG_ITEM_PROPERTY_ID ITEM_PROPERTY_SKILLONATTACK                ; применение умения при атаке (существам)
                REG_ITEM_PROPERTY_ID ITEM_PROPERTY_SKILLONHIT                   ; применение умения при попадании (существам)
                REG_ITEM_PROPERTY_ID ITEM_PROPERTY_SKILLONGETHIT                ; применение умения при получении удара (существам)

                endif ; ~_CONST_ITEM_PROPERTY_
