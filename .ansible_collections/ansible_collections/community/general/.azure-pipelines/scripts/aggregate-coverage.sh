#!/usr/bin/env bash
# Copyright (c) Ansible Project
# GNU General Public License v3.0+ (see LICENSES/GPL-3.0-or-later.txt or https://www.gnu.org/licenses/gpl-3.0.txt)
# SPDX-License-Identifier: GPL-3.0-or-later

# Aggregate code coverage results for later processing.

set -o pipefail -eu

agent_temp_directory="$1"

PATH="${PWD}/bin:${PATH}"

mkdir "${agent_temp_directory}/coverage/"

options=(--venv --venv-system-site-packages --color -v)

ansible-test coverage combine --group-by command --export "${agent_temp_directory}/coverage/" "${options[@]}"

if ansible-test coverage analyze targets generate --help >/dev/null 2>&1; then
    # Only analyze coverage if the installed version of ansible-test supports it.
    # Doing so allows this script to work unmodified for multiple Ansible versions.
    ansible-test coverage analyze targets generate "${agent_temp_directory}/coverage/coverage-analyze-targets.json" "${options[@]}"
fi
