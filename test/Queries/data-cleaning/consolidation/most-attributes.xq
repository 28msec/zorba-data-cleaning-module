import module namespace con = "http://zorba.io/modules/data-cleaning/consolidation";

con:most-attributes( ( <a att1="a1" att2="a2"/>, <b att1="a1" />, <c/> ) )
