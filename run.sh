#!/bin/bash
set -e
#set -x
set -o allexport

pushd `dirname $0` > /dev/null;DIR=`pwd -P`;popd > /dev/null
[[ -f "${DIR}/.env" ]] && source "${DIR}/.env"

if [[ ! -z $IP_ADDRESS ]]; then
    ANSIBLE_USER=${ANSIBLE_USER:-root}
    envsubst > environments/default/hosts <<CONFIG
[server]
    $IP_ADDRESS ansible_connection=ssh ansible_user=$ANSIBLE_USER
CONFIG
fi

pip3 install -r ${DIR}/requirements.txt
ANSIBLE_HOST_KEY_CHECKING=False python3 ansible-playbook -i environments/default playbook.yml "$@"
