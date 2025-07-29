# Dependencies -- Where What External Programs are Used
## Scope
Name | Used by:
-----|----------
Global | the whole directory. Only Editable in the Global config file
Script | a single script
Connections | used in .sql and .dst as defaults
Includes | Used at the script level or inside the listed extension [See more .sh](/docs/sh.md) [See more .awk](/docs/awk.md)
Extensions | the given dot extensions
Post | log processing after the script has run

Name | Scope | Note
-----|-------|-----
awk|Global<br />Script<br />Extensions: awk batch dir litsh sh slack<br />Includes: etl.sh locking.sh vcurl.sh<br />Post: slack_errors|# really gawk
basename|Script<br />Includes: locking.sh operations.sh|
cat|Global<br />Connections: oracle<br />Extensions: add dir dst email end env err g litsh null out outa py shard shebang slack sql vfs while wrap<br />Includes: connections.sh etl.sh etl_explode.awk operations.sh vcurl.sh<br />Post: slack_errors|
curl|Extensions: slack<br />Includes: vcurl.sh<br />Post: slack_errors|
diff|Extensions: diff<br />Includes: autogit.sh|# the default for .diff, can be overridden to, say, comm. autogit uses git diff.
dirname|Global<br />Script|
env|Script<br />Extensions: env|
envsubst|Extensions: dst sql<br />Includes: connections.sh|
find|Global<br />Extensions: dir py<br />Includes: etl_main.awk locking.sh|
git|Includes: autogit.sh|
grep|Script<br />Connections: mssql<br />Extensions: shebang vfs while<br />Includes: autogit.sh etl.sh vcurl.sh|
head|Extensions: py shebang<br />Includes: vcurl.sh|
jq|Extensions: jq slack<br />Post: slack_errors|
ksh|Global<br />Extensions: shebang<br />Post: log2sql|
mail|Global<br />Extensions: email<br />Post: extra_error_email|
mkfifo|Global<br />Extensions: para vfs|
mktemp|Global<br />Extensions: email g shard shebang slack split vfs while<br />Includes: etl.sh vcurl.sh|
mysql|Connections: mysql<br />Includes: connections.sh|# the Include connection is because mysql is the default.
psql|Connections: postgres|
python3|Extensions: py|
readlink|Global|
sed|Script<br />Connections: mssql oracle<br />Extensions: vfs<br />Includes: etl.sh trap.sh vcurl.sh<br />Post: log2sql|
sh|Global<br />Script<br />Extensions: env para shard split while|
sleep|Script<br />Extensions: shard<br />Includes: vcurl.sh|
sort|Global<br />Extensions: dir py|
sqlcmd|Connections: mssql|
sqlplus|Connections: oracle|
sshpass|Connections: mysql|
stat|Includes: locking.sh|
stdbuf|Global<br />Script<br />Extensions: para while|
sync|Script<br />Extensions: etl<br />Includes: autogit.sh etl.sh etl_main.awk operations.sh|
tee|Extensions: g tee teea|
which|Global|
