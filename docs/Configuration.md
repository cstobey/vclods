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
Name | Scope | Defaults
-----|-------|---------
ADD_EXT_DIR|Extensions: add end|$INPUT_DIR
CONFIG_ENV_PATH|Script|/etc
CONFIG_FILE|Script|${CONFIG_ENV_PATH:-/etc}/vclods
DIR_EXT_DIR|Extensions: dir|$INPUT_DIR
ETL_EXT_DIR|Extensions: etl|$INPUT_DIR
EXTRA_ERROR_EMAIL|Post Process|
JQ_EXT_DIR|Extensions: jq|$INPUT_DIR
JQ_EXT_OPT|Extensions: jq|
LF_OVERRIDE|Post Process|
LOCK_NAME|Script|${1:?Missing a lock name}
LOG_BASE_DIR|Global|
LOG_FILE|Script|${1:?Missing a log file name}
LOG_FILE_OVERRIDE|Post Process|
LOG_POST_PROCESS|Post Process|
LOG_SQL_DB|Post Process|
LOG_SQL_ENGINE|Post Process|$LOG_ENGINE
LOG_SQL_HOST|Post Process|
LOG_SQL_PASSWORD|Post Process|$LOG_PW
LOG_SQL_USER|Post Process|$LOG_USER
MY_LOCK|Script|$LOCK_FILE
OPERATIONS_EMAIL|Global|
OUT_EXT_DIR|Extensions: out outa|$INPUT_DIR
PY_EXT_DIR|Extensions: py|$INPUT_DIR
RM_ERR_FILE|Script|1
SH_EXT_DIR|Extensions: sh|$INPUT_DIR
SLACK_API_URL|Post Process|
SLACK_CHANNEL|Post Process|vclod_errors
SLACK_EMOJI|Post Process|:robot_face:
SUPPORT_EMAIL|Extensions: email|$OPERATIONS_EMAIL
SUPPORT_SUBJECT|Extensions: email|${base_filename//_/ }
TEE_EXT_DIR|Extensions: tee teea|$INPUT_DIR
VCLOD_BATCH_JOBS|Script|1
VCLOD_DIR_CONTEXT|Extensions: dir|
VCLOD_DIR_START|Extensions: dir|
VCLOD_ENGINE|Script|mysql
VCLOD_ERR_DIR|Script|
VCLOD_FORCE_SETUP_SQL|Script|0
VCLOD_JOBS|Global|10
VCLOD_LOCK_DIR|Script|
