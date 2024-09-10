# Dependencies -- Where What External Programs are Used
## Scope
Name | Used by:
-----|----------
Global | the whole directory. Only Editable in the Global config file
Script | a single script
Connections | used in .sql and .dst as defaults
Includes | Used at the script level or inside the .sh extension [See more](/docs/sh.md)
Extensions | the given dot extensions
Post | log processing after the script has run

Name | Scope | Note
-----|-------|-----
awk|Extensions: awk batch dir etl litsh sh slack<br />Includes: locking vcurl<br />Post: slack_errors|
basename|Script<br />Includes: locking operations|
cat|Gobal<br />Extensions: add dir dst email end env err etl g litsh null out outa py shard shebang slack sql vfs while wrap<br />Includes: connections operations vcurl<br />Post: slack_errors|
curl|Extensions: slack<br />Includes: vcurl<br />Post: slack_errors|
diff|Extensions: diff|# the default for .diff, can be overridden to, say, comm.
dirname|Gobal<br />Script|
env|Script<br />Extensions: env|
envsubst|Extensions: dst sql<br />Includes: connections|
find|Gobal<br />Extensions: dir py<br />Includes: locking|
grep|Script<br />Connections: mssql<br />Extensions: etl shebang vfs while<br />Includes: vcurl|
head|Extensions: py shebang<br />Includes: vcurl|
jq|Extensions: jq slack<br />Post: slack_errors|
ksh|Gobal<br />Extensions: shebang<br />Post: log2sql|
mail|Gobal<br />Extensions: email<br />Post: extra_error_email|
mkfifo|Gobal<br />Extensions: para vfs|
mktemp|Gobal<br />Extensions: email etl g shard shebang slack split vfs while<br />Includes: vcurl|
mysql|Connections: mysql<br />Includes: connections|# the Include connection is because mysql is the default.
psql|Connections: postgres|
python3|Extensions: py|
readlink|Gobal|
sed|Script<br />Connections: mssql<br />Extensions: etl vfs<br />Includes: trap vcurl<br />Post: log2sql|
sh|Script<br />Extensions: env para shard split while|
sleep|Extensions: shard<br />Includes: vcurl|
sort|Gobal<br />Extensions: dir py|
sqlcmd|Connections: mssql|
sshpass|Connections: mysql|
stat|Includes: locking|
stdbuf|Gobal<br />Script<br />Extensions: para while|
sync|Script<br />Extensions: etl<br />Includes: operations|
tee|Extensions: g tee teea|
which|Gobal|
