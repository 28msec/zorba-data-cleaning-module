# Copyright 2006-2010 The FLWOR Foundation.
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
# http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

MESSAGE(STATUS "")
MESSAGE(STATUS "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++")
MESSAGE(STATUS "Configuring external module <data-cleaning>")
MESSAGE(STATUS "-------------------------------------------------------------")
MESSAGE(STATUS "")

CMAKE_MINIMUM_REQUIRED(VERSION 2.6)

PROJECT (zorba_data-cleaning_module)
ENABLE_TESTING ()
INCLUDE (CTest)

LIST (APPEND CMAKE_MODULE_PATH "${PROJECT_SOURCE_DIR}/cmake_modules")

FIND_PACKAGE (Zorba REQUIRED HINTS "${ZORBA_BUILD_DIR}")
INCLUDE ("${Zorba_USE_FILE}")

ADD_TEST_DIRECTORY("${PROJECT_SOURCE_DIR}/test")

EXPECTED_FAILURE (zorba_data-cleaning_module/data-cleaning/conversion/address-from-geocode.xq 1194053)
EXPECTED_FAILURE (zorba_data-cleaning_module/data-cleaning/conversion/geocode-from-address.xq 1194053)
EXPECTED_FAILURE (zorba_data-cleaning_module/data-cleaning/normalization/normalize-address.xq 1194053)

ADD_SUBDIRECTORY("src")

DONE_DECLARING_ZORBA_URIS()

MESSAGE(STATUS "")
MESSAGE(STATUS "-------------------------------------------------------------")
MESSAGE(STATUS "Configuration SUCCEEDED for external module <data-cleaning>")
MESSAGE(STATUS "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++")

