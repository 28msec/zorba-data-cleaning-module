import module namespace con = "http://zorba.io/modules/data-cleaning/consolidation";

con:most-distinct-attributes( ( <a att1="a1" att2="a2" att3="a3"/>, <a att1="a1" att2="a2"><b att2="a2" /></a>, <c/> ) )
