
                ifndef _MACRO_ITEM_
                define _MACRO_ITEM_
; -----------------------------------------
; регистрация идентификатора метки
; In:
;   Label?  - идентификатор метка визуализации предмета
; -----------------------------------------
REG_ITEM_VISUAL_ID  macro Label?
Label?              EQU ITEM_VISUAL_ID_COUNTER
ITEM_VISUAL_ID_COUNTER = ITEM_VISUAL_ID_COUNTER + 1
                    endm
; -----------------------------------------
; формирование структуры описания спрайта предмета
; In:
;   Width?  - ширина в ячейках
;   Height? - высота в ячейках
;   Offset? - смещение до данных спрайта
;   Label?  - идентификатор метка визуализации предмета
; -----------------------------------------
ITEM_VISUAL     macro Width?, Height?, Offset?, Label?
                REG_ITEM_VISUAL_ID Label?
                FItemVisual {
                    {
                        (Width?) << 1,
                        (Height?) << 1
                    },
                    Offset?
                }
                endm
; -----------------------------------------
; формирование базового описания предмета без диапазона выборки
; In:
;   Label?    - метка предмета и его массива свойств
;   NameID?   - индекс текста названия
;   VisualID? - индекс визуала предмета
;   Type?     - тип предмета ITEM_TYPE_
;   Flags?    - флаги базового предмета ITEM_FLAG_
; -----------------------------------------
ITEM_BASE       macro Label?, NameID?, VisualID?, Type?, Flags?
Label?          FBaseItem {
                    NameID?,
                    VisualID?,
                    Type?,
                    Flags?,
                    {0, 0},
                    {0, 0},
                    Label? _ .PropNum
                }
Label? _ .Props EQU $
                endm
; -----------------------------------------
; формирование базового описания предмета с диапазоном выборки
; In:
;   Label?    - метка предмета и его массива свойств
;   NameID?   - индекс текста названия
;   VisualID? - индекс визуала предмета
;   Type?     - тип предмета ITEM_TYPE_
;   Flags?    - флаги базового предмета ITEM_FLAG_
;   Min?      - минимальная величина выборки
;   Max?      - максимальная величина выборки
; -----------------------------------------
ITEM_BASE_MIN_MAX macro Label?, NameID?, VisualID?, Type?, Flags?, Min?, Max?
Label?          FBaseItem {
                    NameID?,
                    VisualID?,
                    Type?,
                    Flags?,
                    {(Min?) & #FF, ((Min?) >> 8) & #FF},
                    {(Max?) & #FF, ((Max?) >> 8) & #FF},
                    Label? _ .PropNum
                }
Label? _ .Props EQU $
                endm
; -----------------------------------------
; формирование свойства предмета
; In:
;   Type?  - тип свойства ITEM_PROPERTY_
;   Value? - фактическая величина свойства
; -----------------------------------------
ITEM_PROPERTY   macro Type?, Value?
                FItemProperty {
                    Type?,
                    {(Value?) & #FF, ((Value?) >> 8) & #FF},
                    0
                }
                endm
; -----------------------------------------
; расчёт количества свойств завершённого описания предмета
; In:
;   Label? - метка предмета из ITEM_BASE или ITEM_BASE_MIN_MAX
; -----------------------------------------
ITEM_END        macro Label?
Label? _ .PropNum EQU ($ - Label? _ .Props) / FItemProperty
                endm

; -----------------------------------------
; формирование текста названия предмета
; In:
;   Label? - метка индекса названия
;   Text?  - текст названия
; -----------------------------------------
ITEM_NAME       macro Label?, Text?
Label?          EQU ITEM_NAME_ID_COUNTER
ITEM_NAME_ID_COUNTER = ITEM_NAME_ID_COUNTER + 1
                define __ITEM_NAME_TEXT__ Text?
                lua allpass
                    local name = sj.get_define("__ITEM_NAME_TEXT__")
                    if name:sub(1, 1) == '"' and name:sub(-1) == '"' then
                        name = name:sub(2, -2)
                    end
                    Convert (name)
                endlua
                undefine __ITEM_NAME_TEXT__
                endm

                endif ; ~_MACRO_ITEM_
