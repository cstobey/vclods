# Operation -- Dot Extensions
## Location
Name | Description
-----|------------
ANY  | Normal processing. takes stdin (or the contents of the file), does something, and leaves output for the next thing (or logging).
TERM | Ends the .extension chain by redirecting stdin somewhere else
PIPE | Pass Through: Must be in the middle of a .extension chain
WRAP | Runs another .extension tree as a child
FLOW | Controls the flow of the application, allowing for branches

## Option
Many extensions have the abilty to accept one and only one option in the .extension chain. This is signified as `<base_filename>.<other_optional_extensions>.<extension>-<option>.<more_optional_extensions>`. All other behavior modification is handled with Configuration Variables. Options allow 2 of the same extension to be present in the same .extension chain while exhibiting different behavior. Most often, the option value is a file name (due to the nature of the .extension chain, these filenames may not themselves have a .extension). If another file is accepted, the default for the option will be `$base_filename`
## Extensions
Name | Location | Option Default | Description
-----|----------|----------------|------------
add|PIPE|${ADD_EXT_FILE:=$base_filename}|Prepend a file's contents to the extension pipe
awk|PIPE|${AWK_EXT_FILE:=$base_filename}|Run awk program
batch|PIPE|Used, No Default|aggregate input into batch SQL statements [See more](/docs/batch.md)
curl|ANY|Not Used|cURL wrapper with optional batching using .jq. (be careful, this extension is going to be prone to breakage as I dont think I did it right).
diff|TERM|Used, No Default|diff extension pipe with a "static" file (or generate output based on provided operation)
dir|WRAP|${DIR_EXT_START:=$base_filename}|Runs all scripts in any subdirectory that starts with $DIR_EXT_START where the .extensions are mined from all directory names between $DIR_EXT_DIR and the filename and disallowed on the filename.
dst|ANY|Not Used|Run a SQL script with the secondary connection (configured with VCLOD_DST_)
email|TERM|Not Used|email extension pipe to SUPPORT_EMAIL either as an attachment or inline.
end|PIPE|${ADD_EXT_FILE:=$base_filename}|Postpend a file's contents to the extension pipe
env|ANY|Used, No Default|run an extra config file as the env context for the given operations. ext_opt is of the form `<config_filename>+<operations>`. Each piece may be overridden.
err|TERM|Not Used|Everything to this point is an error. Great for Data tests.
etl|PIPE|${ETL_EXT_FILE:=$base_filename}|Preform advanced ETL operations based on a temp table definition with structured comments. Should be followed by .(sql\|dst).batch. [See more](/docs/etl.md)
g|WRAP|Used, No Default|Guard another extension (like in .g-jq) by saving its inputs on error alongside normal logging
jq|PIPE|$base_filename|Run stdin through the jq utility to parse JSON
litsh|PIPE|$HEREDOC_DELIMITER|literate source: inverts code and comments allowing ksh (ie, process and variable subsitition and expansion) inside prose. Use with caution!
null|TERM|Not Used|dump stdout to /dev/null, effectively silencing output.
out|TERM|${OUT_EXT_FILE:=$base_filename}|Write to file; stop
outa|TERM|${OUT_EXT_FILE:=$base_filename}|Append to file; stop
py|ANY|Used, No Default|Run either stdin or ext_opt file (with any optional ending) as python3
sh|ANY|Used, No Default|Source a ksh script from the pipe or an external file (referenced through ext_opt -- 1 means use the base_filename)
shard|FLOW|sh|Running a stdin with the given operation $SHARD_EXT_COUNT times. Optional run batches in series, sleep a set interval, or go full for parallelity.
shebang|ANY|Not Used|Respect script's first line shebang (default: source in ksh just like .sh)
slack|TERM|${SLACK_EXT_CHANNEL:=vclod_logs}|push stdin to slack channel. Will propogate all data on.
split|FLOW|sh|Split records into batched operations... running the same operation for every $SPLIT_EXT_COUNT rows
sql|ANY|Not Used|Run a SQL script with default connection (configured with VCLOD_SRC_)
tee|PIPE|Used, No Default|Route output to a file or sub_pipe and the remaining extension pipe
teea|PIPE|$base_filename|Route output to file (appended) and the remaining extension pipe
vfs|WRAP|Not Used|virtual file system: use #fifo to generate virtual files and #run to use those files inside a VCLOD context. You can only use each virtual file once per run. Helps with large composite programs with many small files. Especially useful for running oneoff scripts from stdin [See more](/docs/vfs.md)
while|FLOW|sh|Keep running stdin with the given operation until it returns a non-zero exit code (and optionally stops producing output)
wrap|PIPE|${ADD_EXT_FILE:=$base_filename}|Wrap stdin with files like .add and .end, but using filenames ending in __beg and __end
