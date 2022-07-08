# Operation -- Dot Extensions
## Location
Name | Description
-----|------------
ANY  | Normal processing. takes stdin (or the contents of the file), does something, and leaves output for the next thing (or logging).
TERM | ends the .extension chain by redirecting stdin somewhere else
PIPE | Pass Through: Must be in the middle of a .extension chain
WRAP | runs another .extension tree as a child

## Option
Many extensions have the abilty to accept one and only one option in the .extension chain. This is signified as `<base_filename>.<other_optional_extensions>.<extension>-<option>.<more_optional_extensions>`. All other behavior modification is handled with Configuration Variables. Options allow 2 of the same extension to be present in the same .extension chain while exhibiting different behavior. Most often, the option value is a file name (due to the nature of the .extension chain, these filenames may not themselves have a .extension). If another file is accepted, the default for the option will be `$base_filename`
## Extensions
Name | Location | Option Default | Description
-----|----------|----------------|------------
add|PIPE|$base_filename|Prepend stdin with file
awk|PIPE|Used, No Default|run stdout through awk file
batch|PIPE|Used, No Default|aggregate input into batch SQL statements
diff|TERM|$base_filename|diff stdout:file
dir|WRAP|${VCLOD_DIR_START:?}|Run a subdirectory where the last directory name holds the .extension on how to process the files (the files may not have .extensions of their own).
dst|ANY|BNArc|Run a SQL script with the secondary connection (called DST)
email|TERM|Not Used|email stdout to SUPPORT_EMAIL. Errors still go to OPERATIONS_EMAIL
end|PIPE|$base_filename|Postpend stdin with file
err|TERM|Not Used|Everything is an error
etl|PIPE|Used, No Default|Preform advanced ETL operations. More below
g|WRAP|Used, No Default|Guard another extension (like in g-jq) so that its output is saved on error
jq|PIPE|Used, No Default|Run stdin through the jq utility to parse JSON
out|TERM|$base_filename|Write to file; stop
outa|TERM|$base_filename|Append to file; stop
py|ANY|Used, No Default|Run either stdin or Option file as python3
sh|ANY|Used, No Default|Source a ksh script
shebang|ANY|Not Used|Respect script's first line shebang (default: source in ksh just like .sh)
sql|ANY|BNArc|Run a SQL script with default connection (called SRC)
tee|PIPE|$base_filename|Route output to file and continue
teea|PIPE|$base_filename|Route output to file (appended) and continue
vfs|WRAP|Not Used|pipes stdin through fifos and then runs any number of commands. Helps with large composite programs if it is easier to put them all in one file. Also useful for when using stdin to run a oneoff script
wrap|PIPE|$base_filename|Wrap stdin with files like .add and .end, but using filenames ending in __beg and __end
