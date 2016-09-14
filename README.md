# VCLODs
Variable Configuration Locking Operation Destination Scripts ksh Framework

This is a directory based script running framework that automates much of the boilerplate of making server side daemons and scripts. 

### Variable 
Most aspects of the system are customizable. 

### Configuration 
There is a global config file to make life easier, then each directory has its own configs to fine tune what all the scripts in a given directory will do

### Locking
Each script file automatically locks out redundant execution (or allows up to `VCLOD_BATCH_JOBS` number of instance to run). 

### Operation
Based on the file extension list, different operations can be assigned. If the extention is `.sh` then it is sourced as a ksh script. If the extension is `.sql` then it is passed as sql to the primary sql connection. Extensions are recursively applied, so `.dst.sql` will run sql on the primary mysql connection, then pipe the output into the secondary mysql connection, effectively making it a metasql script. 

TODO: list all extension types from vclod_run_script

### Destination 
Log output is standardized. Anything going to stdout is put in log files (in the directory of your chosing), in syslog, and optionally postprocessed (I have helpfully provided a postprocess system that inserts logs into a mysql database for later analytics). 

# Testing

`./test/test_vclod_framework.sh` - confirms that the proper log files are generated with the right contents. outputs the contents of the log files and syslog for visual comparison
`./test/test_vclod_framework.sh | cat` - does the same thing, but with no output
