<svg width="250" height="250" xmlns="http://www.w3.org/2000/svg">
 <g>
  <line stroke-width="12" stroke-linecap="undefined" stroke-linejoin="undefined" id="svg_58" y2="140.3273" x2="142.32357" y1="181.3273" x1="176.32357" stroke="#ff5656" fill="none"/>
  <line stroke="#ff5656" stroke-width="12" stroke-linecap="undefined" stroke-linejoin="undefined" id="svg_3" y2="141.82758" x2="105.32521" y1="167.82758" x1="114.32522" fill="none" transform="rotate(-134 109.825 154.828)"/>
  <ellipse stroke-width="6" ry="8" rx="8" id="svg_35" cy="121.66071" cx="125.66472" stroke="#007fff" fill="#007fff"/>
  <line transform="rotate(90 58.1567 92.3277)" stroke="#007fff" stroke-width="12" id="svg_36" y2="105.99407" x2="45.82358" y1="78.6613" x1="70.48985" fill="none"/>
  <line transform="rotate(90 206.321 105.411)" stroke="#007fff" stroke-width="12" id="svg_38" y2="105.41134" x2="228.57064" y1="105.41134" x1="184.07134" fill="none"/>
  <line stroke-width="12" id="svg_39" y2="105.66098" x2="175.98851" y1="105.66098" x1="145.98887" stroke="#007fff" fill="none"/>
  <line stroke="#007fff" stroke-width="12" id="svg_40" y2="105.32764" x2="227.07103" y1="105.32764" x1="184.57168" fill="none"/>
  <line stroke-width="12" id="svg_57" y2="128.1607" x2="79.65631" y1="82.82792" x1="111.65592" stroke="#007fff" fill="none"/>
  <g transform="rotate(75 127.749 120.124)">
   <g>
    <path transform="rotate(20 127.749 120.124)" stroke="#00ffff" fill="#00ffff" d="m43.12047,49.9024c-3.36632,4.17954 -6.48679,8.60493 -9.56944,14.1083c-11.32825,20.14121 -16.11297,42.98682 -14.16504,65.32182c1.91011,21.82437 10.26918,43.17594 25.28525,61.02881c5.3899,6.41115 11.17695,12.06581 17.2666,16.964c21.01116,16.88836 45.91817,25.22852 70.74954,25.00158c24.83137,-0.24586 49.56818,-9.0399 70.23892,-26.43888c6.03291,-5.0684 11.68757,-10.83654 16.85053,-17.2666c12.10364,-15.0539 19.87644,-32.69873 22.8267,-51.32699c2.89353,-18.28784 1.1158,-37.50236 -5.80596,-56.09279c-6.60026,-17.68266 -16.68033,-33.4363 -29.84303,-45.78579c-12.50079,-11.74431 -27.83837,-20.38706 -45.59667,-24.69898c-5.56011,-1.34275 -11.23369,-2.23161 -17.00183,-2.59093c-5.78705,-0.37824 -11.70649,-0.24586 -17.77722,0.41606c-3.8013,0.41606 -6.54353,3.83912 -6.12747,7.64042c0.41606,3.8013 3.83912,6.54353 7.64042,6.12747c5.25752,-0.58627 10.38265,-0.69974 15.39431,-0.37824c5.01166,0.3215 9.89094,1.07798 14.61892,2.2127c15.33758,3.70674 28.55702,11.17695 39.41247,21.35157c11.61193,10.87436 20.51945,24.81246 26.36324,40.52827c6.07073,16.28317 7.64042,33.1148 5.10622,49.09538c-2.59093,16.24535 -9.38032,31.65858 -19.971,44.82128c-4.67125,5.80596 -9.68291,10.9311 -14.95934,15.3754c-18.13654,15.26193 -39.7718,22.978 -61.46378,23.18603c-21.69199,0.20803 -43.49745,-7.11089 -61.95549,-21.95675c-5.48446,-4.40648 -10.62851,-9.41814 -15.3754,-15.07281c-13.08706,-15.54561 -20.36815,-34.21169 -22.05131,-53.33165c-1.72099,-19.61167 2.49638,-39.69615 12.42514,-57.35989c3.007,-5.33317 6.07073,-9.58835 9.47488,-13.69224l1.00233,27.80054c0.13238,3.82021 3.3285,6.8083 7.14871,6.657c3.82021,-0.13238 6.8083,-3.3285 6.657,-7.14871l-1.60751,-44.29175c-0.13238,-3.82021 -3.3285,-6.8083 -7.14871,-6.657c-0.24586,0 -0.4728,0.03782 -0.69974,0.05674l0,0l-42.93009,6.03291c-3.78239,0.52953 -6.43006,4.00933 -5.90052,7.81063c0.52953,3.78239 4.00933,6.43006 7.81063,5.90052l23.67774,-3.34741l0,0z"/>
   </g>
  </g>
  <line stroke="#007fff" stroke-width="12" id="svg_2" y2="125.99406" x2="45.15691" y1="99.99462" x1="67.82318" fill="none"/>
 </g>

