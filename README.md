# VCLODs
## What are VCLODs?
* A directory based script-running ksh framework, to make daemonized programs from simple scripts

## How does it work?
* 300 ksh lines that provide...
* Modularizing simple scripts/programs to automate ~95% of the boilerplate needed to productionize
  * Configuration,
  * Locking, 
  * Logging, 
  * Timing, 
  * Database Connections, and
  * Piped Operations: Batching, Alerting, Advanced Logging, ... 
  
VCLODs Piped Operation Elements

Extension | Start | Must Pipe | Extra File | Description
----------|-------|-----------|------------|------------
awk|0|1|1| run stdout through awk file
batch|0|1|0| aggregate input to batch statement
diff|0|0|1| diff stdout:file
dst|1|0|0| Run A SQL script with DST connection
err|0|0|0| Everything is an error
out|0|0|1| Write to file; stop
outa|0|0|1| Append to file; stop
py|1|0|optional| Run either stdin or file as python3
sh|1|0|0| Source a ksh script
shebang|1|0|0| Respect script's shebang
sql|1|0|0| Run a SQL script with SRC connection
tee|0|0|1| Route output to file and continue

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

#### End Point Extensions
The last extension must be in this list or the root script will ignore it.
* sql: uses the default sql connection
* dst: uses the DST sql connection (or secondary connection)
* sh: runs as a shell script
* py: runs a python3 file

#### Middle Extensions
Used to reformat date between end points
* batch: batch rows based on the rules of `./vclod_batcher`. TODO: write up how this works.
* awk-*: run an arbitrary awk script with the name substituted by *. Note that said file may not have an extension.
* py-*: runs an arbitrary python3 script with name substituted by *. Note that said file may not have an extension unless you override PY_EXT_OPT with a non-VCLODS dir file where the python script lives.

#### Final Extensions
Generally for testing output.
* diff: diff the output of the data stream so far with a file that is named the same as the current file's basename (ie, without any extensions)
* err: route stdout to stderr. Used to treat all output from the script as an error. Useful when you never expect the given script to do anything, but if it does, treat it like an error.

### Destination
Log output is standardized. Anything going to stdout is put in log files (in the directory of your choosing), in syslog, and optionally post-processed (I have helpfully provided a postprocess script that inserts logs into a mysql database for later analytics).

# Testing

First setup the `./test/config` file to have the right mysql permissions. Do not commit said credentials, though those belong in `/etc/vclods.cnf`
`./run_test.sh` - confirms that the proper log files are generated with the right contents; checks syslog; outputs the contents of the log files and syslog for visual comparison
`./run_test.sh | cat` - does the same thing, but with no output except on test error
