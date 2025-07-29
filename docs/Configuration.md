# Configuration -- Enviornment Variables
## Scope
Name | Used by:
-----|----------
Global | the whole directory. Only Editable in the Global config file
Script | a single script
Connections | used in .sql and .dst as defaults
Includes | Used at the script level or inside the listed extension [See more .sh](/docs/sh.md) [See more .awk](/docs/awk.md)
Extensions | the given dot extensions
Post | log processing after the script has run

NOTE: Setting the variable in the config file must be of the form `VAR_NAME=...` otherwise it will not be exported. Enviornment Variables given on the command line will be overridden by config files unless the variable is defined in the form `VAR_NAME=${VAR_NAME:=value to set}` (or left to the default).

## Recognized Variables
Here is an automated listing of all Enviornment Variables, their Scopes and Default Values. `$INPUT_DIR` is the Local directory of the script.
Name | Scope | Defaults | Description
-----|-------|----------|------------
ADD_EXT_DIR|Extensions: add end wrap|$INPUT_DIR|directory to find files.
ADD_EXT_FILE|Extensions: add end wrap|$base_filename|the filename. Overridden by ext_opt.
AUTOGIT_BRANCH|Includes: autogit.sh|origin/master|what branch to force when local change conflict with the source.
AWK_EXT_DIR|Extensions: awk|$INPUT_DIR|directory to find awk files.
AWK_EXT_FILE|Extensions: awk|$base_filename|filename of awk file to run. Overridden by ext_opt.
CONFIG_ENV_PATH|Global|/etc|Where to find the global config. Fully Qualified version is $CONFIG_FILE
CONFIG_FILE|Global|${CONFIG_ENV_PATH:-/etc}/vclods|Where to find the global config. Fully Qualified version is $CONFIG_FILE
DEBUG_SHOULD_TIME_IT|Includes: script.sh|$IS_TERMINAL|1 prints [START] and [FINISH] log lines at the begining and end of the extension pipe; 0 does not
DIFF_EXT_CMD|Extensions: diff|diff -w|what diff program to use (maybe try comm -13)
DIFF_EXT_DIR|Extensions: diff|$INPUT_DIR|What directory to look for "static"
DIFF_EXT_FILE|Extensions: diff|${ext_opt:-$base_filename}|What to use as the "static" file. defaults to self if the base_filename of either ext_opt or self doesn't exist.
DIFF_EXT_OPERATION|Extensions: diff|$ext_opt|vclod_operation to optionally process "static" file
DIR_ERR_SHOULD_EXIT|Extensions: dir|1|1 means halt on error, 0 means continue even if there are errors
DIR_EXT_CONTEXT|Extensions: dir||Any information you want displayed on error
DIR_EXT_DIR|Extensions: dir|$INPUT_DIR|Directory to look for subscripts
DIR_EXT_SCRIPT|Extensions: dir|[^./]+|Force only the files with the given name to run (allows you to isolate just a part of the directory)
DIR_EXT_START|Extensions: dir|$base_filename|Begining regex to find subscripts. Overridden by ext_opt
DST|Extensions: dst|VCLOD_DST_|Overrides the connection naming prefix.
DST_EXT_ENVSUBST|Extensions: dst|1|0: Input is sent as a raw query.<br />1: first run input through envsubst before running it as a query
DST_EXT_IGNORE_NO_CONNECT|Extensions: dst|0|0: connection errors break the pipe.<br />1: test the connection first and silently continue without outputting anything.<br />anything else is used as an error message
EMAIL_EXT_FILE|Extensions: email|$(mktemp)|Absolute path of filename to put stdin into before sending it. Deleted after use.
EMAIL_EXT_INLINE_REPORT|Extensions: email|0|1 inlines the extension pipe into the email body;<br />0 sends it as an attachment
EMAIL_EXT_MSG_BODY|Extensions: email|Report attached containing $REPORT_ROWS entries|If sending as an attachment, this defines the body of the email pre-literate_source
EMAIL_EXT_SUBJECT|Extensions: email|${base_filename//_/ }|The subject of the email
ENV_EXT_DIR|Extensions: env|$INPUT_DIR|Directory to look for files referenced by ext_opt
ENV_EXT_FILE|Extensions: env|$base_filename|Filename of env config file to run. Overridden by the first part of ext_opt. If not present, defaults to reimporting the base config
ENV_EXT_OPERATION|Extensions: env|sh|Operations to use of awk file to run. Overridden by all the extensions in ext_opt (everything after a required `+`).
ETL_EXT_DIR|Extensions: etl|$INPUT_DIR|Directory to look for .etl temp table definition files
ETL_EXT_ERR_ON_EMPTY|Extensions: etl|1|If non-zero, error when the input stream is empty.<br />If 1, also emit an error message.
ETL_EXT_FILE|Extensions: etl|$base_filename|temp table definition filename.
ETL_EXT_ROW_REP|Extensions: etl|1|If 1, force ROW based replication.
EXTRA_ERROR_EMAIL|Post: extra_error_email||must have an email to send to
HEREDOC_DELIMITER|Extensions: litsh|MSG|If multiple literate_source layers deep, use this to override the heredoc delimiter
JQ_EXT_DIR|Extensions: jq|$INPUT_DIR|What directory to look for ext_opt jq programs in.
JQ_EXT_OPT|Extensions: jq||jq command options, generally -cMr
JQ_EXT_PROG|Extensions: jq||if not using ext_opt, the jq program to use, simplest is '.'
LITSH_EXT_BATCH_SIZE|Extensions: litsh|100|Number of rows to process at a time... NOTE: each line should be standalone.
LOG_BASE_DIR|Global||Where to store log files (will also store error output)
LOG_POST_PROCESS|Post: external_script||it must exist to run it
LOG_SQL_DB|Post: log2sql||Defines log2sql Post Processing db connection. Needs pp_log2sql_table.sql tables loaded.
LOG_SQL_ENGINE|Post: log2sql|$LOG_ENGINE|Defines log2sql Post Processing db connection. Needs pp_log2sql_table.sql tables loaded.
LOG_SQL_HOST|Post: log2sql||Defines log2sql Post Processing db connection. Needs pp_log2sql_table.sql tables loaded.
LOG_SQL_PASSWORD|Post: log2sql|$LOG_PW|Defines log2sql Post Processing db connection. Needs pp_log2sql_table.sql tables loaded.
LOG_SQL_USER|Post: log2sql|$LOG_USER|Defines log2sql Post Processing db connection. Needs pp_log2sql_table.sql tables loaded.
MSSQL_CONN_OPT|Connections: mssql||Any additional MSSQL options you want to specify
OPERATIONS_EMAIL|Global||Email address list to send error output to
OUT_EXT_DIR|Extensions: out outa|$INPUT_DIR|Directory to put program output
OUT_EXT_FILE|Extensions: out outa|$base_filename|the filename. Overridden by ext_opt.
OUT_EXT_FILE_SHARD|Extensions: out outa|$(date +%F)|A way to save and distinguish between different runs
PARA_EXT_JOBS|Extensions: para|10|number of parallel jobs to run at the same time.
PARA_EXT_OPERATION|Extensions: para|sh-$base_filename|what vclod_operation to use to process a line of stdin
PY_EXT_DIR|Extensions: py|$INPUT_DIR|directory to look for python files. If not a VCLOD directory, then they can have the normal .py ending.
RM_ERR_FILE|Includes: script.sh|1|1 will detele error files after they post processing;<br />0 will leave them around.<br />The default is recommended since Error files are redundant
SHARD_EXT_COUNT|Extensions: shard||the number of times to loop
SHARD_EXT_OPERATION|Extensions: shard|${ext_opt:-sh}|what vclod_operation to use to process stdin
SHARD_EXT_SLEEP_INTERVAL|Extensions: shard|0|positive integer if you want to to sleep some between backgrounded process invocations.<br />-1 to run in series.<br />0 to run in parallel.<br />Any number will sleep that number of seconds between batchs.<br />Anything else will be treated as a shell command (so you can choose to sleep based on some dynamic criteria).
SH_EXT_DIR|Extensions: sh|$INPUT_DIR|Directory to look for files referenced by ext_opt
SLACK_API_URL|Post: slack_errors, Extensions: slack||must have an endpoint to send the logs to -- same one that errors use
SLACK_CHANNEL|Post: slack_errors|vclod_errors|Thus this only works if the bot is configured for multichannel use
SLACK_EMOJI|Post: slack_errors|:robot_face:|Give it some style ;)
SLACK_EXT_CHANNEL|Extensions: slack|vclod_logs|Thus this only works if the bot is configured for multichannel use
SLACK_EXT_EMOJI|Extensions: slack|:robot_face:|Give it some style ;)
SPLIT_EXT_COUNT|Extensions: split|10000|how many lines to process in each batch
SPLIT_EXT_OPERATION|Extensions: split|${ext_opt:-sh}|what vclod_operation to use to process stdin
SQL_EXT_ENVSUBST|Extensions: sql|1|0: Input is sent as a raw query.<br />1: first run input through envsubst before running it as a query
SQL_EXT_IGNORE_NO_CONNECT|Extensions: sql|0|0: connection errors break the pipe.<br />1: test the connection first and silently continue without outputting anything.<br />anything else is used as an error message
SRC|Extensions: sql|VCLOD_SRC_|Overrides the connection naming prefix.
SUPPORT_EMAIL|Extensions: email|$OPERATIONS_EMAIL|Email address to send to. Errors still go to OPERATIONS_EMAIL
TEE_EXT_DIR|Extensions: tee teea|$INPUT_DIR|Directory to put program output
TEE_EXT_FILE_SHARD|Extensions: tee teea|$(date +%F)|A way to save and distinguish between different runs
TEE_EXT_OPERATION|Extensions: tee|$ext_opt|vclod_operation to optionally process "static" file. Must not output anything
VCLOD_BATCH_JOBS|Includes: locking.sh|1|How many instances of one script can be run at the same time
VCLOD_DB|Connections: mssql mysql oracle postgres||Base level default db
VCLOD_ENGINE|Includes: connections.sh|mysql|
VCLOD_ERR_DIR|Global||Where to store error files (/dev/shm is a good option)
VCLOD_EXIT_ERR|Includes: operations.sh|$(basename "$1")|
VCLOD_HOST|Connections: mssql mysql oracle postgres||Base level default host
VCLOD_JOBS|Global|10|How many scripts to run in parallel. Must be at least 1 or nothing will happen.
VCLOD_LOCK_DIR|Global|/dev/shm/|Where to put lock files (and internal fifos). Generally /dev/shm
VCLOD_MSSQL_DB|Connections: mssql|$VCLOD_DB|Default db for mssql connections
VCLOD_MSSQL_HOST|Connections: mssql|$VCLOD_HOST|Default host for mssql connections
VCLOD_MSSQL_PASSWORD|Connections: mssql|$VCLOD_PASSWORD|Default password for mssql connections
VCLOD_MSSQL_USER|Connections: mssql|$VCLOD_USER|Default user for mssql connections
VCLOD_MYSQL_DB|Connections: mysql|$VCLOD_DB|Default db for mysql connections
VCLOD_MYSQL_HOST|Connections: mysql|$VCLOD_HOST|Default host for mysql connections
VCLOD_MYSQL_PASSWORD|Connections: mysql|$VCLOD_PASSWORD|Default password for mysql connections
VCLOD_MYSQL_USER|Connections: mysql|$VCLOD_USER|Default user for mysql connections
VCLOD_ORACLE_DB|Connections: oracle|$VCLOD_DB|Default db for oracle connections
VCLOD_ORACLE_HOST|Connections: oracle|$VCLOD_HOST|Default host for oracle connections
VCLOD_ORACLE_PASSWORD|Connections: oracle|$VCLOD_PASSWORD|Default password for oracle connections
VCLOD_ORACLE_USER|Connections: oracle|$VCLOD_USER|Default user for oracle connections
VCLOD_PASSWORD|Connections: mssql mysql oracle postgres||Base level default password
VCLOD_POSTGRES_DB|Connections: postgres|$VCLOD_DB|Default db for postgres connections
VCLOD_POSTGRES_HOST|Connections: postgres|$VCLOD_HOST|Default host for postgres connections
VCLOD_POSTGRES_PASSWORD|Connections: postgres|$VCLOD_PASSWORD|Default password for postgres connections
VCLOD_POSTGRES_USER|Connections: postgres|$VCLOD_USER|Default user for postgres connections
VCLOD_USER|Connections: mssql mysql oracle postgres||Base level default user
VCURL_OPTIONS|Includes: vcurl.sh||Addtional curl options you want to use every time
VCURL_RECURSION_LIMIT|Includes: vcurl.sh|10|how many times to retry a curl 429 HTTP return code
WHILE_EXT_OPERATION|Extensions: while|${ext_opt:-sh}|what vclod_operation to use to process stdin
WHILE_EXT_REQUIRE_OUTPUT|Extensions: while|0|if true, operation must return something to stdout to continue running
