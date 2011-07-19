import module namespace con = "http://www.zorba-xquery.com/modules/data-cleaning/consolidation";

con:most-distinct-elements( ( <a><b/><c/><d/></a>, <a><b/><b/><c/></a>, <a/> ) )
