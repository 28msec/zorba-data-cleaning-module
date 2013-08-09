xquery version "1.0";

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
 : <p>This library module provides phonetic string similarity functions, comparing strings with basis on how they sound.</p>
 : <p/>
 : <p>These metrics are particularly effective in matching names, since names are often spelled in different 
 : ways that sound the same.</p>
 : <p/>
 : <p>The logic contained in this module is not specific to any particular XQuery implementation.</p>
 :
 : @author Bruno Martins
 : @project Zorba/Data Cleaning/Phonectic String Similarity
 :)

module namespace simp = "http://zorba.io/modules/data-cleaning/phonetic-string-similarity";

declare namespace ver = "http://zorba.io/options/versioning";
declare option ver:module-version "2.0";

(:~
 : <p>Returns the Soundex key for a given string.</p>
 : <p/>
 : 
 : <p>Example usage : <code>soundex-key("Robert")</code></p>
 : <p/>
 : <p>The function invocation in the example above returns : <code>"R163"</code></p>
 :
 : @param $s1 The string.
 : @return The Soundex key for the given input string.
 : @example test/Queries/data-cleaning/phonetic-string-similarity/soundex-key.xq
 :)
declare function simp:soundex-key ( $s1 as xs:string ) as xs:string { 
 let $clean := replace(replace(replace(replace(replace(replace(replace(upper-case($s1),"[^1-9A-Z]",""),"([BFPV])[HW]*[BFPV]","$1"),"([CGJKQSXZ])[HW]*[CGJKQSXZ]","$1"),"([DT])[HW]*[DT]","$1"),"([L])[HW]*[L]","$1"),"([MN])[HW]*[MN]","$1"),"([R])[HW]*[R]","$1")
 let $first := substring($clean,1,1)
 let $suffix := replace(replace(replace(replace(replace(replace(substring($clean,2),"[BFPV]","1"),"[CGJKQSXZ]","2"),"[DT]","3"),"L","4"),"[MN]","5"),"[R]","6") 
 let $merge := replace(replace($suffix, "([1-6])\1","$1"),"[^1-6]", "")
 let $result := concat($first, $merge)
 return substring(concat($result,"0000"),1,4)
};

(:~
 : <p>Checks if two strings have the same Soundex key.</p>
 : <p/>
 : 
 : <p>Example usage : <code>soundex( "Robert" , "Rupert" )</code></p>
 : <p/>
 : <p>The function invocation in the example above returns : <code>true</code></p>
 :
 : @param $s1 The first string.
 : @param $s2 The second string.
 : @return Returns true if both strings have the same Soundex key and false otherwise.
 : @example test/Queries/data-cleaning/phonetic-string-similarity/soundex-key.xq
 :)
declare function simp:soundex ( $s1 as xs:string, $s2 as xs:string ) as xs:boolean {
 simp:soundex-key($s1) = simp:soundex-key($s2)
};

(:~
 : <p>Returns the Metaphone key for a given string.</p>
 : <p>The Metaphone algorithm produces variable length keys as its output, as opposed to Soundex's fixed-length keys.</p>
 : <p/>
 : 
 : <p>Example usage : <code>metaphone-key("ALEKSANDER")</code></p>
 : <p/>
 : <p>The function invocation in the example above returns : <code>"ALKSNTR"</code></p>
 :
 : @param $s1 The string.
 : @return The Metaphone key for the given input string.
 : @example test/Queries/data-cleaning/phonetic-string-similarity/metaphone-key.xq
 :)
declare function simp:metaphone-key ( $s1 as xs:string ) as xs:string {
 let $aux1  := replace(upper-case($s1),"([^C])\1","$1")
 let $aux2  := if (matches($aux1,"$(([KGP]N)|([A]E)|([W]R))")) then (substring($aux1,2,string-length($aux1))) else ($aux1)  
 let $aux3  := replace(replace($aux2,"MB","M"),"B$","")
 let $aux4  := replace(replace(replace(replace(replace($aux3,"CIA","XIA"),"SCH","SKH"),"CH","XH"),"C([IEY])","S$1"),"C","K")
 let $aux5  := replace(replace($aux4,"DG([EYI])","JG$1"),"D","T")
 let $aux6  := replace(replace($aux5,"GH([^AEIOU])","H$1"),"G(N(ED)?)$","$1")
 let $aux7  := replace(replace(replace($aux6,"([^G]?)G([IEY])","$1J$2"),"([^G]?)G","$1K"),"GG","G")
 let $aux8  := replace(replace(replace(replace($aux7,"([AEIOU])H([^AEIOU])","$1$2"),"CK","K"),"PH","F"),"Q","K")
 let $aux9  := replace(replace(replace(replace(replace($aux8,"S(H|(IO)|(IA))","X$1"),"T((IO)|(IA))","X$1"),"TH","0"),"TCH","CH"),"V","F")
 let $aux10 := replace(replace(replace(replace(replace(replace($aux9,"$WH","W"),"W([^AEIOU])","$1"),"$X","S"),"X","KS"),"Y([^AEIOU])","$1"),"Z","S")
 return concat(substring($aux10,1,1) , replace(substring($aux10,2,string-length($aux10)) , "[AEIOU]", ""))
};

(:~
 : <p>Checks if two strings have the same Metaphone key.</p>
 : <p/>
 : 
 : <p>Example usage : <code>metaphone("ALEKSANDER", "ALEXANDRE")</code></p>
 : <p/>
 : <p>The function invocation in the example above returns : <code>true</code></p>
 :
 : @param $s1 The first string.
 : @param $s2 The second string.
 : @return Returns true if both strings have the same Metaphone key and false otherwise.
 : @example test/Queries/data-cleaning/phonetic-string-similarity/metaphone.xq
 :)
declare function simp:metaphone ( $s1 as xs:string, $s2 as xs:string ) as xs:boolean {
 simp:metaphone-key($s1) = simp:metaphone-key($s2)
};