</svg>![VCLODs](https://github.com/cstobey/vclods/assets/1664158/87ce9b58-481b-40e9-9b98-d048ae57b5b6)
# VCLODs: Variable Configuration Locking Operation Destination Scripts
## What are VCLODs?
An open-source directory based ksh framework to productionize programs from component scripts using dot extension lists as a functional pipe specification. Especially useful for data pipelines.

## What are the benefits?
* Build from simple scripts
* Encoding Timing and Configuration in script absolute path, allows complex behavior
* Automatic human readable process reporting
* Connections are easy (see the connections/ directory)
  * MySQL/MariaDB, MSSQL, Oracle, and Postgres already implemented
  * InfluxDB, MongoDB, Redis would be easy to add
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

# VCLODs Detailed How it Works
## Variable
The goal is to have everything be tunable. As a Framework, VCLODs trys to be permissive instead of opinionated, allowing for overriding behavior at every level as much as possible. You can even use stdin to simulate a script file (or use .vfs to simulate multiple files) as needed and every Configuration variable can be overridden at the command line by prepending it with `O_`. This allows you to use the same tool for development and one-off scripts that you use for automated daemons.

## Configuration
There is a global config file to make life easier (`/etc/vclods`), then each directory has its own configs to fine tune what all the scripts in a given directory will do. [Here is a list of all the Configuration Variables](/docs/Configuration.md).

## Locking
Each script file automatically locks out redundant execution (or allows up to `VCLOD_BATCH_JOBS` number of instances to run).

## Operation
Based on the file extension list, different operations can be assigned. If the extension is `.sh` then it is sourced as a ksh script. If the extension is `.sql` then it is passed as sql to the primary sql connection. Extensions are recursively applied, so `.dst.sql` will run sql on the primary database connection, then pipe the output into the secondary database connection, effectively making it a metasql script. Some extensions recurse further, letting you specify what amounts to subscripts within their context, for example, `.diff-f+dst.sql` will run a `.sql` script and diff the output to the contents of the `f` file piped through the `.dst` extension. [Here is a list of all the .extension Operations](/docs/Operation.md).

## Destination
Log output (anything in stdout at pipe's end) can go to the following locations: 
Control | Where | Description
--------|-------|------------
Always | log files | in $LOG_BASE_DIR and $VCLOD_ERR_DIR
Always | syslog | This can be pulled in by systems like graylog and datadog
Conditional | stdout | if you are manually running the script in a terminal
Conditional | email | stderr goes to email ($OPERATIONS_EMAIL) for alerting
Optional | Slack | stderr goes to slack when configured for alerting
Optional | SQL database | Use the provided DDL (pp_log2sql_table.sql) to setup the tables, then configure the LOG_DB_ connection to store all logs for relational querying
Optional | post process script | As defined in $LOG_POST_PROCESS

# Sales Pitch
## What is the Strategy?
* Accomidating lazy Database Programmers ;)
* Prioriting work done over copy paste boilerplate
* Adds data pipelining power tools (especially .etl)

## What are the Objections?
* Unnecessary!! I don't need this brain pain!!
  * Copy and paste is always an option, but requires re-debugging
  * Since you have to run shell anyways, make it do the common, critical tasks so that you dont have to re-implement them every time you add a new language to your tech stack
  
* ksh < python3
  * ok, so use python inside VCLODs. Productionization is free
  * Shell scripting is the universal languge

# Examples
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

# Installation

* Docker https://github.com/joshurbain/vclods-docker 
* Raw: clone to /usr/local/bin/vlcods (or whereever, but then need to specify the path later) ; cd vclods ; ./install 

# Testing

First setup the `./test/secure_config` file to have the right mysql permissions.
`./run_test.sh` - confirms that the proper log files are generated with the right contents; checks syslog; check post_process log2sql; prints all output to the terminal
`./run_test.sh | cat` - does the same thing, but with no output except on test error
