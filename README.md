# VCLODs: Variable Configuration Locking Operation Destination Scripts
## What are VCLODs?
An open-source directory based ksh framework to productionize programs from component scripts

## What are the benefits?
* Build from simple scripts
* Encoding Timing and Configuration in script absolute path, allows complex behavior
* Automatic human readable process reporting
* Connections are easy (see the connections/ directory)
  * InfluxDB, MongoDB, Redis, Postgres would be easy to add
  * MySQL/MariaDB, MSSQL already implemented
* Use your own language (shebang) - Javascript/Node, Ruby, Go
* Scripts/programs can focus on their purpose without dealing with their infrastructure
* Fast dev, Fast execution, Dev mobility, Extensibility - Especially for Data tasks
  * ~500 C program lines convert to 14 VCLODs lines
  * At a glance debugging

## How does it work?
* ~400 ksh lines that provide...
* Modularizing simple scripts/programs to automate ~95% of the boilerplate needed to productionize
  * Configuration
  * Locking 
  * Logging
  * Alerting
  * Timing (cron over directories)
    * Precedence (alpha order)
    * Parallelization
  * Database Connections
  * Piped Operations: Batching, Alerting, Advanced Logging ... 

![discriptive diagram of how VCLODs works](/VCLODs.png)  

### VCLODs Piped Operation Elements

