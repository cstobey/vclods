# .awk Extension Details and Commands

Collections are groups of functions as references the Includes Scope in the Variables documentation and in the functions defined below.
Collection | Description
-----------|------------
std|A standard library for awk

The available functions are described below (Arguments may not be known):

Collection | Function Name | Arguments | Description
-----------|---------------|-----------|------------
std|cc_ws|value, sep, new|concat with separator, ignore empty on either side
std|cc_if|value, cond, true_str, false_str|concat if: prepend value to the right str
std|if_or|v, d|defaults empty v to d
std|pre_if|pre, v|if v: pre + v
std|tail2||$0 - 1 head value
std|tail3||$0 - 2 head values
std|tail4||$0 - 3 head values
std|tail5||$0 - 4 head values
std|tail6||$0 - 5 head values
std|tail7||$0 - 6 head values
std|tail8||$0 - 7 head values
std|tail9||$0 - 8 head values
std|tail10||$0 - 9 head values
std|p|value|print if not empty
std|ext|msg|exit script with an error; need to add "if (should_exit) {exit 1;}" to the begining of any END
