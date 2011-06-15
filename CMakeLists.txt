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

CMAKE_MINIMUM_REQUIRED(VERSION 2.6)

PROJECT (zorba_data-cleaning_module)
ENABLE_TESTING ()
INCLUDE (CTest)

LIST (APPEND CMAKE_MODULE_PATH "${PROJECT_SOURCE_DIR}/cmake_modules")

FIND_PACKAGE (Zorba REQUIRED HINTS "${ZORBA_BUILD_DIR}")
INCLUDE ("${Zorba_USE_FILE}")
ADD_TEST_DIRECTORY("${PROJECT_SOURCE_DIR}/test")

ADD_SUBDIRECTORY("src")

EXPECTED_FAILURE(zorba_data-cleaning_module/data-cleaning/consolidation/leastfrequent_1.xq 3316639)
EXPECTED_FAILURE(zorba_data-cleaning_module/data-cleaning/consolidation/lesssimilar-editdistance_1.xq 3316639)
EXPECTED_FAILURE(zorba_data-cleaning_module/data-cleaning/consolidation/lesstokens_1.xq 3316639)
EXPECTED_FAILURE(zorba_data-cleaning_module/data-cleaning/consolidation/longest_1.xq 3316639)
EXPECTED_FAILURE(zorba_data-cleaning_module/data-cleaning/consolidation/matching_1.xq 3316639)
EXPECTED_FAILURE(zorba_data-cleaning_module/data-cleaning/consolidation/moresimilar-editdistance_1.xq 3316639)
EXPECTED_FAILURE(zorba_data-cleaning_module/data-cleaning/consolidation/moretokens_1.xq 3316639)
EXPECTED_FAILURE(zorba_data-cleaning_module/data-cleaning/consolidation/mostfrequent_1.xq 3316639)
EXPECTED_FAILURE(zorba_data-cleaning_module/data-cleaning/consolidation/shortest_1.xq 3316639)
EXPECTED_FAILURE(zorba_data-cleaning_module/data-cleaning/consolidation/superstring_1.xq 3316639)
EXPECTED_FAILURE(zorba_data-cleaning_module/data-cleaning/string-similarity/cosine-ngrams_1.xq 3316639)
EXPECTED_FAILURE(zorba_data-cleaning_module/data-cleaning/string-similarity/cosine-tokens_1.xq 3316639)
EXPECTED_FAILURE(zorba_data-cleaning_module/data-cleaning/string-similarity/dice-ngrams_1.xq 3316639)
EXPECTED_FAILURE(zorba_data-cleaning_module/data-cleaning/string-similarity/dice-tokens_1.xq 3316639)
EXPECTED_FAILURE(zorba_data-cleaning_module/data-cleaning/string-similarity/editdistance_1.xq 3316639)
EXPECTED_FAILURE(zorba_data-cleaning_module/data-cleaning/string-similarity/jaccard-ngrams_1.xq 3316639)
EXPECTED_FAILURE(zorba_data-cleaning_module/data-cleaning/string-similarity/jaccard-tokens_1.xq 3316639)
EXPECTED_FAILURE(zorba_data-cleaning_module/data-cleaning/string-similarity/jarowinkler_1.xq 3316639)
EXPECTED_FAILURE(zorba_data-cleaning_module/data-cleaning/string-similarity/jaro_1.xq 3316639)
EXPECTED_FAILURE(zorba_data-cleaning_module/data-cleaning/string-similarity/ngrams_1.xq 3316639)
# # create the XQDOC target PROJECT_xqdoc that creates xml files
# # for all modules in that project
# SET(PROJECT_XQDOC "${PROJECT_SOURCE_DIR}/build/zorba/doc")
# file(MAKE_DIRECTORY ${PROJECT_XQDOC})
# 
# FILE(GLOB_RECURSE XQ_FILES RELATIVE "${CMAKE_CURRENT_SOURCE_DIR}/src" "${CMAKE_CURRENT_SOURCE_DIR}/src/*.xq")
# 
# # Add the xqdoc command for which a working zorba cmd is required.
# ADD_CUSTOM_TARGET(data_cleaning_xqdoc
#   ${ZORBA_EXE_SCRIPT}
#     --omit-xml-declaration
#     -f
#     -q "\"${CMAKE_CURRENT_SOURCE_DIR}/doc/xqdoc-main.xq\""
#     -e "\"modulePaths:=${CMAKE_CURRENT_SOURCE_DIR}/src\""    
#     -e "\"xqdocBuildPath:=${PROJECT_XQDOC}\""
#     WORKING_DIRECTORY "${PROJECT_SOURCE_DIR}/build"
#     COMMENT "Building XQDoc XML's for zorba_data-cleaning modules..."
# )
# SET_TARGET_PROPERTIES(data_cleaning_xqdoc PROPERTIES EXCLUDE_FROM_DEFAULT_BUILD 1)
