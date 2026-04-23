
                ifndef _OBJECT_UTILITIES_INCREMENT_CADENCE_PASS_IDS_
                define _OBJECT_UTILITIES_INCREMENT_CADENCE_PASS_IDS_
; -----------------------------------------
; увеличение CadencePass'ы ID
; In:
; Out:
; Corrupt:
; Note:
; -----------------------------------------
IncCadencePassIDs:
                LD HL, TickScheduler + FTickScheduler.Range_0 + FCadenceRange.CadencePassId
                INC (HL)
                LD HL, TickScheduler + FTickScheduler.Range_1 + FCadenceRange.CadencePassId
                INC (HL)
                LD HL, TickScheduler + FTickScheduler.Range_2 + FCadenceRange.CadencePassId
                INC (HL)
                RET

                endif ; ~ _OBJECT_UTILITIES_INCREMENT_CADENCE_PASS_IDS_
