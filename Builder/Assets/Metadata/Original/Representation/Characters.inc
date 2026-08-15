
                ifndef _METADATA_REPRESENTATION_CHARACTERS_
                define _METADATA_REPRESENTATION_CHARACTERS_

MAKE_REPRESENT  macro Label?, Name?, HeroID?, AppearanceID?
@Label?         EQU ($ - Characters) >> 4

.Name           define __REPRESENT_NAME__ Name?
                lua allpass
                    local name = sj.get_define("__REPRESENT_NAME__")
                    if name:sub(1, 1) == '"' and name:sub(-1) == '"' then
                        name = name:sub(2, -2)
                    end
                    Convert (name)
                endlua
                undefine __REPRESENT_NAME__
                DS 14 - ($ - .Name), ' '

                DB HeroID?
                DB AppearanceID?
                endm

Characters:
                MAKE_REPRESENT                                                 \
                /*RepresentID*/     REPRESENT_ID_DRUID,                        \
                /*Name*/            "Дрꙋидъ",                                  \
                /*HeroID*/          Character.Name.Druid,                      \
                /*AppearanceID*/    Character.Appearance.Druid

                MAKE_REPRESENT                                                 \
                /*RepresentID*/     REPRESENT_ID_WIZARD,                       \
                /*Name*/            "Волхвъ",                                  \
                /*HeroID*/          Character.Name.Wizard,                     \
                /*AppearanceID*/    Character.Appearance.Wizard

                endif ; ~ _METADATA_REPRESENTATION_CHARACTERS_
