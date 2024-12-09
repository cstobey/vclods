# .etl Extension Details and Commands

Commands applied to a field in the Temp table create statement. These Commands (and the CREATE TEMPORARY TABLE statement they are attached to) must be in an extension options file. Stdin into the .etl extension must be a the VALUES part of the computed INSERT statement (the fields in the order of the CREATE TEMPORARY TABLE statement that exclusively `#ingest`, `#unique`, or `#map` commands attached to them). Fields may have multiple commands attached to them. `.etl` should always be followed by `.batch` unless you just want to test (ie, `do.sql.batch.etl-file.sh`)

NOTE: "destination table" below refers to the table you are inserting into. To allow the same table to be referenced several different ways, the format is \<physical table name\>@\<identifier\> where only the physical table name is required.

## Stand-Alone Commands
Order between #sync, #append, and #include commands indicates execution order. 
Command | Description
--|--
#sync | Command to sync the temp table with the destination table. First parameter is a destination table name, additional parameters explained below. When modified with `_no_update` (as #sync_no_update), any otherwise computed changes will not be UPDATEd.
#mode | Alter how a table is processed. Takes a destination table name and an option. See the availible options below.
#join | for the given table (first argument), JOIN in a given #explode sub-temp table (second argument)
#ljoin | #join, but do a LEFT JOIN instead of a JOIN
#include | Load a sql script file (with no .extension) to handle any additional reformatting or processing that is required. If added to a field line, also acts like #ignore.
#append | Add the rest of the line to the stream. Allows you to append manual queries without using #include. If added to a field line, also acts like #ignore.
#generate | Generate a virtual field that is not in the temp table. The SQL statements that follow the field name are used instead of a column name in the temp table when doing the ETL into the destination table. Used in place of either a VIRTUAL column on the temp table or an #include script to do the generation. See Modifiers below.
#generate_unique | A logical combination of #generate and #unique
#pivot | #generate but for #join fields that need to be pivoted on. After the field name, takes the #join table name, field, and expected value. 

## Commands after a field definition
Unless specified, the following commands take the destination table and field name as parameters. Spaces are not allowed in table and field names. #generate follows the same format but is not attached to a field.
Command | Description
--|--
#ingest | Force this field to be ingested in the initial INSERT INTO tmp table. Takes no parameters.
#ignore | Do not ingest this field into the initial temp table. Takes no parameters.
#key | The auto_incrementing Primary key that will be used to sync deep FK chains. Will not be ingested, but rather derived after syncing with the destination table.
#unique | Unique fields candidate keys on the table. If there is no UNIQUE index, you can spoof the behavior with #unique_no_update. Does not need to be unique in the temp table (useful for deep FK chains). Multiple #unique fields for a single destination table act like a single index.
#map | A regular field on the given destination table. See Modifiers below.
#explode | Generate a sub-temp table that explodes a column (or virtual column like #generate). Attach this directive to an id column for the temp table. Use with #join.<br />There are several methods of exploding with different generated columns. See details below.

## #mode Options
Specifies different methods of how a to sync a table. modes of the same Group exclude the use of other modes in that same Group.
Option | Group | Description
--|--|--
odku | Format | Uses INSERT INTO ... ON DUPLICATE KEY UPDATE to quickly sync the table. Can bloat the id space so best with log type tables.
odku_ai | Format | The default: same as odku but forces the AUTO_INCREMENTING keys not to bloat at the expence of an ALTER TABLE.
ui_split | Format | tries its best to not bloat AUTO_INCREMENTING keys by being more particular about managing whether it uses an UPDATE or INSERT. Best with lower cardinality tables.
sparse | Quantity | Treats the temp table as sparse. All rows with NULL unique values are ignored. Only makes sense for leaf tables.

## #sync Optional Parameters
These follow a destination table name
Option | Format | Description
--|--|--
SET_NOT_PRESENT | \<SET clause without the SET\>\<Optional WHERE clause\> | UPDATEs any rows in the destination table that are not found in the temp table in the provided way.
DELETE_NOT_PRESENT | \<Optional WHERE clause without the WHERE\> | DELETEs any rows in the destination table that are not found in the temp table and conform to the where clause.

## Modifiers for #mapi, #generate, and #pivot
These are appened directly to the Command that they modify, so #map + _no_update would be #map_no_update.
Modifier | Description
--|--
_no_update | Exclude this field from being updated if it otherwise would have been.
_ifnull | The default: This field will be updated if the temp table value IS NOT NULL.
_always | Update the field even if the temp table value IS NULL.
_greatest | Update the field to the GREATEST value between the destination and temp tables. NULL safe.
_least | Update the field to the LEAST value between the destination and temp tables. NULL safe.

## Modifiers for #explode
All Sub tables have an `id` column that linkes to the main temp tables id field (that the #explode directive is attached to). The temp table id is what the #explode directive is attached to. The 2 id fields are used for normal #sync operations by using the #join directive.
Modifier | Columns | Description
--|--|--
_csv | id, the_value, index_number | break up comma separated lists... quoting not supported (this is a super simple implementation)
_json_shallow | id, the_value, the_key | From a JSON document, break up the top level Object OR Array. the_key is a string for Ojects or an int for Arrays.
_json_deep | id, the_value, the_key, the_jpath | Recursively explode a JSON field, retaining all leaf nodes (including empty objects/arrays).
_manual | User Defined (must include id) | takes an #include file instead of a #generate SQL clause so you can define your own temp table to use. Be sure to keep the temp table's name consistent.
