xquery version "3.0";

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
 : <p>This library module provides hybrid string similarity functions, combining the properties of 
 : character-based string similarity functions and token-based string similarity functions.</p>
 : <p/>
 : <p>The logic contained in this module is not specific to any particular XQuery implementation,
 : although the module requires the trigonometic functions of XQuery 3.0 or a math extension 
 : function such as sqrt($x as numeric) for computing the square root.</p>
 :
 : @author Bruno Martins and Diogo Simões
 : @project Zorba/Data Cleaning/Hybrid String Similarity
 :)

module namespace simh = "http://zorba.io/modules/data-cleaning/hybrid-string-similarity";

(: <p>In the QizX os Saxon XQuery engines, it is possible to call external functions from the Java math library :)
(: declare namespace math = "java:java.lang.Math";</p> :)
declare namespace math = "http://www.w3.org/2005/xpath-functions/math";

import module namespace set  = "http://zorba.io/modules/data-cleaning/set-similarity";
import module namespace simt = "http://zorba.io/modules/data-cleaning/token-based-string-similarity";
import module namespace simc = "http://zorba.io/modules/data-cleaning/character-based-string-similarity";
import module namespace simp = "http://zorba.io/modules/data-cleaning/phonetic-string-similarity";

declare namespace ver = "http://www.zorba-xquery.com/options/versioning";
declare option ver:module-version "2.0";

(:~
 : <p>Returns the cosine similarity coefficient between sets of tokens extracted from two strings.</p>
 : <p/>
 : <p>The tokens from each string are weighted according to their occurence frequency (i.e., weighted according to the
 : term-frequency heuristic from Information Retrieval).</p>
 : <p>The Soundex phonetic similarity function is used to discover token identity, which is equivalent to saying that
 : this function returns the cosine similarity coefficient between sets of Soundex keys.</p>
 : <p/>
 : 
 : <p>Example usage : <code> soft-cosine-tokens-soundex("ALEKSANDER SMITH", "ALEXANDER SMYTH", " +") </code></p>
 : <p/>
 : <p>The function invocation in the example above returns : <code> 1.0 </code></p>
 :
 : @param $s1 The first string.
 : @param $s2 The second string.
 : @param $r A regular expression forming the delimiter character(s) which mark the boundaries between adjacent tokens.
 : @return The cosine similarity coefficient between the sets of Soundex keys extracted from the two strings.
 : @example test/Queries/data-cleaning/hybrid-string-similarity/soft-cosine-tokens-soundex.xq
 :)
declare function simh:soft-cosine-tokens-soundex ( $s1 as xs:string, $s2 as xs:string, $r as xs:string ) as xs:double {
 let $keys1 := for $kt1 in tokenize($s1,$r) return simp:soundex-key($kt1)
 let $keys2 := for $kt1 in tokenize($s2,$r) return simp:soundex-key($kt1)
 return simt:cosine($keys1, $keys2)
};

(:~
 : <p>Returns the cosine similarity coefficient between sets of tokens extracted from two strings.</p> 
 : <p>The tokens from each string are weighted according to their occurence frequency (i.e., weighted according to the
 : term-frequency heuristic from Information Retrieval).</p>
 : <p>The Metaphone phonetic similarity function is used to discover token identity, which is equivalent to saying that
 : this function returns the cosine similarity coefficient between sets of Metaphone keys.</p>
 : <p/>
 : 
 : <p>Example usage : <code> soft-cosine-tokens-metaphone("ALEKSANDER SMITH", "ALEXANDER SMYTH", " +" ) </code></p>
 : <p/>
 : <p>The function invocation in the example above returns : <code> 1.0 </code></p>
 :
 : @param $s1 The first string.
 : @param $s2 The second string.
 : @param $r A regular expression forming the delimiter character(s) which mark the boundaries between adjacent tokens.
 : @return The cosine similarity coefficient between the sets Metaphone keys extracted from the two strings.
 : @example test/Queries/data-cleaning/hybrid-string-similarity/soft-cosine-tokens-metaphone.xq
 :)
declare function simh:soft-cosine-tokens-metaphone ( $s1 as xs:string, $s2 as xs:string, $r as xs:string ) as xs:double {
 let $keys1 := for $kt1 in tokenize($s1,$r) return simp:metaphone-key($kt1)
 let $keys2 := for $kt1 in tokenize($s2,$r) return simp:metaphone-key($kt1)
 return simt:cosine($keys1, $keys2)
};

