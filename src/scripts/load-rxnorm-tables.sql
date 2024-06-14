-- Load RxNorm RRF tables into SQLite.

PRAGMA foreign_keys = ON;

.mode csv
.separator |

.import tmp/rxnorm/RXNCONSO.RRF RXNCONSO
.import tmp/rxnorm/RXNSAT.RRF RXNSAT
.import tmp/rxnorm/RXNREL.RRF RXNREL
