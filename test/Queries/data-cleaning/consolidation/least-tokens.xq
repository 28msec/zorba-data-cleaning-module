import module namespace con = "http://www.zorba-xquery.com/modules/data-cleaning/consolidation";

con:least-tokens( ( "a b c", "a b", "a"), " +" )
