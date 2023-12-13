#!/bin/bash
##############################################################################
#
#   Copyright (c) 2020 AT&T Intellectual Property.
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.
#
##############################################################################

# Installs libraries and builds E2 manager
# Prerequisites:
#   Debian distro; e.g., Ubuntu
#   NNG shared library
#   golang (go); tested with version 1.12
#   current working directory is E2Manager
#   running with sudo privs, which is default in Docker

# Stop at first error and be verbose
set -eux

echo "--> e2mgr-build-ubuntu.sh"

# export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib
# export LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib

export LD_LIBRARY_PATH="${LD_LIBRARY_PATH-}:/usr/local/lib"
export LIBRARY_PATH="${LIBRARY_PATH-}:/usr/local/lib"

# LD_LIBRARY_PATH=/usr/local/lib:
# export LD_LIBRARY_PATH
# LIBRARY_PATH=/usr/local/lib:
# export LIBRARY_PATH

# echo $LIBRARY_PATH
# echo $LD_LIBRARY_PATH


# required to find nng and rmr libs
# LD_LIBRARY_PATH=/usr/local/lib
# export LD_LIBRARY_PATH=/usr/local/lib

go-acc $(go list ./... | grep -vE '(/mocks|/tests|/e2managererrors|/enums)')

# # # TODO: drop rewrite of path prefix when SonarScanner is extended
# # # rewrite the module name to a directory name in the coverage report
# # # https://jira.sonarsource.com/browse/SONARSLANG-450
sed -i -e 's/^e2mgr/E2Manager/' coverage.txt  

# echo "--> e2mgr-build-ubuntu.sh ends"