(:~
 : <p>Returns the cosine similarity coefficient between sets of tokens extracted from two strings.</p> 
 : <p>The tokens from each string are weighted according to their occurence frequency (i.e., weighted according to the
 : term-frequency heuristic from Information Retrieval).</p>
 : <p>The Edit Distance similarity function is used to discover token identity, and tokens having an edit distance 
 : bellow a given threshold are considered as matching tokens.</p>
 : <p/>
 : 
 : <p>Example usage : <code> soft-cosine-tokens-edit-distance("The FLWOR Foundation", "FLWOR Found.", " +", 0 ) </code></p>
 : <p/>
 : <p>The function invocation in the example above returns : <code> 0.408248290463863 </code></p>
 :
 : @param $s1 The first string.
 : @param $s2 The second string.
 : @param $r A regular expression forming the delimiter character(s) which mark the boundaries between adjacent tokens.
 : @param $t A threshold for the similarity function used to discover token identity.
 : @return The cosine similarity coefficient between the sets tokens extracted from the two strings.
 :)
declare function simh:soft-cosine-tokens-edit-distance ( $s1 as xs:string, $s2 as xs:string, $r as xs:string, $t as xs:integer ) as xs:double {
(:
 let $tokens1   := tokenize($s1,$r)
 let $tokens2   := tokenize($s2,$r)
 let $tokens    := ($tokens1, $tokens2)
 let $vocab     := for $a at $apos in $tokens
                   where every $ba in subsequence($tokens, 1, $apos - 1) satisfies not(simc:edit-distance($ba,$a) <= $t)
                   return $a
 let $freq1     := for $a1 in $vocab return count($tokens1[simc:edit-distance(.,$a1) <= $t])
 let $freq2     := for $a2 in $vocab return count($tokens2[simc:edit-distance(.,$a2) <= $t])
 let $freq1pow  := for $aa1 in $freq1 return $aa1 * $aa1
 let $freq2pow  := for $aa2 in $freq2 return $aa2 * $aa2
 let $mult      := for $freq at $pos in $freq1 return $freq * $freq2[$pos] 
 return sum($mult) div (math:sqrt(sum($freq1pow)) * math:sqrt(sum($freq2pow)))
 :)
 xs:double(0)
};

(:~
 : <p>Returns the cosine similarity coefficient between sets of tokens extracted from two strings.</p> 
 : <p>The tokens from each string are weighted according to their occurence frequency (i.e., weighted according to the
 : term-frequency heuristic from Information Retrieval).</p>
 : <p>The Jaro similarity function is used to discover token identity, and tokens having a Jaro similarity above
 : a given threshold are considered as matching tokens.</p>
 : <p/>
 : 
 : <p>Example usage : <code> soft-cosine-tokens-jaro("The FLWOR Foundation", "FLWOR Found.", " +", 1 ) </code></p>
 : <p/>
 : <p>The function invocation in the example above returns : <code> 0.5 </code></p>
 :
 : @param $s1 The first string.
 : @param $s2 The second string.
 : @param $r A regular expression forming the delimiter character(s) which mark the boundaries between adjacent tokens.
 : @param $t A threshold for the similarity function used to discover token identity.
 : @return The cosine similarity coefficient between the sets tokens extracted from the two strings.
 : @example test/Queries/data-cleaning/hybrid-string-similarity/soft-cosine-tokens-jaro.xq
 :)
declare function simh:soft-cosine-tokens-jaro ( $s1 as xs:string, $s2 as xs:string, $r as xs:string, $t as xs:double ) as xs:double {
 let $tokens1   := tokenize($s1,$r)
 let $tokens2   := tokenize($s2,$r)
 let $tokens    := ($tokens1, $tokens2)
 let $vocab     := for $a at $apos in $tokens
                   where every $ba in subsequence($tokens, 1, $apos - 1) satisfies not(simc:jaro($ba,$a) >= $t)
                   return $a
 let $freq1     := for $a1 in $vocab return count($tokens1[simc:jaro(.,$a1) >= $t])
 let $freq2     := for $a2 in $vocab return count($tokens2[simc:jaro(.,$a2) >= $t])
 let $freq1pow  := for $aa1 in $freq1 return $aa1 * $aa1
 let $freq2pow  := for $aa2 in $freq2 return $aa2 * $aa2
 let $mult      := for $freq at $pos in $freq1 return $freq * $freq2[$pos] 
 return sum($mult) div (math:sqrt(sum($freq1pow)) * math:sqrt(sum($freq2pow)))
};

