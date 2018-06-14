#!/bin/sh

# neleof - no empty line at the end of file detector
#
# Author: Lukasz Lublinski <luklub@o2.pl>
# Last modfication: 2018-06-05
# Version: 1.0.0
#
# Dependencies:
# - GNU Coreutlis
# - GNU Find Utilities
# - Gawk
# - Sed
#
# Changelog:
# v1.1.0 (2018-06-11)
#   - Added "fix" feature.
# v1.0.0 (2018-06-05)
#   - Initial release.
#
# Todo:
# - add ability to fix
# - add detection of multiple empty lines at EOF

VERSION="1.0.0"
SEARCH_PATH="."
EXCLUDE=""
FIX_MODE=false

print_help()
{
    cat <<EOF
neleof - no empty line at the end of file detector

Searches specified path for non-empty text files without empty line at the end.

The POSIX standard definition of line:
   "3.206 Line
    A sequence of zero or more non- <newline> characters plus a terminating <newline> character."
[ http://pubs.opengroup.org/onlinepubs/9699919799/basedefs/V1_chap03.html ]

Why should text files end with a newline?
    "Therefore, lines not ending in a newline character aren't considered actual lines.
    Some programs have problems processing the last line of a file if it isn't newline terminated.
    There's at least one hard advantage to this guideline when working on a terminal emulator: 
    All Unix tools expect this convention and work with it."
[ https://stackoverflow.com/a/729795 ]


Params:
-h      Prints this help.
-v      Prints version.
-e      Exclude paths (comma separated).
-f      Fixes the problem.
[path]  Searches this path. (If omitted, current dir will be used.)


Sample usage:
$0 /home/john_doe
$0 -e "./tmp, ./trash" .
$0 --version


License:
This is free and unencumbered software released into the public domain.

Anyone is free to copy, modify, publish, use, compile, sell, or
distribute this software, either in source code form or as a compiled
binary, for any purpose, commercial or non-commercial, and by any
means.

In jurisdictions that recognize copyright laws, the author or authors
of this software dedicate any and all copyright interest in the
software to the public domain. We make this dedication for the benefit
of the public at large and to the detriment of our heirs and
successors. We intend this dedication to be an overt act of
relinquishment in perpetuity of all present and future rights to this
software under copyright law.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR
OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.

For more information, please refer to <http://unlicense.org>
EOF
}

while getopts "hvfe:" OPT; do
    case "$OPT" in
        h )
            print_help
            exit 0
            ;;
        v )
            echo "$VERSION"
            exit 0
            ;;
        : )
            echo "Required argument for option -$OPTARG not found." 1>&2
            exit 1
            ;;
        \? )
            echo "Invalid Option: -$OPTARG" 1>&2
            exit 1
            ;;
        f )
            FIX_MODE=true
            echo "Fix mode enabled!"
            ;;
        e )
            EXCLUDE="$OPTARG"
            if [ -n "$EXCLUDE" ]; then
                EXCLUDE=$(echo "$OPTARG" | sed -e 's/, /,/g')
                EXCLUDE=$(echo "$EXCLUDE" | sed -e 's/,/\" -o -path \"/g')
                EXCLUDE="\( -path \"""$EXCLUDE\" \)"" -prune -o"
            fi
            ;;
        * )
            echo "Unknown error."
            exit 1
            ;;
    esac
done

shift "$((OPTIND-1))"
[ -n "$1" ] && SEARCH_PATH=${1}

FILES=$(eval "find $SEARCH_PATH $EXCLUDE -type f -size +0 -exec gawk 'ENDFILE{if (\$0 == \"\") print FILENAME}' {} +")
if [ -n "$FILES" ]; then
    FILES_CNT=$(echo "$FILES" | grep -c '^')
    printf "%s\nFound %s files in \"$SEARCH_PATH\" location.\n" "$FILES" "$FILES_CNT"

    if [ "$FIX_MODE" = true ]; then
        for file in "$FILES"; do
            echo "hello" >> file
        done

        echo "Fixed!"
    fi

    exit 1
fi
echo "No files found."
exit 0
