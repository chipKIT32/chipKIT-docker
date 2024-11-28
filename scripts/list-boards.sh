#!/bin/bash
set -e

# Ensure we're in the project root
cd "$(dirname "$0")/.."

echo "Listing all available chipKIT boards:"
docker compose run --rm arduino-cli board listall chipKIT

echo -e "\nCommon chipKIT boards and their FQBN (Fully Qualified Board Name):"
echo "- FubarinoSD:       chipKIT:pic32:fubarino_sd"
echo "- DP32:             chipKIT:pic32:dp32"
echo "- uC32:             chipKIT:pic32:uC32"
echo "- WF32:             chipKIT:pic32:WF32"
echo "- WiFire:           chipKIT:pic32:wifire"
echo "- Max32:            chipKIT:pic32:max32"
echo "- Uno32:            chipKIT:pic32:uno_pic32"

echo -e "\nExample usage:"
echo './scripts/build-sketch.sh -b "chipKIT:pic32:fubarino_sd" path/to/sketch.ino'
echo 'or'
echo 'BOARD="chipKIT:pic32:fubarino_sd" ./scripts/build-sketch.sh path/to/sketch.ino'
