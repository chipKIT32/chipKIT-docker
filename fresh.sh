#!/bin/bash
set -e

./scripts/thorough-clean.sh
docker compose build --no-cache
./scripts/build-core.sh
./scripts/fix-platform.sh