(:~
 : <p>Returns the cosine similarity coefficient between sets of tokens extracted from two strings.</p> 
 : <p>The tokens from each string are weighted according to their occurence frequency (i.e., weighted according to the
 : term-frequency heuristic from Information Retrieval).</p>
 : <p>The Jaro-Winkler similarity function is used to discover token identity, and tokens having a Jaro-Winkler
 : similarity above a given threshold are considered as matching tokens.</p>
 : <p/>
 : 
 : <p>Example usage : <code> soft-cosine-tokens-jaro-winkler("The FLWOR Foundation", "FLWOR Found.", " +", 1, 4, 0.1 ) </code></p>
 : <p/>
 : <p>The function invocation in the example above returns : <code> 0.45 </code></p>
 :
 : @param $s1 The first string.
 : @param $s2 The second string.
 : @param $r A regular expression forming the delimiter character(s) which mark the boundaries between adjacent tokens.
 : @param $t A threshold for the similarity function used to discover token identity.
 : @param $prefix The number of characters to consider when testing for equal prefixes with the Jaro-Winkler metric.
 : @param $fact The weighting factor to consider when the input strings have equal prefixes with the Jaro-Winkler metric.
 : @return The cosine similarity coefficient between the sets tokens extracted from the two strings.
 : @example test/Queries/data-cleaning/hybrid-string-similarity/soft-cosine-tokens-jaro-winkler.xq
 :)
declare function simh:soft-cosine-tokens-jaro-winkler ( $s1 as xs:string, $s2 as xs:string, $r as xs:string, $t as xs:double, $prefix as xs:integer?, $fact as xs:double? ) as xs:double {
 let $tokens1   := tokenize($s1,$r)
 let $tokens2   := tokenize($s2,$r)
 let $tokens    := ($tokens1, $tokens2)
 let $vocab     := for $a at $apos in $tokens
                   where every $ba in subsequence($tokens, 1, $apos - 1) satisfies not(simc:jaro-winkler($ba,$a,$prefix,$fact) >= $t)
                   return $a
 let $freq1     := for $a1 in $vocab return count($tokens1[simc:jaro-winkler(.,$a1,$prefix,$fact) >= $t])
 let $freq2     := for $a2 in $vocab return count($tokens2[simc:jaro-winkler(.,$a2,$prefix,$fact) >= $t])
 let $freq1pow  := for $aa1 in $freq1 return $aa1 * $aa1
 let $freq2pow  := for $aa2 in $freq2 return $aa2 * $aa2
 let $mult      := for $freq at $pos in $freq1 return $freq * $freq2[$pos] 
 return sum($mult) div (math:sqrt(sum($freq1pow)) * math:sqrt(sum($freq2pow)))
};

(:~
 : <p>Returns the Monge-Elkan similarity coefficient between two strings, using the Jaro-Winkler</p> 
 : <p>similarity function to discover token identity.</p>
 : <p/>
 : 
 : <p>Example usage : <code> monge-elkan-jaro-winkler("Comput. Sci. and Eng. Dept., University of California, San Diego", "Department of Computer Scinece, Univ. Calif., San Diego", 4, 0.1) </code></p>
 : <p/>
 : <p>The function invocation in the example above returns : <code> 0.992 </code></p>
 :
 : @param $s1 The first string.
 : @param $s2 The second string.
 : @param $prefix The number of characters to consider when testing for equal prefixes with the Jaro-Winkler metric.
 : @param $fact The weighting factor to consider when the input strings have equal prefixes with the Jaro-Winkler metric.
 : @return The Monge-Elkan similarity coefficient between the two strings.
 : @example test/Queries/data-cleaning/hybrid-string-similarity/monge-elkan-jaro-winkler.xq
 :)
declare function simh:monge-elkan-jaro-winkler ( $s1 as xs:string, $s2 as xs:string, $prefix as xs:integer, $fact as xs:double  ) as xs:double{
 let $s1tokens := tokenize($s1, " ") 
 let $s2tokens := tokenize($s1, " ") 
 let $length := min((count($s1tokens), count($s2tokens)))
 let $res := for $s1n in $s1tokens 
             return max(for $s2n in $s2tokens return simc:jaro-winkler($s1n,$s2n,$prefix,$fact))		
 return (1 div $length) * sum($res)
};
