# .sh Extension Details and Commands

Collections are groups of functions as references the Includes Scope in the Variables documentation and in the functions defined below.
Collection | Description
-----------|------------
autogit|Helper functions that manage a git repo. Using .sh, cd into the git repo, run autogit_pull, make your changes, and then run autogit_push.
configuration|Helper functions for configuration management
connections|Internal Connection handling functions used by .sql and .dst. Do not use directly.
literate_source|envsubst only does variable substitution<br />heredocs and quotes do variable substitution/expansion and process substitution<br />source (.) does the above and treats everything else as code too.<br />This targets heredoc-level substitutions to complete the set of quoting options.<br />The name comes from language systems that invert comments and code for executable blog posts (ie, like Literate Haskell)
locking|Ensures that at most N parallel batch jobs run for a particular lock/script. Processes beyond N abort (rather than blocking). <br />Each script is atuomatically locked with its own name and inode (or absolute path when there are symlinks).<br />virtual files and given lock names are used without modification.  
operations|Handles the recursive extension handling that is core to the Operations part of VCLODs.<br />By using this collection, you can create custom flow patterns.
trap|Helper functions to manage the trap, especially for temporary files (ie, after calling mktemp). 
vcurl|Helper functions that make interacting with cURL much easier. Automatically collects header information. Helper files:<br />$VCURL_LAST_FULL_OUT: file with headers and body from the last vcurl run<br />$VCURL_LAST_ERROR: file with the error output if any from the last vcurl run<br />$VCURL_LAST_HEADER: file with the headers from the last vcurl run<br />$VCURL_LAST_OUTPUT: file with the body from the last vcurl run

The available functions are described below (Arguments may not be known):

Collection | Function Name | Arguments | Description
-----------|---------------|-----------|------------
autogit|autogit_pull||git pull, but handles local changes gracefully.
autogit|autogit_push||git add, commit, and push to some number of origins. $1 is the commit message. Any additional positional arguments are origin names (defaults to origin).
configuration|vclod_load_local_config||loads or reloads the local config file, maintaining any O_* overrides. 
literate_source|literate_source||Allows heredoc-level substitutions for any string either through stdin or as a function argument.
locking|get_semaphore_lock||Get a lock. First argument is the lock basename.
operations|vclod_operation||Within the current VCLODScript's context, process a custom defined VCLODScript. stdin acts as a VCLODScript's file contents; $1 like the filename with extensions.
trap|pre_exit_trap||adds the given command to the beginning of the exit trap
trap|post_exit_trap||adds the given command to the end of the exit trap
trap|add_file_cleanup||Cleans up the given file(s) when the current script or subshell exits.
vcurl|urlen||url encode a string from stdin
vcurl|vcurl_get_header_value||takes a HTTP header key name and returns its value from the last vcurl call.
vcurl|vcurl_get_http_status_code||gets the 3 digit HTTP status code
vcurl|vcurl_run||run curl with the provided url and arguments (make sure to quote arguments with spaces). Always uses -LisS arguments.<br />If HTTP 429 Too Many Requests is received, then it will retry up to $VCURL_RECURSION_LIMIT times and the requested delay is <4 hours.
vcurl|vcurl_while||Keep curling until there is no longer a URL to curl.<br />$1 is a function that returns then next URL (additional parameters each on their own line of output);<br />the optional rest of the input variables are the inital URL and curl arguments (remember to quote arguments).
vcurl|vcurl_multi_run||Proces stdin where each line is the URL and curl arguments of vcurl_run.
