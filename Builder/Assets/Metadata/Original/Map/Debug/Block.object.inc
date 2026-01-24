
                ifndef _METADATA_MAP_DEBUG_OBJECTS_
                define _METADATA_MAP_DEBUG_OBJECTS_
MAKE_MAP_OBJECT macro Label?, X?, x?, Y?, y?, SpriteIndex?
                FMapObject {
                    (Label? << 1),
                    ((X?) << 1) + (x?),
                    ((Y?) << 1) + (y?),
                    (SpriteIndex?)
                }
                endm

                MAKE_MAP_OBJECT                                                 \
                /*тип объекта*/                     ODS_ID_TEST,                \
                /*позиция объекта на карте*/        5,0,    5,1,                \
                /*ID спрайта в Graphic pack #01*/   SPRITE_ID_TELEPORT

                ; MAKE_MAP_OBJECT                                                 \
                ; /*тип объекта*/                     ODS_ID_TEST,                \
                ; /*позиция объекта на карте*/        23,0,   24,1,               \
                ; /*ID спрайта в Graphic pack #01*/   SPRITE_ID_NECROPOLIS

                ; MAKE_MAP_OBJECT                                                 \
                ; /*тип объекта*/                     ODS_ID_TEST,                \
                ; /*позиция объекта на карте*/        21,0,   27,1,               \
                ; /*ID спрайта в Graphic pack #01*/   SPRITE_ID_TELEPORT

                endif ; ~ _METADATA_MAP_DEBUG_OBJECTS_
