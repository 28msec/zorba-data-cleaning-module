import module namespace con = "http://www.zorba-xquery.com/modules/data-cleaning/consolidation";

con:least-distinct-nodes( ( <a><b/></a>, <b><c/></b>, <d/>) )
