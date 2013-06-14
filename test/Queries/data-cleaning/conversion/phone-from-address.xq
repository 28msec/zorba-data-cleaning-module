import module namespace conversion = "http://zorba.io/modules/data-cleaning/conversion";

let $arg := conversion:phone-from-address('5655 E Gaskill Rd, Willcox, AZ, US')[1]
let $result :=
  if(matches($arg, "(\([0-9]{3}\) [0-9]{3}\-[0-9]{4})*") and not(matches($arg, "invalid")))
  then 'OK'
  else 'NOT OK'
return $result
