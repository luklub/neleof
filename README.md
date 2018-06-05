# neleof #

## This shell script searches specified path for non-empty text files without empty line at the end. ##

**The POSIX standard definition of line:**  
>"3.206 Line  
>A sequence of zero or more non- `<newline>` characters plus a terminating `<newline>` character."

[http://pubs.opengroup.org/onlinepubs/9699919799/basedefs/V1_chap03.html](http://pubs.opengroup.org/onlinepubs/9699919799/basedefs/V1_chap03.html)
  
**Why should text files end with a newline?**  
>"Therefore, lines not ending in a newline character aren't considered actual lines.
>Some programs have problems processing the last line of a file if it isn't newline terminated.
>There's at least one hard advantage to this guideline when working on a terminal emulator:
>All Unix tools expect this convention and work with it."

[https://stackoverflow.com/a/729795](https://stackoverflow.com/a/729795)

**Params:**  
`-h`      Prints this help.  
`-v`      Prints version.  
`-e`      Exclude paths (comma separated).  
`[path]`  Searches this path. (If omitted, current dir will be used.)  
  
**Sample usage:**
```shell
./missing_empty_line_detector.sh /home/john_doe
./missing_empty_line_detector.sh -e "./tmp, ./trash" .
./missing_empty_line_detector.sh --version
```
