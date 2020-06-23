# VCLODs
## What are VCLODs?
* A directory based ksh framework to make daemonized programs from simple scripts

## What are the benefits?
* Build from simple scripts
* Encoding Timing and Configuration in script absolute path, allows complex behavior
* Automatic human readable process reporting
* Connections are easy - InfluxDB, MongoDB, Redis, MySQL/MaraiDB, MSSQL, Postgres
* Use your own language (shebang) - Javascript/Node, Ruby, Go
* Scripts/programs can focus on their purpose without dealing with their infrastructure
* Fast dev, Fast execution, Dev mobility, Extensibility - Especially for Data tasks
  * ~500 C program lines convert to 14 VCLODs lines
  * At a glance debugging

## How does it work?
* ~300 ksh lines that provide...
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
  
### VCLODs Piped Operation Elements

Extension | Start ^1 | Must Pipe ^2 | Extra File ^3 | Description
----------|-------|-----------|------------|------------
awk|0|1|1| run stdout through awk file
batch ^4|0|1|0| aggregate input to batch statement
diff|0|0|1| diff stdout:file
dst|1|0|0| Run A SQL script with the secondary connection
err|0|0|0| Everything is an error
out|0|0|1| Write to file; stop
outa|0|0|1| Append to file; stop
py|1|0|optional| Run either stdin or file as python3
sh|1|0|0| Source a ksh script
shebang|1|0|0| Respect script's shebang
sql|1|0|0| Run a SQL script with default connection
tee|0|0|1| Route output to file and continue

1. Start denotes extensions that can start the pipe and are placed at the end of the extension chain (extensions are processed right to left). If false, it requries a producer
1. Must Pipe requires a producer AND consumer
1. Extra File means the extension can use an extension option (`<extension>-<filename>`) as either input (diff), code, or output. filename defaults to the basename of the script. The directory the extra is in defaults to the same directory as the script, but often can be overridden. py allows the extra file to have an extension if it is in a different directory, otherwise, the extra file may not have its own extension or it will be run as if it was a VCLODScript
1. batch runs `vclod_batcher`. See vclod_batcher commands below

## What is the Strategy?
* Accomidating lazy Database Programmers ;)
* Prioriting work done over copy paste boilerplate

## What are the Objections?
* Unnecessary!! I don't need this brain pain!!
  * Copy and paste is always an option. As well as re-debugging
  * Since you have to run shell anyways, make it do the common, critical tasks so that you dont have to re-implement then every time you add a new language to your tech stack
  
* ksh < python3
  * ok, so use python inside VCLODs. Daemonization is free
  * Shell scripting is the universal languge



### vclod_batcher commands:

Command | default if start exists | description
--------|-------------------------|------------
#batch | 1000 | Number of lines to put in each batch
#start | | Start of statement (like INSERT INTO .... VALUES )
#sep | ',' | how to separate lines
#end | ';' | how to end lines
#del_start | | if desried, the start of a delete statement to be used in archiving data
#del_sep | ',' | delete statement separator
#del_end | ');' | delete statement end
#RESET | | reset to start state so you can start a new batch in the same pipe



# VCLODs Detailed How it Works
Variable Configuration Locking Operation Destination Scripts ksh Framework

This is a directory based script running framework that automates much of the boilerplate of making server side daemons and scripts.

### Variable
Most aspects of the system are customizable.

### Configuration
There is a global config file to make life easier, then each directory has its own configs to fine tune what all the scripts in a given directory will do

### Locking
Each script file automatically locks out redundant execution (or allows up to `VCLOD_BATCH_JOBS` number of instances to run).

### Operation
Based on the file extension list, different operations can be assigned. If the extension is `.sh` then it is sourced as a ksh script. If the extension is `.sql` then it is passed as sql to the primary sql connection. Extensions are recursively applied, so `.dst.sql` will run sql on the primary database connection, then pipe the output into the secondary database connection, effectively making it a metasql script.

### Destination
Log out (anything that is still in stdin after all the operation pipes) can go to 5 locations: 
* log files (in $LOG_BASE_DIR and $VCLOD_ERR_DIR)
* syslog. This can be pulled in by systems like graylog and datadog
* stderr goes to email ($OPERATIONS_EMAIL) for alerting
* stdout (if you are manually running the script in a terminal)
* Optionally runs a post process script ($LOG_POST_PROCESS). The provided post process script (vclod_pp_log2sql) logs to SQL for relational querying

### Pseudocode Examples
* script.sh: run a script in directory context (VCLODs handles Timing, Configuraion, Locking, Logging, ...)
* script.awk.
* script.err.diff-file.sql: run a query, compare output with file, and if diff treat as error + send email
* script.dst.sql: run a query on primary connection that generates a query for secondary connection
* script.sql.tee-file.batch.sql: run a query, batch the output, stash batched statements into a file for auditing, run generated batch statements

# Testing

First setup the `./test/config` file to have the right mysql permissions. Do not commit said credentials, though those belong in `/etc/vclods.cnf`
`./run_test.sh` - confirms that the proper log files are generated with the right contents; checks syslog; outputs the contents of the log files and syslog for visual comparison
`./run_test.sh | cat` - does the same thing, but with no output except on test error
