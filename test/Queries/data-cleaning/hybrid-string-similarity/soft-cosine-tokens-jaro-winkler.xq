import module namespace simh = "http://www.zorba-xquery.com/modules/data-cleaning/hybrid-string-similarity";

simh:soft-cosine-tokens-jaro-winkler("The FLWOR Foundation", "FLWOR Found.", " +", 1, 4, 0.1 )
