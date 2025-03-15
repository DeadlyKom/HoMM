
                ifndef _CONST_INPUT_INCLUDE_
                define _CONST_INPUT_INCLUDE_

                ifdef ENABLE_MOUSE
                include "Source/Input/Mouse/VirtualKeys.inc"
                endif
                include "Source/Input/Keyboard/VirtualKeys.inc"
                include "Source/Input/Kempston/VirtualKeys.inc"

                include "KeyID.inc"
                include "InputEnter.inc"
                include "InputMovement.inc"

                endif ; ~_CONST_INPUT_INCLUDE_
