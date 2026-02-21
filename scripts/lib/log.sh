#!/usr/bin/env bash
#################################################################################################
# Author: Nicholas Fisher
# Date: February 21st 2026
# Description of Script
# Shared logging helpers for consistent installer output levels including info, warnings, errors, and fatal exits.
#################################################################################################

info() { printf '[INFO] %s\n' "$*"; }
warn() { printf '[WARN] %s\n' "$*"; }
ok() { printf '[ OK ] %s\n' "$*"; }
error() { printf '[ERR ] %s\n' "$*" >&2; }
die() { error "$*"; exit 1; }
