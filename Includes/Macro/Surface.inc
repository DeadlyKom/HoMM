
                ifndef _MACRO_SURFACE_
                define _MACRO_SURFACE_
SURFACE_PASSABILITY macro Type?, StepCost?
                assert MOVEMENT_DEFAULT_STEP_COST * StepCost? <= SURFACE_STEP_COST_MASK
                DB (Type? & SURFACE_TYPE_MASK) | ((MOVEMENT_DEFAULT_STEP_COST * StepCost?) & SURFACE_STEP_COST_MASK)
                endm
SURFACE_PROPERTY macro ReconMod?
                DB (ReconMod? & SURFACE_RECON_MOD_MASK)
                endm

                endif ; ~_MACRO_SURFACE_
