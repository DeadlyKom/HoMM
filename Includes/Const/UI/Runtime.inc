
                ifndef _CONST_UI_RUNTIME_
                define _CONST_UI_RUNTIME_
UI_MODE_NONE            EQU #00                                                 ; режим отсутствует

UI_MODE_CHARACTERISTICS EQU #01                                                 ; режим характеристик
UI_MODE_INVENTORY       EQU #02                                                 ; режим инвентаря
UI_MODE_SPELLBOOK       EQU #03                                                 ; режим книги заклинания
UI_MODE_MAP             EQU #04                                                 ; режим глобальная карта
UI_MODE_QUEST_LOG       EQU #05                                                 ; режим журнал заданий
UI_MODE_SETTINGS        EQU #06                                                 ; режим настройки

UI_MODE_WORLD           EQU #07                                                 ; режим "мир"
UI_MODE_BATTLE          EQU #08                                                 ; режим "бой"

UI_MODE_MAX             EQU #09                                                 ; максимально доступный режим


; флаги
UI_REQUEST_PENDING_BIT      EQU 0x00                                            ; флаг, запрос на смену UI режима
UI_TRANSITION_ACTIVE_BIT    EQU 0x01                                            ; флаг, активной фазы смены UI режима
UI_GAME_PAUSE_BIT           EQU 0x07                                            ; флаг, паузы игры
                endif ; ~_CONST_UI_RUNTIME_