Extensions | Type |Extra File ^1 | Description
-----------|------|--------------|------------
sh| Producer ^2 |0| Source a ksh script
py| Producer or Consumer |optional| Run either stdin or file as python3
shebang| Producer |0| Respect script's shebang
sql| Producer |0| Run a SQL script with default connection
dst| Producer |0| Run a SQL script with the secondary connection
diff| Consumer ^3 |1| diff stdout:file
email| Consumer |0| email stdout to SUPPORT_EMAIL. Errors still go to OPERATIONS_EMAIL
err| Consumer |0| Everything is an error
out| Consumer |1| Write to file; stop
outa| Consumer |1| Append to file; stop
add| Pipe ^4 |1| Prepend stdin with file
awk| Pipe |1| run stdout through awk file
batch ^5| Pipe |0| aggregate input to batch statement
end| Pipe |1| Postpend stdin with file
etl| Pipe |1| Preform advanced ETL operations. More below
jq| Pipe |1| Run stdin through the jq utility to parse JSON
tee| Pipe |1| Route output to file and continue
dir| Redirct ^6 |1| Run a subdirectory where the last directory name holds the .extension on how to process the files (the files may not have .extensions
g| Redirct |1| Guard another extension (like in g-jq) so that its output is saved on error
vfs| Redirect |0| pipes stdin through fifos and then runs any number of commands. Helps with large composite programs if it is easier to put them all in one file. Also useful for when using stdin to run a oneoff script

1. Extra File means the extension can use an extension option (`<extension>-<filename>`) as either input (diff), code, or output. filename defaults to the basename of the script. The directory the extra is in defaults to the same directory as the script, but often can be overridden. py allows the extra file to have an extension if it is in a different directory, otherwise, the extra file may not have its own extension or it will be run as if it was a VCLODScript
1. Producers can also consume pipes, but they don't need to
1. Consumers require a Producer. `out` and `outa` end pipes; other Consumers can be Producers
1. Pipes requires a Producer AND Consumer
1. See .batch commands below
1. Redirect indicates an extension that pipes to another extention in some way

### .batch Commands:

Command | default if start exists | description
--------|-------------------------|------------
#batch | 1000 | Number of lines to put in each batch
#start | | Start of statement (like INSERT INTO .... VALUES )
#sep | ',' | how to separate lines
#end | ';' | how to end lines
#del_start | | if desired, the start of a delete statement to be used in archiving data
#del_sep | ',' | delete statement separator
#del_end | ');' | delete statement end
#RESET | | reset to start state so you can start a new batch in the same pipe

### .etl Commands:
Commands applied to a field in the Temp table create statement. These Commands (and the CREATE TEMPORARY TABLE statement they are attached to) must be in and extension option file. Stdin into the .etl extension must be a the VALUES part of the computed INSERT statement (the fields in the order of the CREATE TEMPORARY TABLE statement that exclusively `#ingest`, `#unique`, or `#map` commands attached to them). Fields may have multiple commands attached to them. `.etl` should always be followed by `.batch` unless you just want to test (ie, `do.sql.batch.etl-file.sh`)
Command | Requires preceding field ^1 | no_update Option? ^2| Positional Args ^3 | Description
--------|-----------------------------|---------------------|--------------------|------------
#ingest |Y|N|N| force this field to be ingested in the initial INSERT INTO tmp table
#ignore |Y|N|N| Do not ingest this field into the initial temp table.
#key |Y|N|Std| The auto_incrementing Primary key that will be used to sync deep FK chains. Will not be ingested, but rather derived after syncing with the destination table
#unique |Y|Y|Std| Unique fields candidate keys on the table. If there is no UNIQUE index, you can spoof the behavior with #unique_no_update. Does not need to be unique in the temp table (useful for deep FK chains)
#map |Y|Y|Std| A regular field on the given table. 
#generate |N|Y|Std + SQL statement| generate a field that is not in the temp table. The SQL statements that follow the field name are used instead of a column name in the temp table when doing the ETL into the destination table.
#include |YN|N|local SQL filename| include a sql script file (with no .extension) to handle any additional reformatting or processing that is required. 
#sync |N|Y|Destination Table + More ^4 | Command to sync the temp table with the destination table. Order between #sync and #include commands indicates execution order

1. If Y, add the command after the temp table field definition. If N, then put it on its own line as a stand alone command. If YN (ie for `#include`), if the command is on a temp table field line, it acts as both `#include` AND `#ignore`.
1. on_update means the field will not be updated when it changes (ie, will not be in the ON DUPLICATE KEY UPDATE list). It is annotated by updating the command name, for instance `#sync` becomes `#sync_no_update`.
1. N means there are no Positional Arguments after the command. Std means the standard ones are required (destination table name followed by the destiniation field name -- spaces not allowed).
1. #sync extra options are either `SET_NOT_PRESENT` followed by whatever you would put in an UPDATE SET clause for any rows that are not in the temp table followed by an optional WHERE clause to indicate additional cohort constraints, or `DELETE_NOT_PRESENT` followed by an optional WHERE clause that acts the same way. (In the SET version, the WHERE is a requied delimiter; in the DELETE version, the WHERE keyword may not be present.)

### .vfs Commands:
Only 1 Positional Argument is used. everything else is a comment
Command | Argument | Description
--------|----------|------------
#fifo | filename | creates a fifo (a virtual file) in the INPUT_DIR (ie, where the file we are processing lives, or pwd if that is stdin) and pipes everything after this line into that file (until it reaches another command)
#run | vitual vclod filename | runs everything from the start of stream to the first .vfs command through vclod_operation. The vitural filename here can then use the fifo files as extesion arguments

# VCLODs Detailed How it Works
## Configuration
There is a global config file to make life easier (`/etc/vclods`), then each directory has its own configs to fine tune what all the scripts in a given directory will do

## Locking
Each script file automatically locks out redundant execution (or allows up to `VCLOD_BATCH_JOBS` number of instances to run).

## Operation
Based on the file extension list, different operations can be assigned. If the extension is `.sh` then it is sourced as a ksh script. If the extension is `.sql` then it is passed as sql to the primary sql connection. Extensions are recursively applied, so `.dst.sql` will run sql on the primary database connection, then pipe the output into the secondary database connection, effectively making it a metasql script.

## Destination
Log output (anything in stdout at pipe's end) can go to 5 locations: 
Control | Where | Description
--------|-------|------------
Always | log files | in $LOG_BASE_DIR and $VCLOD_ERR_DIR
Always | syslog | This can be pulled in by systems like graylog and datadog
Conditional | email | stderr goes to email ($OPERATIONS_EMAIL) for alerting
Optional | stdout | if you are manually running the script in a terminal
Optional | post process script | As defined in $LOG_POST_PROCESS. The provided post process script (vclod_pp_log2sql) logs to SQL for relational querying

## What is the Strategy?
* Accomidating lazy Database Programmers ;)
* Prioriting work done over copy paste boilerplate

## What are the Objections?
* Unnecessary!! I don't need this brain pain!!
  * Copy and paste is always an option. As well as re-debugging
  * Since you have to run shell anyways, make it do the common, critical tasks so that you dont have to re-implement then every time you add a new language to your tech stack
  
* ksh < python3
  * ok, so use python inside VCLODs. Productionization is free
  * Shell scripting is the universal languge

## Pseudocode Examples: Note `.` is shorthand for `|` so VCLODScript names are self descriptive
* For more examples, look in this repo's test directory. Output is compared to `test/expected`
* script.sh: run a script in directory context (VCLODs handles Timing, Configuration, Locking, Logging, ...)
* script.sql.sh: script.sh except it spits out SQL to avoid connection call
* script.sh.sql: a query generates a shell script (usually curl)
* script.sh.tee-file.sql: script.sh.sql except shell commands go to file for analysis
* script.err.diff-file.\*: run something, compare output with file, and if diff treat as error + send email
* script.dst.sql: run a query on primary connection that generates a query for secondary connection (data migration)
* script.sql.tee-file.batch.sql: run a query, batch the output, stash batched statements into a file for auditing, run generated batch statements

## Example Crontab
Specify when you want which directories to run and then everything in them run

    44 4 1 1 *   /usr/local/bin/vclod /vclod/yearly/
    15 2 1 * *   /usr/local/bin/vclod /vclod/monthly/
    7  1 * * Sun /usr/local/bin/vclod /vclod/weekly/
    7  1 * * Fri /usr/local/bin/vclod /vclod/fridays/
    7  1 * * Wed /usr/local/bin/vclod /vclod/wednesdays/
    3  6 * * *   DEBUG_SHOULD_TIME_IT=1 VCLOD_JOBS=5 /usr/local/bin/vclod /vclod/nightly/
    30  4 * * *   DEBUG_SHOULD_TIME_IT=1 VCLOD_JOBS=2 /usr/local/bin/vclod /vclod/0430_nightly/
    6 0,8-23/2 * * * /usr/local/bin/vclod /vclod/bihourly/
    22 * * * *   /usr/local/bin/vclod /vclod/hourly/
    *  * * * *   /usr/local/bin/vclod /vclod/minutely/

## Example Directory Structure
    /vclod/nightly/
    /vclod/nightly/config
    /vclod/nightly/script1.sh
    /vclod/nightly/server_database/
    /vclod/nightly/server_database/config: configures `VCLOD_HOST`/`VCLOD_DB`
    /vclod/nightly/server_database/script2.sql
    /vclod/nightly/server_database/script3.dst.sql
    ...

# Testing

First setup the `./test/secure_config` file to have the right mysql permissions.
`./run_test.sh` - confirms that the proper log files are generated with the right contents; checks syslog; check post_process log2sql; prints all output to the terminal
`./run_test.sh | cat` - does the same thing, but with no output except on test error
