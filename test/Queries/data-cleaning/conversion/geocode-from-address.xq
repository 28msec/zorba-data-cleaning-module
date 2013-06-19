import module namespace conversion = "http://www.zorba-xquery.com/modules/data-cleaning/conversion";

let $geocode := conversion:geocode-from-address ( ("Lisboa", "Portugal") )
for $result in $geocode
return floor($result)
