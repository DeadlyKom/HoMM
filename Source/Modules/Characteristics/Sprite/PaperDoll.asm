
                ifndef _MODULE_CHARACTERISTICS_SPRITE_PAPER_DOLL_
                define _MODULE_CHARACTERISTICS_SPRITE_PAPER_DOLL_

                module PaperDoll
; -----------------------------------------
; загрузка и инициализация спрайтов "образа персонажа"
; In:
; Out:
; Corrupt:
; Note:
; -----------------------------------------
Load:           ; определение гендера выбранного персонажа
                SET_PAGE_OBJECT                                                 ; включить страницу работы с объектами
                LD A, (GameState.PlayerActions + FPlayerActions.SelectedHeroID)
                ; -----------------------------------------
                ; получить адреса персонажа
                ; In:
                ;   A  - индекс персонажа
                ; Out:
                ;   IX - адрес персонажа            (FCharacter)
                ;   IY - адрес объекта персонажа    (FObjectCharacter)
                ; Corrupt:
                ;   HL, AF, IX, IY
                ; Note:
                ;   ℹ️ код расположен в странице 0
                ; -----------------------------------------
                CALL Character.Utilities.GetAdr

                ; выборка идентификатора ресурса по гендеру персонажа
                LD A, ASSETS_ID_UI_PAPER_DOLL_MALE_PACK
                BIT CHARACTER_GENDER_BIT, (IX + FCharacter.Class)
                JR Z, $+4                                                       ; переход, если муржской гендер
                LD A, ASSETS_ID_UI_PAPER_DOLL_FEMALE_PACK

                EX AF, AF'                                                      ; сохранение идентификатора ресурса
                SET_PAGE_ASSETS                                                 ; включить страницу расположения менеджера ресурсов
                EX AF, AF'                                                      ; восстановление идентификатора ресурса
                LOAD_ASSETS_A                                                   ; загрузка ресурса спрайтов
                
                SET_MODULE_PAGE_Characteristics                                 ; включить страницу модуля "характеристик"

                ; сохранение страницы и адреса спрайтов "образа персонажа"
                SAVE_ASSETS_PAGE Characteristics.Display.PaperDoll.Page         ; сохранение страницы загруженного ресурса
                SAVE_ASSETS_ADDRESS Characteristics.Display.PaperDoll.Address   ; сохранение адреса загруженного ресурса
                RET

                display " - Sprite initialize 'Paper doll':\t\t\t", /A, Load, "\t= busy [ ", /D, $-Load, " byte(s)  ]"
                endmodule

                endif ; ~ _MODULE_CHARACTERISTICS_SPRITE_PAPER_DOLL_
