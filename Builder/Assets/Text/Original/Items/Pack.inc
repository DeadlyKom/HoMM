
                ifndef _TEXT_ITEMS_PACK_
                define _TEXT_ITEMS_PACK_
; -----------------------------------------
; регистрация индекса списка, смещения и подключаемого файла
; In:
;   Label? - метка индекса списка текстов
;   File?  - имя подключаемого файла
; -----------------------------------------
REG_ITEM_TEXT_ID macro Label?, File?
                assert ITEM_TEXT_ID_COUNTER < 256, "too many item text lists"
Label?          EQU ITEM_TEXT_ID_COUNTER
ITEM_TEXT_ID_COUNTER = ITEM_TEXT_ID_COUNTER + 1
                OFFSET Label? _ .Text

                define __ITEM_TEXT_LABEL__ Label?
                define __ITEM_TEXT_FILE__ File?

                lua allpass
                    table.insert(ItemTextLists, {
                        label = sj.get_define("__ITEM_TEXT_LABEL__"),
                        file = sj.get_define("__ITEM_TEXT_FILE__")
                    })
                endlua

                undefine __ITEM_TEXT_LABEL__
                undefine __ITEM_TEXT_FILE__
                endm

                ; -----------------------------------------
                ; регистрация списков и формирование таблицы смещений
                lua allpass
                    ItemTextLists = {}
                endlua

ITEM_TEXT_ID_COUNTER defl 0
                REG_ITEM_TEXT_ID Axe, "Axe.inc"
                REG_ITEM_TEXT_ID Ring, "Ring.inc"
                REG_ITEM_TEXT_ID Belt, "Belt.inc"
                REG_ITEM_TEXT_ID Boot, "Boot.inc"
                REG_ITEM_TEXT_ID Cloak, "Cloak.inc"
                REG_ITEM_TEXT_ID Mask, "Mask.inc"
                REG_ITEM_TEXT_ID Sword, "Sword.inc"
                REG_ITEM_TEXT_ID Amulet, "Amulet.inc"
                REG_ITEM_TEXT_ID Breast, "Breast.inc"
                REG_ITEM_TEXT_ID Helmet, "Helmet.inc"
                REG_ITEM_TEXT_ID Shield, "Shield.inc"
                REG_ITEM_TEXT_ID ShoulderPad, "ShoulderPad.inc"
                REG_ITEM_TEXT_ID Property, "Property.inc"
                REG_ITEM_TEXT_ID Description, "Description.inc"
Num             EQU ITEM_TEXT_ID_COUNTER
                ; -----------------------------------------

                ; -----------------------------------------
                ; формирование данных зарегистрированных списков
                lua allpass
                    for index, item in ipairs(ItemTextLists) do
                        _pl("ITEM_TEXT_LIST_ID defl " .. (index - 1))
                        _pl("ITEM_NAME_ID_COUNTER defl 0")
                        _pl(item.label .. ".Text EQU $")
                        _pc("include " .. item.file)
                    end
                    ItemTextLists = nil
                endlua
                ; -----------------------------------------

                endif ; ~_TEXT_ITEMS_PACK_
