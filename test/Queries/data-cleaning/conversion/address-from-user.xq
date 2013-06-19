import module namespace conversion = "http://www.zorba-xquery.com/modules/data-cleaning/conversion";

let $arg := conversion:address-from-user('Maria Lurdes')[1]
let $result :=
  if(matches($arg, "([0-9]*[ ][A-Z]*[a-z]*)*") and not(matches($arg, "invalid")))
  then 'OK'
  else 'NOT OK'
return $result

