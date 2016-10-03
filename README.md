# VCLODs
Variable Configuration Locking Operation Destination Scripts ksh Framework

This is a directory based script running framework that automates much of the boilerplate of making server side daemons and scripts.

### Variable
Most aspects of the system are customizable.

### Configuration
There is a global config file to make life easier, then each directory has its own configs to fine tune what all the scripts in a given directory will do

### Locking
Each script file automatically locks out redundant execution (or allows up to `VCLOD_BATCH_JOBS` number of instances to run).

### Operation
Based on the file extension list, different operations can be assigned. If the extension is `.sh` then it is sourced as a ksh script. If the extension is `.sql` then it is passed as sql to the primary sql connection. Extensions are recursively applied, so `.dst.sql` will run sql on the primary mysql connection, then pipe the output into the secondary mysql connection, effectively making it a metasql script.

#### End Point Extensions
The last extension must be in this list or the root script will ignore it.
* sql: uses the default sql connection
* dst: uses the DST sql connection (or secondary connection)
* sh: runs as a shell script

#### Middle Extensions
Used to reformat date between end points
* batch: batch rows based on the rules of `./vclod_batcher`. TODO: write up how this works.
* awk-*: run an arbitrary awk script with the name substituted by *. Note that said file may not have an extension.

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
