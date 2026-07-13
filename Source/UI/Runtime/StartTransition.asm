
                ifndef _UI_RUNTIME_START_TRANSITION_
                define _UI_RUNTIME_START_TRANSITION_
; -----------------------------------------
; начать перехода запроса смены UI режима
; In:
; Out:
; Corrupt:
; Note:
; -----------------------------------------
StartTransition:; чтение активируемого UI режима
                LD A, (GameState.UIRuntime + FUIRuntime.RequestedMode)
                LD HL, .JumpTable
                JP Func.JumpTable

.JumpTable      DW .NoMode                                                      ; UI_MODE_NONE
                DW UI.Runtime.Complete                                          ; UI_MODE_CHARACTERISTICS
                DW UI.Runtime.Complete                                          ; UI_MODE_INVENTORY
                DW UI.Runtime.Complete                                          ; UI_MODE_SPELLBOOK
                DW UI.Runtime.Complete                                          ; UI_MODE_MAP
                DW UI.Runtime.Complete                                          ; UI_MODE_QUEST_LOG
                DW UI.Runtime.Complete                                          ; UI_MODE_SETTINGS
                DW UI.Runtime.Resume                                            ; UI_MODE_WORLD
                DW UI.Runtime.Resume                                            ; UI_MODE_BATTLE

.NoMode         RET                                                             ; UI_MODE_NONE ни на что не влияет

                endif ; ~_UI_RUNTIME_START_TRANSITION_
