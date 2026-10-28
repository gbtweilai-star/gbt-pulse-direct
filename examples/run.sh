#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
PYTHONPATH=src python -m gbt_pulse_direct info
PYTHONPATH=src python -m gbt_pulse_direct check --payload '{}'
PYTHONPATH=src python -m gbt_pulse_direct run   --payload '{}'
