import module namespace conversion = "http://zorba.io/modules/data-cleaning/conversion";

for $s in conversion:address-from-geocode ( 38.725735 , -9.15021 )
return fn:lower-case($s)
