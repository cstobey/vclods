# Configuration -- Enviornment Variables
## Scope
Name | Used by: 
-----|----------
Global | the whole directory. Only Editable in the Global config file
Script | a single script
Extension | the given dot extensions
Post Process | log processing after the script has run

NOTE: Setting the variable in the config file must be of the form `VAR_NAME=...` otherwise it will not be exported. Enviornment Variables given on the command line will be overridden by config files unless the variable is defined in the form `VAR_NAME=${VAR_NAME:=value to set}` (or left to the default). 

## Recognized Variables
Here is an automated listing of all Enviornment Variables, their Scopes and Default Values. `$INPUT_DIR` is the Local directory of the script.
Name | Scope | Defaults | Description
-----|-------|----------|------------
ADD_EXT_DIR|Extensions: add end wrap|$INPUT_DIR|directory to find files.
ADD_EXT_FILE|Extensions: add end wrap|$base_filename|the filename. Overridden by ext_opt.
AWK_EXT_DIR|Extensions: awk|$INPUT_DIR|directory to find awk files.
AWK_EXT_FILE|Extensions: awk|$base_filename|filename of awk file to run. Overridden by ext_opt.
CONFIG_ENV_PATH|Script|/etc|
CONFIG_FILE|Script|${CONFIG_ENV_PATH:-/etc}/vclods|
CURL_EXT_JQ_PAGE_PROG|Extensions: curl||The jq program to use for batching
CURL_EXT_NUMB_PAGES|Extensions: curl|1|Used to force how many batchs to use when not using jq (like for date based batches)
CURL_EXT_OPT|Extensions: curl|-sSf|cURL options as seen in the man page.
CURL_EXT_URL|Extensions: curl||The URL to call, uses literate_source to qualify variables. $CURL_EXT_LOOP_CNT is the default variable used for batching
DEBUG_SHOULD_TIME_IT|Script|$IS_TERMINAL|1 prints [START] and [END] log lines at the begining and end of the extension pipe; 0 does not
DIFF_EXT_CMD|Extensions: diff|diff -w|what diff program to use (maybe try comm -13)
DIFF_EXT_DIR|Extensions: diff|$INPUT_DIR|What directory to look for "static"
DIFF_EXT_FILE|Extensions: diff|${ext_opt:-$base_filename}|What to use as the "static" file. defaults to self if the base_filename of either ext_opt or self doesn't exist.
DIFF_EXT_OPERATION|Extensions: diff|$ext_opt|vclod_operation to optionally process "static" file
DIR_ERR_SHOULD_EXIT|Extensions: dir|1|1 means halt on error, 0 means continue even if there are errors
DIR_EXT_CONTEXT|Extensions: dir||Any information you want displayed on error
DIR_EXT_DIR|Extensions: dir|$INPUT_DIR|Directory to look for subscripts
DIR_EXT_START|Extensions: dir|$base_filename|Begining regex to find subscripts. Overridden by ext_opt
DST|Extensions: dst|VCLOD_DST_|Overrides the connection naming prefix.
DST_EXT_IGNORE_NO_CONNECT|Extensions: dst|0|if 0, connection errors break the pipe, else, test the connection first and silently continue without outputting anything.
EMAIL_EXT_FILE|Extensions: email|$(mktemp)|Absolute path of filename to put stdin into before sending it. Deleted after use.
EMAIL_EXT_INLINE_REPORT|Extensions: email|0|1 inlines the extension pipe into the email body; 0 sends it as an attachment
EMAIL_EXT_MSG_BODY|Extensions: email|Report attached containing $REPORT_ROWS entries|If sending as an attachment, This defines the body of the email pre-literate_source
EMAIL_EXT_SUBJECT|Extensions: email|${base_filename//_/ }|
ETL_EXT_DIR|Extensions: etl|$INPUT_DIR|Directory to look for .etl temp table definition files
ETL_EXT_FILE|Extensions: etl|$base_filename|temp table definition filename.
EXTRA_ERROR_EMAIL|Post Process||must have an email to send to
HEREDOC_DELIMITER|Extensions: litsh|MSG|If multiple literate_source layers deep, use this to override the heredoc delimiter
JQ_EXT_DIR|Extensions: jq|$INPUT_DIR|What directory to look for ext_opt jq programs in.
JQ_EXT_OPT|Extensions: jq||jq command options, generally -cMr
JQ_EXT_PROG|Extensions: jq||if not using ext_opt, the jq program to use, simplest is '.'
LF_OVERRIDE|Post Process||Only use these if you know what you are doing
LITSH_EXT_BATCH_SIZE|Extensions: litsh|100|Number of rows to process at a time... NOTE: each line should be standalone.
LOCK_NAME|Script|${1:?Missing a lock name}|Only override if you want multiple scripts to lock each other out and you know what you are doing
LOG_BASE_DIR|Global||Where to store log files (will also store error output)
LOG_FILE|Script|${1:?Missing a log file name}|If you really want to give the logs a special name, you can use this, but it is not recommended
LOG_FILE_OVERRIDE|Post Process||Only use these if you know what you are doing
LOG_POST_PROCESS|Post Process||it must exist to run it
LOG_SQL_DB|Post Process||Defines log2sql Post Processing db connection. Needs pp_log2sql_table.sql tables loaded.
LOG_SQL_ENGINE|Post Process|$LOG_ENGINE|Defines log2sql Post Processing db connection. Needs pp_log2sql_table.sql tables loaded.
LOG_SQL_HOST|Post Process||Defines log2sql Post Processing db connection. Needs pp_log2sql_table.sql tables loaded.
LOG_SQL_PASSWORD|Post Process|$LOG_PW|Defines log2sql Post Processing db connection. Needs pp_log2sql_table.sql tables loaded.
LOG_SQL_USER|Post Process|$LOG_USER|Defines log2sql Post Processing db connection. Needs pp_log2sql_table.sql tables loaded.
MSSQL_CONN_OPT|Post Process|additional MSSQL options you want to specify
OPERATIONS_EMAIL|Global||Email address list to send error output to
OUT_EXT_DIR|Extensions: out outa|$INPUT_DIR|Directory to put program output
OUT_EXT_FILE|Extensions: out outa|$base_filename|the filename. Overridden by ext_opt.
OUT_EXT_FILE_SHARD|Extensions: out outa|$(date +%F)|A way to save and distinguish between different runs
PY_EXT_DIR|Extensions: py|$INPUT_DIR|directory to look for python files. If not a VCLOD directory, then they can have the normal .py ending.
RM_ERR_FILE|Script|1|1 will detele error files after they post processing; 0 will leave them around. The default is recommended since Error files are redundant
SHARD_EXT_COUNT|Extensions: shard||the number of times to loop
SHARD_EXT_OPERATION|Extensions: shard|${ext_opt:-sh}|what vclod_operation to use to process stdin
SHARD_EXT_SLEEP_INTERVAL|Extensions: shard|0|positive integer if you want to to sleep some between backgrounded process invocations. -1 to run in series. 0 to run in series. Anything else will be treated as a shell command (so you can choose to sleep based on some dynamic criteria).
SH_EXT_DIR|Extensions: sh|$INPUT_DIR|Directory to look for files referenced by ext_opt
SLACK_API_URL|Extensions: slack slack_errors||must have an endpoint to send the logs to -- same one that errors use
SLACK_CHANNEL|Post Process|vclod_errors|Thus this only works if the bot is configured for multichannel use
SLACK_EMOJI|Post Process|:robot_face:|Give it some style ;)
SLACK_EXT_CHANNEL|Extensions: slack|vclod_logs|Thus this only works if the bot is configured for multichannel use
SLACK_EXT_EMOJI|Extensions: slack|:robot_face:|Give it some style ;)
SPLIT_EXT_COUNT|Extensions: split|10000|how many lines to process in each batch
SPLIT_EXT_OPERATION|Extensions: split|${ext_opt:-sh}|what vclod_operation to use to process stdin
SQL_EXT_IGNORE_NO_CONNECT|Extensions: sql|0|if 0, connection errors break the pipe, else, test the connection first and silently continue without outputting anything.
SRC|Extensions: sql|VCLOD_SRC_|Overrides the connection naming prefix.
SUPPORT_EMAIL|Extensions: email|$OPERATIONS_EMAIL|Email address to send to. Errors still go to OPERATIONS_EMAIL
TEE_EXT_DIR|Extensions: tee teea|$INPUT_DIR|Directory to put program output
TEE_EXT_FILE_SHARD|Extensions: tee teea|$(date +%F)|A way to save and distinguish between different runs
TEE_EXT_OPERATION|Extensions: tee|$ext_opt|vclod_operation to optionally process "static" file. Must not output anything
VCLOD_BATCH_JOBS|Script|1|How many instances of one script can be run at the same time
VCLOD_ENGINE|Script|mysql|
VCLOD_ERR_DIR|Script||Where to store error files (/dev/shm is a good option)
VCLOD_EXIT_ERR|Script|$(basename "$1")|
VCLOD_JOBS|Global|10|How many sripts to run in parallel
VCLOD_LOCK_DIR|Script||Where to put lock files. Generally /dev/shm
WHILE_EXT_OPERATION|Extensions: while|${ext_opt:-sh}|what vclod_operation to use to process stdin
WHILE_EXT_REQUIRE_OUTPUT|Extensions: while|0|if true, operation must return something to stdout to continue running
