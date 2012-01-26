import module namespace conversion = "http://www.zorba-xquery.com/modules/data-cleaning/conversion";

let $arg := conversion:phone-from-address('5655 E Gaskill Rd, Willcox, AZ, US')
let $result :=
  if(exists($arg) or empty($arg))
  then 'OK'
  else 'NOT OK'
return $result
