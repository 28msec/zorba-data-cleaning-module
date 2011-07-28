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
 : This library module provides data conversion functions for processing calendar dates, 
 : temporal values, currency values, units of measurement, location names and postal addresses.
 :
 : The logic contained in this module is not specific to any particular XQuery implementation.
 :
 : @author Bruno Martins and Diogo Simões
 : @project data processing/data cleaning
 :)

module namespace conversion = "http://www.zorba-xquery.com/modules/data-cleaning/conversion";

declare namespace exref = "http://www.ecb.int/vocabulary/2002-08-01/eurofxref";
declare namespace ann = "http://www.zorba-xquery.com/annotations";

import schema namespace wp = 'http://api.whitepages.com/schema/';

import module namespace http = "http://www.zorba-xquery.com/modules/http-client";

declare namespace ver = "http://www.zorba-xquery.com/options/versioning";
declare option ver:module-version "2.0";

(: The key to be used when accessing the White Pages Web service :)
declare variable $conversion:key := "06ea2f21cc15602b6a3e242e3225a81a";

(:~
 : Uses a White-pages Web service to discover information about a given name, 
 : returning a sequence of strings for the phone numbers associated to the name.
 :
 : <br/>
 : Example usage : <pre> phone-from-user ('Maria Lurdes') </pre>
 : <br/>
 : The function invocation in the example above returns : <pre> (716) 686-4500 </pre>
 :
 : @param $name The name of person or organization.
 : @return A sequence of strings for the phone numbers associated to the name.
 : @example test/Queries/data-cleaning/conversion/phone-from-user.xq
 :)
declare %ann:nondeterministic function conversion:phone-from-user ( $name as xs:string) as xs:string*{
	let $name-value := replace($name, " ", "%20")
	let $url := concat("http://api.whitepages.com/find_person/1.0/?name=",$name-value,";api_key=",$conversion:key)
	let $doc := http:get-node($url)[2]
	return
    $doc/wp:wp/wp:listings/wp:listing/wp:phonenumbers/wp:phone/wp:fullphone/text()
};

(:~
 : Uses a White-pages Web service to discover information about a given name, 
 : returning a sequence of strings for the addresses associated to the name.
 :
 : <br/>
 : Example usage : <pre> address-from-user ('Maria Lurdes') </pre>
 : <br/>
 : The function invocation in the example above returns : <pre> 222 E 53rd St, Los Angeles, CA, US </pre>
 :							  <pre> 3362 Walden Ave, Depew, NY, US </pre>
 :
 : @param $name The name of person or organization.
 : @return A sequence of strings for the addresses associated to the name.
 : @example test/Queries/data-cleaning/conversion/address-from-user.xq
 :)
declare %ann:nondeterministic function conversion:address-from-user ( $name as xs:string) as xs:string*{
	let $name-value := replace($name, " ", "%20")
	let $url := concat("http://api.whitepages.com/find_person/1.0/?name=",$name-value,";api_key=",$conversion:key)
	let $doc := http:get-node($url)[2]
	for $a in $doc/wp:wp/wp:listings/wp:listing/wp:address
		let $fullstreet := $a/wp:fullstreet/text()
		let $city := $a/wp:city/text()
		let $state := $a/wp:state/text()
		let $country := $a/wp:country/text()
		return concat($fullstreet, ", ", $city, ", ", $state, ", ", $country)
};


(:~
 : Uses a White-pages Web service to discover information about a given phone number, 
 : returning a sequence of strings for the name associated to the phone number.
 :
 : <br/>
 : Example usage : <pre> user-from-phone ('8654582358') </pre>
 : <br/>
 : The function invocation in the example above returns : <pre> Homer Simpson </pre>
 :							  <pre> Sue M Simpson </pre>
 :
 : @param $phone-number A string with 10 digits corresponding to the phone number.
 : @return A sequence of strings for the person or organization's name associated to the phone number.
 : @example test/Queries/data-cleaning/conversion/user-from-phone.xq
 :)
declare %ann:nondeterministic function conversion:user-from-phone ( $phone-number as xs:string) as xs:string*{
	let $url := concat("http://api.whitepages.com/reverse_phone/1.0/?phone=",$phone-number,";api_key=",$conversion:key)
	let $doc := http:get-node($url)[2]
	return $doc/wp:wp/wp:listings/wp:listing/wp:displayname/text()	
};

