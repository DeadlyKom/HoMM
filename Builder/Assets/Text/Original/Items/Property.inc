
                ifndef _TEXT_ITEMS_PROPERTY_
                define _TEXT_ITEMS_PROPERTY_
; -----------------------------------------
; регистрация текста свойства по его идентификатору
; In:
;   Type? - тип свойства ITEM_PROPERTY_
;   Text? - текст описания свойства
; -----------------------------------------
REG_ITEM_PROPERTY_TEXT macro Type?, Text?
                define __ITEM_PROPERTY_TYPE__ Type?
                define __ITEM_PROPERTY_TEXT__ Text?

                lua allpass
                    local id = sj.get_label(sj.get_define("__ITEM_PROPERTY_TYPE__"))
                    local text = sj.get_define("__ITEM_PROPERTY_TEXT__")

                    if text:sub(1, 1) == '"' and text:sub(-1) == '"' then
                        text = text:sub(2, -2)
                    end

                    assert(ItemPropertyTexts[id] == nil, "Повтор текста свойства " .. id)
                    local length = 0
                    for index = 1, #text do
                        local byte = text:byte(index)
                        if byte < 0x80 or byte >= 0xC0 then
                            length = length + 1
                        end
                    end

                    ItemPropertyTextMax = math.max(ItemPropertyTextMax, length)
                    ItemPropertyTexts[id] = text
                endlua

                undefine __ITEM_PROPERTY_TYPE__
                undefine __ITEM_PROPERTY_TEXT__
                endm

                ; -----------------------------------------
                ; регистрация описаний свойств
                lua allpass
                    ItemPropertyTexts = {}
                    ItemPropertyTextMax = 0
                endlua

                REG_ITEM_PROPERTY_TEXT ITEM_PROPERTY_ATTACK, " к атаке"
                REG_ITEM_PROPERTY_TEXT ITEM_PROPERTY_DEFESE, " к защите"
                REG_ITEM_PROPERTY_TEXT ITEM_PROPERTY_POWER, " к силе заклинаний"
                REG_ITEM_PROPERTY_TEXT ITEM_PROPERTY_KNOWLEDGE, " к знаниям"
                REG_ITEM_PROPERTY_TEXT ITEM_PROPERTY_PATHFINDING, " к поиску пути"
                REG_ITEM_PROPERTY_TEXT ITEM_PROPERTY_MAXMANA, " к максимальной мане"
                REG_ITEM_PROPERTY_TEXT ITEM_PROPERTY_GOLDBONUS, " к золоту за победу"
                REG_ITEM_PROPERTY_TEXT ITEM_PROPERTY_ADDCLASSSKILLS, " к умениям класса"
                REG_ITEM_PROPERTY_TEXT ITEM_PROPERTY_SINGLESKILL, " к отдельному умению"
                REG_ITEM_PROPERTY_TEXT ITEM_PROPERTY_ALLSKILLS, " ко всем умениям"
                REG_ITEM_PROPERTY_TEXT ITEM_PROPERTY_CHARGED_SKILL, " зарядов умения"
                REG_ITEM_PROPERTY_TEXT ITEM_PROPERTY_MAXHP, " к здоровью существ"
                REG_ITEM_PROPERTY_TEXT ITEM_PROPERTY_TOHIT, " к рейтингу атаки существ"
                REG_ITEM_PROPERTY_TEXT ITEM_PROPERTY_ARMOR_PERCENT, "% к защите существ"
                REG_ITEM_PROPERTY_TEXT ITEM_PROPERTY_DAMAGE_PERCENT, "% к урону существ"
                REG_ITEM_PROPERTY_TEXT ITEM_PROPERTY_MAXDAMAGE_PERCENT, "% к максимальному урону существ"
                REG_ITEM_PROPERTY_TEXT ITEM_PROPERTY_MINDAMAGE, " к минимальному урону существ"
                REG_ITEM_PROPERTY_TEXT ITEM_PROPERTY_MAXDAMAGE, " к максимальному урону существ"
                REG_ITEM_PROPERTY_TEXT ITEM_PROPERTY_DAMAGERESIST, "% снижения физического урона"
                REG_ITEM_PROPERTY_TEXT ITEM_PROPERTY_MAGICRESIST, "% сопротивления магии"
                REG_ITEM_PROPERTY_TEXT ITEM_PROPERTY_FIRERESIST, "% сопротивления огню"
                REG_ITEM_PROPERTY_TEXT ITEM_PROPERTY_LIGHTRESIST, "% сопротивления молнии"
                REG_ITEM_PROPERTY_TEXT ITEM_PROPERTY_COLDRESIST, "% сопротивления холоду"
                REG_ITEM_PROPERTY_TEXT ITEM_PROPERTY_POISONRESIST, "% сопротивления яду"
                REG_ITEM_PROPERTY_TEXT ITEM_PROPERTY_FIREMINDAM, " к минимальному урону огнём"
                REG_ITEM_PROPERTY_TEXT ITEM_PROPERTY_FIREMAXDAM, " к максимальному урону огнём"
                REG_ITEM_PROPERTY_TEXT ITEM_PROPERTY_COLDMINDAM, " к минимальному урону холодом"
                REG_ITEM_PROPERTY_TEXT ITEM_PROPERTY_COLDMAXDAM, " к максимальному урону холодом"
                REG_ITEM_PROPERTY_TEXT ITEM_PROPERTY_FASTERATTACKRATE, "% к скорости атаки"
                REG_ITEM_PROPERTY_TEXT ITEM_PROPERTY_FASTERMOVEVELOCITY, "% к скорости передвижения"
                REG_ITEM_PROPERTY_TEXT ITEM_PROPERTY_OPENWOUNDS, "% шанса открытых ран"
                REG_ITEM_PROPERTY_TEXT ITEM_PROPERTY_CRUSHINGBLOW, "% шанса сокрушительного удара"
                REG_ITEM_PROPERTY_TEXT ITEM_PROPERTY_DEADLYSTRIKE, "% шанса смертельного удара"
                REG_ITEM_PROPERTY_TEXT ITEM_PROPERTY_SKILLONATTACK, " применение умения при атаке"
                REG_ITEM_PROPERTY_TEXT ITEM_PROPERTY_SKILLONHIT, " применение умения при попадании"
                REG_ITEM_PROPERTY_TEXT ITEM_PROPERTY_SKILLONGETHIT, " применение умения при получении удара"
                ; -----------------------------------------

                ; -----------------------------------------
                ; формирование массива строк в порядке идентификаторов свойств
                lua allpass
                    for id = 0, sj.get_label("ITEM_PROPERTY_ID_COUNTER") - 1 do
                        assert(ItemPropertyTexts[id], "Не задан текст свойства " .. id)
                        Convert(ItemPropertyTexts[id])
                    end

                    _pl("Property.MaxLength EQU " .. ItemPropertyTextMax)
                    ItemPropertyTexts = nil
                    ItemPropertyTextMax = nil
                endlua
                ; -----------------------------------------

                endif ; ~_TEXT_ITEMS_PROPERTY_

