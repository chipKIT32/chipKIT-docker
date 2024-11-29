# Listing all available chipKIT boards:

## Board Name                       FQBN

CUI32stem                        chipKIT:pic32:CUI32stem
DataStation Mini                 chipKIT:pic32:dsmini
Fubarino Mini                    chipKIT:pic32:fubarino_mini
Fubarino Mini 2.0                chipKIT:pic32:fubarino_mini_20
Fubarino SD                      chipKIT:pic32:fubarino_sd
HelvePic                         chipKIT:pic32:HelvePic
MikroElektronika Clicker 2       chipKIT:pic32:clicker2
MikroElektronika Flip N Click MZ chipKIT:pic32:flipnclickmz
OpenBCI 32                       chipKIT:pic32:openbci
OpenScope                        chipKIT:pic32:OpenScope
PIC32 Pinguino                   chipKIT:pic32:Olimex_Pinguino32
PONTECH NoFire                   chipKIT:pic32:pontech_NoFire
PONTECH Quick240                 chipKIT:pic32:quick240_usb_pic32
PONTECH UAV100                   chipKIT:pic32:usbono_pic32
Pic32 CUI32-Development Stick    chipKIT:pic32:cui32
Pic32 UBW32-MX460                chipKIT:pic32:ubw32_mx460
Pic32 UBW32-MX795                chipKIT:pic32:ubw32_mx795
Picadillo 35T                    chipKIT:pic32:picadillo_35t
Project Gamma                    chipKIT:pic32:gamma
RGB Station                      chipKIT:pic32:RGB_Station
chipKIT Cmod                     chipKIT:pic32:cmod
chipKIT DP32                     chipKIT:pic32:chipkit_DP32
chipKIT Lenny                    chipKIT:pic32:lenny
chipKIT MAX32                    chipKIT:pic32:mega_pic32
chipKIT MX3                      chipKIT:pic32:chipkit_mx3
chipKIT MZ Lite                  chipKIT:pic32:ck-mz-lite
chipKIT Pi                       chipKIT:pic32:chipkit_Pi
chipKIT Pro MX4                  chipKIT:pic32:chipkit_pro_mx4
chipKIT Pro MX7                  chipKIT:pic32:chipkit_pro_mx7
chipKIT Pro MZ                   chipKIT:pic32:ck-pro-mz
chipKIT UNO32                    chipKIT:pic32:uno_pic32
chipKIT WF32                     chipKIT:pic32:chipkit_WF32
chipKIT WiFire                   chipKIT:pic32:chipkit_WiFire
chipKIT uC32                     chipKIT:pic32:chipkit_uc32


Common chipKIT boards and their FQBN (Fully Qualified Board Name):
- FubarinoSD:       chipKIT:pic32:fubarino_sd
- DP32:             chipKIT:pic32:dp32
- uC32:             chipKIT:pic32:uC32
- WF32:             chipKIT:pic32:WF32
- WiFire:           chipKIT:pic32:wifire
- Max32:            chipKIT:pic32:max32
- Uno32:            chipKIT:pic32:uno_pic32

Example usage:
./scripts/build-sketch.sh -b "chipKIT:pic32:fubarino_sd" path/to/sketch.ino
or
BOARD="chipKIT:pic32:fubarino_sd" ./scripts/build-sketch.sh path/to/sketch.ino
