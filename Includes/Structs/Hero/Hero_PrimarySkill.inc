
                ifndef _STRUCTS_HERO_PRIMARY_SKILL_
                define _STRUCTS_HERO_PRIMARY_SKILL_

                struct FPrimarySkill                                            ; основные навыки героя                                         [байт]
Attack          DB #00                                                          ; навык атаки
Defese          DB #00                                                          ; навык защиты
Power           DB #00                                                          ; сила заклинаний
Knowledge       DB #00                                                          ; навык знаний

                ends

                endif ; ~_STRUCTS_HERO_PRIMARY_SKILL_
