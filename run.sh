#!/bin/bash
set -e
#set -x
set -o allexport

pushd `dirname $0` > /dev/null;DIR=`pwd -P`;popd > /dev/null
[[ -f "${DIR}/.env" ]] && source "${DIR}/.env"

ANSIBLE_HOST_KEY_CHECKING=False python3 ansible-playbook -i environments/default playbook.yml "$@"
