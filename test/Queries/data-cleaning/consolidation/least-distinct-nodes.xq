import module namespace con = "http://zorba.io/modules/data-cleaning/consolidation";

con:least-distinct-nodes( ( <a><b/></a>, <b><c/></b>, <d/>) )
