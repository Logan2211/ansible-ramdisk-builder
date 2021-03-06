# Copyright 2018, Logan Vig <logan2211@gmail.com>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

export SCRIPT_PATH=$(dirname $(readlink -f "$0"))
export PROJECT_PATH=$(dirname "$SCRIPT_PATH")
export TESTS_PATH=${PROJECT_PATH}/tests
export ANSIBLE_VENV_PATH=${ANSIBLE_VENV_PATH:-"$PROJECT_PATH/runtime"}
export ANSIBLE_VENV_PYTHON=${ANSIBLE_VENV_PYTHON:-'python3'}
export ANSIBLE_PIP_PACKAGE=${ANSIBLE_VERSION:-'ansible'}
export FORKS=${FORKS:-$(grep -c ^processor /proc/cpuinfo)}
export ANSIBLE_PARAMETERS=${ANSIBLE_PARAMETERS:-""}

function bootstrap_system {
    sudo apt-get update
    install_deb_packages install python3-pip
    sudo pip3 install virtualenv
    virtualenv -p "${ANSIBLE_VENV_PYTHON}" "${ANSIBLE_VENV_PATH}"
    ${ANSIBLE_VENV_PATH}/bin/pip install -r${PROJECT_PATH}/test-requirements.txt ${ANSIBLE_PIP_PACKAGE}
}

function install_deb_packages {
  DEBIAN_FRONTEND=noninteractive \
    sudo apt-get --option "Dpkg::Options::=--force-confold" \
    --option "Dpkg::Options::=--force-confdef" --assume-yes "$@"
}

function run_ansible {
  ${ANSIBLE_VENV_PATH}/bin/ansible-playbook ${ANSIBLE_PARAMETERS} --forks ${FORKS} $@
}
