import module namespace con = "http://zorba.io/modules/data-cleaning/consolidation";

con:least-nodes( ( <a><b/></a>, <b><c/></b>, <d/>) )
