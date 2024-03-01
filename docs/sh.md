# .sh Extension Details and Commands

Below are the available functions you can use. The Collection references the Includes Scope in the Variables documentation.
Collection | Function Name | Description
--|--|--
literate_source|literate_source|Allows heredoc-level substitutions for any string either through stdin or as a function argument.
operations|vclod_operation|Within the current VCLODScript's context, process a custom defined VCLODScript. stdin acts as a VCLODScript's file contents; $1 like the filename with extensions.
temp_files|pre_exit_trap|adds the given command to the beginning of the exit trap
temp_files|post_exit_trap|adds the given command to the end of the exit trap
temp_files|add_file_cleanup|Cleans up the given file(s) when the current script or subshell exits.
temp_files|vclod_mktemp|Returns the filename of a created temporary file. Automatically flags the file to be cleaned up upon script or subshell exit.
vcurl|urlen|url encode a string from stdin
vcurl|vcurl_get_header_value|takes a HTTP header key name and returns its value from the last vcurl call. 
vcurl|vcurl_get_http_status_code|gets the 3 digit HTTP status code
vcurl|vcurl_run|run curl with the provided url and arguments. Always uses -fLisS arguments. If HTTP 429 Too Many Requests is received, then it will retry up to $VCURL_RECURSION_LIMIT times
vcurl|vcurl_while|Keep curling until there is no longer a URL to curl. $1 is a function that returns then next URL; the rest of the input varialbes are the inital URL and curl arguments
vcurl|vcurl_multi_run|Proces stdin where each line is the URL and curl arguments of vcurl_run.
