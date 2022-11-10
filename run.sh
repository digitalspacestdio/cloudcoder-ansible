#!/bin/bash
set -e
set -x
set -o allexport

pushd `dirname $0` > /dev/null;DIR=`pwd -P`;popd > /dev/null
[[ -f "${DIR}/.env" ]] && source "${DIR}/.env"

if [[ ! -z $ANSIBLE_HOST ]]; then
    ANSIBLE_USER=${ANSIBLE_USER:-root}
    if [[ $ANSIBLE_HOST != "localhost" ]] || [[ $ANSIBLE_HOST != "127.0.0.1" ]]; then
        ANSIBLE_HOST=${ANSIBLE_HOST}
        ANSIBLE_CONNECTION=ssh
    else
        ANSIBLE_HOST=localhost
        ANSIBLE_CONNECTION=local
    fi
    envsubst > environments/default/hosts <<CONFIG
[server]
${ANSIBLE_HOST} ansible_connection=${ANSIBLE_CONNECTION} ansible_user=${ANSIBLE_USER}
CONFIG
fi

pip3 install -r ${DIR}/requirements.txt
ANSIBLE_HOST_KEY_CHECKING=False python3 ${DIR}/ansible-playbook -i ${DIR}/environments/default ${DIR}/playbook.yml "$@"
