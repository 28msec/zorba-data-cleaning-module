import module namespace con = "http://zorba.io/modules/data-cleaning/consolidation";

con:least-tokens( ( "a b c", "a b", "a"), " +" )
