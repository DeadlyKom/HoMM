
                ifndef _METADATA_MAP_DEBUG_OBJECTS_
                define _METADATA_MAP_DEBUG_OBJECTS_
MAKE_MAP_OBJECT macro Label?, X?, Y?, SpriteIndex?
                FMapObject {
                    (Label? << 1),
                    (X?),
                    (Y?),
                    (SpriteIndex?)
                }
                endm

                DB ASSETS_ID_DEFAULT_SETTINGS                                   ; идентификатор ассета дефолтных настроек объектов
                DB Objects.Num

                MAKE_MAP_OBJECT                                                   \
                /*тип объекта*/                     ODS_ID_TORCH,                 \
                /*позиция объекта на карте*/        3, 2,                         \
                /*ID спрайта в ассете настроек*/    SPRITE_ID_TORCH

                MAKE_MAP_OBJECT                                                   \
                /*тип объекта*/                     ODS_ID_TORCH,                 \
                /*позиция объекта на карте*/        4, 3,                         \
                /*ID спрайта в ассете настроек*/    SPRITE_ID_TORCH

                MAKE_MAP_OBJECT                                                   \
                /*тип объекта*/                     ODS_ID_TORCH,                 \
                /*позиция объекта на карте*/        6, 5,                         \
                /*ID спрайта в ассете настроек*/    SPRITE_ID_TORCH

                MAKE_MAP_OBJECT                                                   \
                /*тип объекта*/                     ODS_ID_TORCH,                 \
                /*позиция объекта на карте*/        8, 7,                         \
                /*ID спрайта в ассете настроек*/    SPRITE_ID_TORCH

Objects.Num     EQU ($-Objects) / FMapObject

                endif ; ~ _METADATA_MAP_DEBUG_OBJECTS_
