import module namespace con = "http://zorba.io/modules/data-cleaning/consolidation";

con:matching( ( "a A b", "c AAA d", "e BB f"), "A+" )
