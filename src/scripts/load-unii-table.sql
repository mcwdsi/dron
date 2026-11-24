-- Load UNII table into SQLite.

PRAGMA foreign_keys = ON;

.mode tabs
.separator "\t"

.import tmp/unii/UNII_Records_Latest.txt UNII