(:~
 : Uses a White-pages Web service to discover information about a given phone number, 
 : returning a string for the address associated to the phone number.
 :
 : <br/>
 : Example usage : <pre> address-from-phone ('8654582358') </pre>
 : <br/>
 : The function invocation in the example above returns : <pre> 4610 Harrison Bend Rd, Loudon, TN, US </pre>
 :
 : @param $phone-number A string with 10 digits corresponding to the phone number.
 : @return A string for the addresses associated to the phone number.
 : @example test/Queries/data-cleaning/conversion/address-from-phone.xq
 :)
declare %ann:nondeterministic function conversion:address-from-phone ( $phone-number as xs:string) as xs:string*{
	let $url := concat("http://api.whitepages.com/reverse_phone/1.0/?phone=",$phone-number,";api_key=",$conversion:key)
	let $doc := http:get-node($url)[2]
	let $addresses :=
		for $a in $doc/wp:wp/wp:listings/wp:listing/wp:address
			let $fullstreet := $a/wp:fullstreet/text()
		  let $city := $a/wp:city/text()
		  let $state := $a/wp:state/text()
		  let $country := $a/wp:country/text()
			return concat($fullstreet, ", ", $city, ", ", $state, ", ", $country)
	return distinct-values($addresses)           
};

(:~
 : Uses a White-pages Web service to discover information about a given address, 
 : returning a sequence of strings for the names associated to the address.
 :
 : <br/>
 : Example usage : <pre> user-from-address('5655 E Gaskill Rd, Willcox, AZ, US') </pre>
 : <br/>
 : The function invocation in the example above returns : <pre> Stan Smith </pre>
 :
 : @param $address A string corresponding to the address (ex: 5655 E Gaskill Rd, Willcox, AZ, US).
 : @return A sequence of strings for the person or organization's names associated to the address.
 : @example test/Queries/data-cleaning/conversion/user-from-address.xq
 :)
declare %ann:nondeterministic function conversion:user-from-address ( $address as xs:string) as xs:string*{
	let $tokens := tokenize ($address, ",")
	let $token-full-street := $tokens[position()=1]
	let $state := 
		if (count($tokens) = 4)
		then replace($tokens[position()=3], " ", "")
		else
			if (count($tokens) = 5)
			then replace($tokens[position()=4], " ", "")
			else()
	let $house := tokenize($token-full-street, " ")[position()=1]
	let $street := replace(replace($token-full-street, "[0-9]+[ ]", ""), " ", "%20")
	let $url := concat("http://api.whitepages.com/reverse_address/1.0/?house=",$house, ";street=",$street, ";state=",$state,";api_key=",$conversion:key)
	let $doc := http:get-node($url)[2]
	return $doc/wp:wp/wp:listings/wp:listing/wp:displayname/text()
};

(:~
 : Uses a White-pages Web service to discover information about a given address, 
 : returning a sequence of strings for the phone number associated to the address.
 :
 : <br/>
 : Example usage : <pre> phone-from-address('5655 E Gaskill Rd, Willcox, AZ, US') </pre>
 : <br/>
 : The function invocation in the example above returns : <pre> (520) 824-3160 </pre>
 :
 : @param $address A string corresponding to the address (ex: 5655 E Gaskill Rd, Willcox, AZ, US).
 : @return A sequence of strings for the phone number or organization's names associated to the address.
 : @example test/Queries/data-cleaning/conversion/phone-from-address.xq
 :)
declare %ann:nondeterministic function conversion:phone-from-address ( $address as xs:string) as xs:string*{
	let $tokens := tokenize ($address, ",")
	let $token-full-street := $tokens[position()=1]
	let $state := 
		if (count($tokens) = 4)
		then replace($tokens[position()=3], " ", "")
		else
			if (count($tokens) = 5)
			then replace($tokens[position()=4], " ", "")
			else()
	let $house := replace($token-full-street, "([A-Za-z]+|[0-9]+[A-Za-z][A-Za-z]|[ ]+)", "")
	let $street-w-space := replace($token-full-street, $house, "")
	let $street := 
		if (substring($street-w-space, 1, 1) = " ")
		then substring($street-w-space, 2)
		else
			if(substring($street-w-space, string-length($street-w-space), 1) = " ")
			then substring($street-w-space, 1, string-length($street-w-space)-1)
			else ()
	let $street-form := replace($street, " ", "%20")
	let $url := concat("http://api.whitepages.com/reverse_address/1.0/?house=",$house, ";street=",$street-form, ";state=",$state,";api_key=",$conversion:key)
	let $doc := http:get-node($url)[2]
	return $doc/wp:wp/wp:listings/wp:listing/wp:phonenumbers/wp:phone/wp:fullphone/text()(: if($state = "TN") then "iguais" else "dif":)
};

