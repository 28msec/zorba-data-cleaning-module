import module namespace con = "http://www.zorba-xquery.com/modules/data-cleaning/consolidation";

con:most-distinct-nodes( ( <a><b/></a>, <a><a/></a>, <b/>) )
