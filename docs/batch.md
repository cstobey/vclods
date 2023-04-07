# .batch Extension Details and Commands

Breaks up the stream into sections delimited by the #RESET command. All commands are scoped to the current section. 
Command | default if start exists | description
--|--|--
#RESET | | reset to start state so you can start a new batch in the same pipe
#batch | 1000 | Number of lines to put in each batch
#start | | Start of statement (like INSERT INTO .... VALUES )
#sep | ',' | how to separate lines
#end | ';' | how to end lines
#del_start | | if desired, the start of a delete statement to be used in archiving data
#del_sep | ',' | delete statement separator
#del_end | ');' | delete statement end

If #start is present, then batching is used for the current section. If #del_start is present, then the first word of each line is batched into the secondary batch statement defined by the del_ commands and emitted after the main query. This allows you to do something (like DELETE based on an id field) after the main query succeeds.