(:~
 : Conversion function for units of measurement, acting as a wrapper over the CuppaIT WebService.
 : <br/>
 : WebService documentation at http://www.cuppait.com/UnitConversionGateway-war/UnitConversion?format=XML
 :
 : <br/>
 : Example usage : <pre> unit-convert ( 1 , "Distance", "mile", "kilometer" ) </pre>
 : <br/>
 : The function invocation in the example above returns : <pre> 1.609344 </pre>
 :
 : @param $v The amount we wish to convert.
 : @param $t The type of metric (e.g., "Distance")
 : @param $m1 The source measurement unit metric (e.g., "meter")
 : @param $m2 The target measurement unit metric (e.g., "mile")
 : @return The value resulting from the conversion
 : @error Returns err:notsupported if the type of metric, the source unit or the target unit are not known to the service.
 : @see http://www.cuppait.com/UnitConversionGateway-war/UnitConversion?format=XML
 : @example test/Queries/data-cleaning/conversion/unit-convert.xq
 :)
declare %ann:nondeterministic function conversion:unit-convert ( $v as xs:double, $t as xs:string, $m1 as xs:string, $m2 as xs:string ) {
 let $url     := "http://www.cuppait.com/UnitConversionGateway-war/UnitConversion?format=XML"
 let $ctype   := concat("ctype=",$t)
 let $cfrom   := concat("cfrom=",$m1)
 let $cto     := concat("cto=",$m2)
 let $camount := concat("camount=",$v)
 let $par     := string-join(($url,$ctype,$cfrom,$cto,$camount),"&amp;")
 let $result  := data(http:get-node($par)[2])
 return if (matches(data($result),"-?[0-9]+(\.[0-9]+)?")) then data($result) 
        else (error(QName('http://gibson.tagus.ist.utl.pt/~bmartins/xquery-modules/conversion', 'err:notsupported'), data($result)))
};

(:~
 : Placename to geospatial coordinates converter, acting as a wrapper over the Yahoo! geocoder service.
 :
 : <br/>
 : Example usage : <pre> geocode-from-address ( ("Lisboa", "Portugal") ) </pre>
 : <br/>
 : The function invocation in the example above returns : <pre> ( 38.725735 , -9.15021 ) </pre>
 : 
 : @param $q A sequence of strings corresponding to the different components (e.g., street, city, country, etc.) of the place name.
 : @return The pair of latitude and longitude coordinates associated with the input address.
 : @example test/Queries/data-cleaning/conversion/geocode-from-address.xq
 :)
declare %ann:nondeterministic function conversion:geocode-from-address ( $q as xs:string* ) as xs:double* {
 let $id   := ""
 let $url  := "http://where.yahooapis.com/geocode?q="
 let $q2   := string-join(for $i in $q return translate($i," ","+"),",")
 let $call := concat($url,$q2,"&amp;appid=",$id)
 let $doc  := http:get-node($call)[2]
 return    ( xs:double($doc/ResultSet/Result/latitude/text()) , xs:double($doc/ResultSet/Result/longitude/text()) )
};

(:~
 : Geospatial coordinates to placename converter, acting as a wrapper over the Yahoo! reverse geocoder service.
 :
 : <br/>
 : Example usage : <pre> address-from-geocode ( 38.725735 , -9.15021 ) </pre>
 : <br/>
 : The function invocation in the example above returns : <pre> ( 'Portugal' , 'Lisbon' , 'praca Marques de Pombal' ) </pre>
 :
 : @param $lat Geospatial latitude.
 : @param $lon Geospatial longitude.
 : @param $q The sequence of strings corresponding to the different components (e.g., street, city, country, etc.) of the place name that corresponds to the input geospatial coordinates.
 : @example test/Queries/data-cleaning/conversion/address-from-geocode.xq
 :)
