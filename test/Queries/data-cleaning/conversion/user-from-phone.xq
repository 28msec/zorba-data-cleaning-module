import module namespace conversion = "http://www.zorba-xquery.com/modules/data-cleaning/conversion";

let $arg := conversion:user-from-phone ('8654582358')[1]
let $result :=
  if(matches($arg, "([0-9]|[a-z]|[A-Z])*") and not(matches($arg, "invalid")))
  then 'OK'
  else 'NOT OK'
return $result
