import module namespace con = "http://www.zorba-xquery.com/modules/data-cleaning/consolidation";

con:least-attributes( ( <a att1="a1" att2="a2"/>, <b att1="a1" />, <c/> ) )
