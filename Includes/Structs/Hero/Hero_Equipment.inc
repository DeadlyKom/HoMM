
                ifndef _STRUCTS_HERO_EQUIPMENT_
                define _STRUCTS_HERO_EQUIPMENT_

                struct FHeroEquipment                                           ; экипировка персонажа                                          [байт]
Head            FItemID                                                         ; идентификатор предмета - голова
Breast          FItemID                                                         ; идентификатор предмета - грудь
Amulet          FItemID                                                         ; идентификатор предмета - амулет
ShoulderPad     FItemID                                                         ; идентификатор предмета - наплечник/плащ
Belt            FItemID                                                         ; идентификатор предмета - пояс
LeftHand        FItemID                                                         ; идентификатор предмета - левая рука
RightHand       FItemID                                                         ; идентификатор предмета - правая рука
LeftRing        FItemID                                                         ; идентификатор предмета - кольцо левой руки
RightRing       FItemID                                                         ; идентификатор предмета - кольцо правой руки
Boot            FItemID                                                         ; идентификатор предмета - обувь

                ends

                endif ; ~_STRUCTS_HERO_EQUIPMENT_
