(:
 : Copyright 2006-2009 The FLWOR Foundation.
 :
 : Licensed under the Apache License, Version 2.0 (the "License");
 : you may not use this file except in compliance with the License.
 : You may obtain a copy of the License at
 :
 : http://www.apache.org/licenses/LICENSE-2.0
 :
 : Unless required by applicable law or agreed to in writing, software
 : distributed under the License is distributed on an "AS IS" BASIS,
 : WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 : See the License for the specific language governing permissions and
 : limitations under the License.
 :)

(:~
 : This library module provides thesaurus functions for checking semantic relations between strings 
 : and for checking abbreviations.

 : These functions are particularly useful in tasks related to the creation of semantic mappings.
 : 
 : The logic contained in this module requires an XQuery implementation that supports the 
 : thesaurus functionalities of XQuery Full-Text.
 :
 : @author Bruno Martins
 : @project data processing/data cleaning
 :)

module namespace thesaurus = "http://www.zorba-xquery.com/modules/data-cleaning/thesaurus";

declare namespace ver = "http://www.zorba-xquery.com/options/versioning";
declare option ver:module-version "3.0";

(:~
 : Checks if two strings have a relationship defined in a given thesaurus.
 : The implementation of this function depends on the thesaurus capabilities offered by XQuery Full-Text.
 :
 : <br/>
 : Example usage : <pre> related ( "mammal", "dog", "http://www.w3.org/2006/03/wn/wn20/", "broader" ) </pre>
 : <br/>
 : The function invocation in the example above returns : <pre> true </pre>
 :
 : @param $s1 The first string.
 : @param $s2 The second string.
 : @param $t The thesaurus to be considered.
 : @param $type An identifyer for the type of relationship.
 : @return true if the first string has the provided relationship with the second string defined in the thesaurus and false otherwise.
 :
 : <br/><br/><b> Attention : This function is still not implemented. </b> <br/>
 :)
declare function thesaurus:check-related ( $s1 as xs:string, $s2 as xs:string, $t as xs:string, $type as xs:string ) as xs:boolean {
(: 
 count( $s1 ftcontains { $s2 } with thesaurus at {$t} relationship concat("BT",$type) ) > 0
:)
 false()
};

(:~
 : Returns a sequence with the strings that have a relationship, 
 : defined in a given thesaurus, with the string provided as input.
 :
 : <br/>
 : Example usage : <pre> related-terms( "blue", "http://www.w3.org/2006/03/wn/wn20/", "related" ) </pre>
 : <br/>
 : The function invocation in the example above returns : <pre> ( "sky", "water" ) </pre>
 :
 : @param $s1 The string with the query term.
 : @param $t The thesaurus to be considered (e.g., "http://www.w3.org/2006/03/wn/wn20/").
 : @param $type An identifyer for the type of relationship.
 : @return A sequence with the strings that have the provided relationship, defined in the thesaurus, with the query term.
 :
 : <br/><br/><b> Attention : This function is still not implemented. </b> <br/>
 :
 :)
declare function thesaurus:related-terms ( $s1 as xs:string, $t as xs:string, $type as xs:string ) as xs:string* {
 ()
};


