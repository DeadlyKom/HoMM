
                ifndef _METADATA_ITEMS_AMULET_
                define _METADATA_ITEMS_AMULET_
; -----------------------------------------
;   амулеты
; -----------------------------------------
                module Jewelry
; -----------------------------------------
; формирование базового описания амулета
; In:
;   Label?    - метка амулета
;   NameID?   - индекс текста названия
;   VisualID? - индекс визуала амулета
;   Flags?    - флаги базового предмета ITEM_FLAG_
; -----------------------------------------
ITEM_AMULET     macro Label?, NameID?, VisualID?, Flags?
                ITEM_BASE Label?,                   \
                    Text.Items.Jewelry. _ NameID?,  \
                    Graphics.UI.Items. _ VisualID?, \
                    ITEM_TYPE_AMULET, Flags?
                endm
                
                ; "Волчий клык"
                ITEM_AMULET AMULET_01, NAME_AMULET_01, VISIAL_AMULET_09, ITEM_FLAG_NONE
                ITEM_PROPERTY ITEM_PROPERTY_DAMAGE_PERCENT, 5
                ITEM_PROPERTY ITEM_PROPERTY_ATTACK, 1                           ; навык атаки героя
                ITEM_PROPERTY ITEM_PROPERTY_TOHIT, 2                            ; рейтинг атаки существ
                ITEM_PROPERTY ITEM_PROPERTY_MINDAMAGE, 1                        ; минимальный урон существ
                ITEM_END AMULET_01

                ; "Кремень духа"
                ITEM_AMULET AMULET_02, NAME_AMULET_02, VISIAL_AMULET_01, ITEM_FLAG_NONE
                ITEM_PROPERTY ITEM_PROPERTY_DAMAGERESIST, 5
                ITEM_PROPERTY ITEM_PROPERTY_DEFESE, 1                           ; навык защиты героя
                ITEM_PROPERTY ITEM_PROPERTY_MAGICRESIST, 10                     ; сопротивление магии в процентах
                ITEM_PROPERTY ITEM_PROPERTY_MAXHP, 3                            ; максимальное здоровье существ
                ITEM_END AMULET_02

                ; "Оберег странника"
                ITEM_AMULET AMULET_03, NAME_AMULET_03, VISIAL_AMULET_03, ITEM_FLAG_NONE
                ITEM_PROPERTY ITEM_PROPERTY_PATHFINDING, 1
                ITEM_PROPERTY ITEM_PROPERTY_MAXMANA, 5                          ; максимальный запас маны героя
                ITEM_PROPERTY ITEM_PROPERTY_KNOWLEDGE, 1                        ; навык знаний героя
                ITEM_END AMULET_03

                ; "Купеческая мошна"
                ITEM_AMULET AMULET_04, NAME_AMULET_04, VISIAL_AMULET_04, ITEM_FLAG_NONE
                ITEM_PROPERTY ITEM_PROPERTY_GOLDBONUS, 1
                ITEM_PROPERTY ITEM_PROPERTY_POWER, 1                            ; сила заклинаний героя
                ITEM_PROPERTY ITEM_PROPERTY_MAXMANA, 10                         ; максимальный запас маны героя
                ITEM_END AMULET_04

                ; "Оберег ратоборца"
                ITEM_AMULET AMULET_05, NAME_AMULET_05, VISIAL_AMULET_07, ITEM_FLAG_NONE
                ITEM_PROPERTY ITEM_PROPERTY_ATTACK, 3
                ITEM_PROPERTY ITEM_PROPERTY_POWER, 1
                ITEM_PROPERTY ITEM_PROPERTY_DAMAGE_PERCENT, 15                  ; увеличение урона существ в процентах
                ITEM_PROPERTY ITEM_PROPERTY_ARMOR_PERCENT, 10                   ; увеличение защиты существ в процентах
                ITEM_PROPERTY ITEM_PROPERTY_TOHIT, 3                            ; рейтинг атаки существ
                ITEM_END AMULET_05

                endmodule

                endif ; ~_METADATA_ITEMS_AMULET_