declare %ann:nondeterministic function conversion:address-from-geocode ( $lat as xs:double, $lon as xs:double ) as xs:string* {
 let $id   := ""
 let $url  := "http://where.yahooapis.com/geocode?q="
 let $q    := concat($lat,",+",$lon) 
 let $call := concat($url,$q,"&amp;gflags=R&amp;appid=",$id)
 let $doc  := http:get-node($call)[2]
 return distinct-values( (if (string-length($doc//xs:string(*:country)) > 0) then ($doc//xs:string(*:country)) else (),
                          if (string-length($doc//xs:string(*:state)) > 0) then ($doc//xs:string(*:state)) else (),
                          if (string-length($doc//xs:string(*:county)) > 0) then ($doc//xs:string(*:county)) else (),
                          if (string-length($doc//xs:string(*:city)) > 0) then ($doc//xs:string(*:city)) else (),
			  if (string-length($doc//xs:string(*:neighborhood)) > 0) then ($doc//xs:string(*:neighborhood)) else (),
                          if (string-length($doc//xs:string(*:street)) > 0) then ($doc//xs:string(*:street)) else (),
                          if (string-length($doc//xs:string(*:house)) > 0) then ($doc//xs:string(*:house)) else () ) )
};

(:~
 : Currency conversion function, acting as a wrapper over the WebService from the European Central Bank.
 :
 : WebService documentation at http://www.ecb.int/stats/exchange/eurofxref/html/index.en.html
 :
 : <br/>
 : Example usage : <pre> currency-convert ( 1, "USD", "EUR", "2011-01-18" ) </pre>
 : <br/>
 : The function invocation in the example above returns : <pre> 0.747887218607434 </pre>
 :
 : @param $v The amount we wish to convert.
 : @param $m1 The source currency (e.g., "EUR").
 : @param $m2 The target currency (e.g., "USD").
 : @param $date The reference date.
 : @return The value resulting from the conversion.
 : @error Returns err:notsupported if the date, the source currency type or the target currency type are not known to the service.
 : @see http://www.ecb.int/stats/exchange/eurofxref/html/index.en.html
 : @example test/Queries/data-cleaning/conversion/currency-convert.xq
 :)
declare %ann:nondeterministic function conversion:currency-convert ( $v as xs:double, $m1 as xs:string, $m2 as xs:string, $date as xs:string ) {
 let $daily   := "http://www.ecb.europa.eu/stats/eurofxref/eurofxref-daily.xml"
 let $hist    := "http://www.ecb.europa.eu/stats/eurofxref/eurofxref-hist.xml"
 let $doc     := if (string-length($date) = 0) then http:get-node($daily)[2] else
                 ((for $a in http:get-node($hist)[2]//exref:Cube[
                   xs:string(@time)<=$date] order by $a/xs:string(@time) descending return $a)[1])
 let $toEUR   := if ( $m1="EUR" ) then (xs:double(1.0)) else ( $doc//exref:Cube[xs:string(@currency)=$m1]/xs:double(@rate) )
 let $fromEUR := if ( $m2="EUR" ) then (xs:double(1.0)) else ( $doc//exref:Cube[xs:string(@currency)=$m2]/xs:double(@rate) )
 let $result  := ($v div $toEUR) * $fromEUR
 return if (matches(string($result),"-?[0-9]+(\.[0-9]+)?")) then ($result) 
        else (error(QName('http://gibson.tagus.ist.utl.pt/~bmartins/xquery-modules/conversion', 'err:notsupported'), data($result)))
};

(:~
 : Uses a whois service to discover information about a given domain name, returning a sequence of strings 
 : for the phone numbers associated to the name.
 :
 : @param $addr A string with the domain.
 : @return A sequence of strings for the phone numbers associated to the domain name.
 :
 : <br/><br/><b> Attention : This function is still not implemented. </b> <br/>
 :
 :)
declare function conversion:phone-from-domain ( $domain as xs:string ) {
 ()
};

(:~
 : Uses a whois service to discover information about a given domain name, returning a sequence of strings 
 : for the addresses associated to the name.
 :
 : @param $addr A string with the domain.
 : @return A sequence of strings for the addresses associated to the domain name.
 :
 : <br/><br/><b> Attention : This function is still not implemented. </b> <br/>
 :
 :)
declare function conversion:address-from-domain ( $domain as xs:string ) {
 ()
};

(:~
 : Uses a whois service to discover information about a given domain name, returning a sequence of strings 
 : for the person or organization names associated to the name.
 :
 : @param $addr A string with the domain.
 : @return A sequence of strings for the person or organization names associated to the domain name.
 :
 : <br/><br/><b> Attention : This function is still not implemented. </b> <br/>
 :
 :)
declare function conversion:name-from-domain ( $domain as xs:string ) {
 ()
};

