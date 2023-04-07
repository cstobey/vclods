# .vfs Extension Details and Commands

Only 1 Positional Argument is used. everything else is a comment
Command | Argument | Description
--|--|--
#fifo | filename | creates a fifo (a virtual file) in the INPUT_DIR (ie, where the file we are processing lives, or pwd if that is stdin) and pipes everything after this line into that file (until it reaches another command)
#run | vitual vclod filename | runs everything from the start of stream to the first .vfs command through vclod_operation. The vitural filename here can then use the fifo files as extesion arguments
