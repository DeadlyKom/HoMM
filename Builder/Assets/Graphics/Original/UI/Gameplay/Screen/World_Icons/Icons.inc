
                ifndef _GRAPHICS_UI_GAMEPLAY_WORLD_PACK_WORLD_ICONS_
                define _GRAPHICS_UI_GAMEPLAY_WORLD_PACK_WORLD_ICONS_

                module Icons
Index:          ; вычисление индексов записей в таблице спрайтов
.Diamond        EQU (SpriteInfo.Diamond        - SpriteInfo) / FSprite
.Center         EQU (SpriteInfo.Center         - SpriteInfo) / FSprite
.Character      EQU (SpriteInfo.Character      - SpriteInfo) / FSprite
.SpellsBook     EQU (SpriteInfo.SpellsBook     - SpriteInfo) / FSprite
.Inventory      EQU (SpriteInfo.Inventory      - SpriteInfo) / FSprite
.Quest          EQU (SpriteInfo.Quest          - SpriteInfo) / FSprite
.Map            EQU (SpriteInfo.Map            - SpriteInfo) / FSprite
.Options        EQU (SpriteInfo.Options        - SpriteInfo) / FSprite
.TopLeftSlot    EQU (SpriteInfo.TopLeftSlot    - SpriteInfo) / FSprite
.TopRightSlot   EQU (SpriteInfo.TopRightSlot   - SpriteInfo) / FSprite
.BottomLeftSlot EQU (SpriteInfo.BottomLeftSlot - SpriteInfo) / FSprite
.BottomRSlot    EQU (SpriteInfo.BottomRSlot    - SpriteInfo) / FSprite
.Cloud          EQU (SpriteInfo.Cloud          - SpriteInfo) / FSprite
.Freeze         EQU (SpriteInfo.Freeze         - SpriteInfo) / FSprite
.Rain           EQU (SpriteInfo.Rain           - SpriteInfo) / FSprite
.Thunder        EQU (SpriteInfo.Thunder        - SpriteInfo) / FSprite
.Tornado        EQU (SpriteInfo.Tornado        - SpriteInfo) / FSprite
.Wind           EQU (SpriteInfo.Wind           - SpriteInfo) / FSprite

SpriteInfo:     ; основные иконки
.Diamond        SPRITE 23, 23,  0,  0, OR_XOR,  0, Sprite.Diamond               ; ромб под основные иконки
.Center         SPRITE 17, 16,  0,  0, OR_XOR,  0, Sprite.Center                ; иконка "центрирование"
.Character      SPRITE 13, 20,  0,  0, OR_XOR,  0, Sprite.Character             ; иконка "персонаж"
.SpellsBook     SPRITE 22, 21,  0,  0, OR_XOR,  0, Sprite.SpellsBook            ; иконка "книга заклинаний"
.Inventory      SPRITE 17, 21,  0,  0, OR_XOR,  0, Sprite.Inventory             ; иконка "инвентарь"
.Quest          SPRITE 19, 20,  0,  0, OR_XOR,  0, Sprite.Quest                 ; иконка "задания"
.Map            SPRITE 18, 20,  0,  0, OR_XOR,  0, Sprite.Map                   ; иконка "карта"
.Options        SPRITE 22, 23,  0,  0, OR_XOR,  0, Sprite.Options               ; иконка "настройки"

                ; вспомогательные иконки
.TopLeftSlot    SPRITE 13, 13,  0,  0, OR_XOR,  0, Sprite.TopLeftSlot           ; ромб под вспомогательные иконки "верхний левый"
.TopRightSlot   SPRITE 13, 13,  0,  0, OR_XOR,  0, Sprite.TopRightSlot          ; ромб под вспомогательные иконки "верхний правый"
.BottomLeftSlot SPRITE 13, 13,  0,  0, OR_XOR,  0, Sprite.BottomLeftSlot        ; ромб под вспомогательные иконки "нижний левый"
.BottomRSlot    SPRITE 13, 13,  0,  0, OR_XOR,  0, Sprite.BottomRightSlot       ; ромб под вспомогательные иконки "нижний правый"
.Cloud          SPRITE 14,  9,  0,  0, OR_XOR,  0, Sprite.Cloud                 ; иконка "облако"
.Freeze         SPRITE 11, 11,  0,  0, OR_XOR,  0, Sprite.Freeze                ; иконка "замораживания"
.Rain           SPRITE 12, 10,  0,  0, OR_XOR,  0, Sprite.Rain                  ; иконка "дождь"
.Thunder        SPRITE  9, 13,  0,  0, OR_XOR,  0, Sprite.Thunder               ; иконка "гроза"
.Tornado        SPRITE 13, 13,  0,  0, OR_XOR,  0, Sprite.Tornado               ; иконка "торнадо"
.Wind           SPRITE 16, 12,  0,  0, OR_XOR,  0, Sprite.Wind                  ; иконка "ветер"

Sprite:
.Diamond        incbin "small_diamond.bin"
.TopLeftSlot    incbin "top_left_diamond_slot.bin"
.TopRightSlot   incbin "top_right_diamond_slot.bin"
.BottomLeftSlot incbin "bottom_left_diamond_slot.bin"
.BottomRightSlot incbin "bottom_right_diamond_slot.bin"
.Center         incbin "center.bin"
.Character      incbin "character.bin"
.SpellsBook     incbin "spells_book.bin"
.Inventory      incbin "inventory.bin"
.Quest          incbin "quests.bin"
.Map            incbin "map.bin"
.Options        incbin "options.bin"
.Cloud          incbin "symbol_cloud.bin"
.Freeze         incbin "symbol_freeze.bin"
.Rain           incbin "symbol_rain.bin"
.Thunder        incbin "symbol_thunder.bin"
.Tornado        incbin "symbol_tornado.bin"
.Wind           incbin "symbol_wind.bin"

                endmodule

                endif ; ~ _GRAPHICS_UI_GAMEPLAY_WORLD_PACK_WORLD_ICONS_
