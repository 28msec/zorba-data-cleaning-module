# Copyright 2006-2008 The FLWOR Foundation.
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

DECLARE_ZORBA_MODULE (URI "http://www.zorba-xquery.com/modules/data-cleaning/character-based-string-similarity"
                      VERSION 1.0 FILE "character-based-string-similarity.xq")

DECLARE_ZORBA_MODULE (URI "http://www.zorba-xquery.com/modules/data-cleaning/consolidation"
                      VERSION 1.0 FILE "consolidation.xq")

DECLARE_ZORBA_SCHEMA( FILE whitepages_schema.xsd
                      URI "http://api.whitepages.com/schema/")
DECLARE_ZORBA_MODULE (URI "http://www.zorba-xquery.com/modules/data-cleaning/conversion"
                      VERSION 1.0 FILE "conversion.xq")

DECLARE_ZORBA_MODULE (URI "http://www.zorba-xquery.com/modules/data-cleaning/hybrid-string-similarity"
                      VERSION 1.0 FILE "hybrid-string-similarity.xq")

DECLARE_ZORBA_MODULE (URI "http://www.zorba-xquery.com/modules/data-cleaning/normalization"
                      VERSION 1.0 FILE "normalization.xq")

DECLARE_ZORBA_MODULE (URI "http://www.zorba-xquery.com/modules/data-cleaning/phonetic-string-similarity"
                      VERSION 1.0 FILE "phonetic-string-similarity.xq")

DECLARE_ZORBA_MODULE (URI "http://www.zorba-xquery.com/modules/data-cleaning/set-similarity"
                      VERSION 1.0 FILE "set-similarity.xq")

DECLARE_ZORBA_MODULE (URI "http://www.zorba-xquery.com/modules/data-cleaning/thesaurus"
                      VERSION 1.0 FILE "thesaurus.xq")

DECLARE_ZORBA_MODULE (URI "http://www.zorba-xquery.com/modules/data-cleaning/token-based-string-similarity"
                      VERSION 1.0 FILE "token-based-string-similarity.xq")
