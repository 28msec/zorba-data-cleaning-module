import module namespace conversion = "http://www.zorba-xquery.com/modules/data-cleaning/conversion";

let $arg := conversion:user-from-phone ('8654582358')
let $result :=
  if(exists($arg) or empty($arg))
  then 'OK'
  else 'NOT OK'
return $result
