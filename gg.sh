#!/bin/bash

HELP="gg - A good grep wrapper

Usage: gg [OPTION]... PATTERN...

Options:
    -h, --help              Print this help and exits
    --version               Print version information and exits
    -p, --path PATH         Add path to search path list
                            Default is current directory
    -e, --expr EXPR         Select by name, find -iname expression
    -E, --ext EXT           Select by extension, similar to  -e \"*.EXT\"
    -r, --regex EXPR        Select by regex on the whole path (grep style)
    -v, --exclude EXPR      Exclude expr from search path list
    -V, --exclude-ext EXPR  Exclude files with extension EXT from search
                            path list
    -c, --case-sensitive    Be case sensitive in path search
    -H, --include-hidden    Include hidden files and directories
    --                      End of gg options
                            Everything after that is either a grep option
                            or expression

Arguments:
    PATTERN     Any legal set of grep arguments"

VERSION=1.0

# Oh come on!
if [ "${0##*/}" = pony ] ; then
    HELP=`sed 's/\(\W\)\w\{4\}\(\W\)/\1PONY\2/g;s/PONY  /PONY! /g' <<< "$HELP"`
fi

if [ $# -eq 0 ] ; then
    echo "$HELP"
    exit 1
fi

NUMBER=""
IGNORE_CASE="-i"

FIND_EXPR=""
PATH_LIST=""
EXCLUDE_PATH_LIST=""
IGNORE_HIDDEN_FILES=true

next_find_expr() {
    if [ -n "$FIND_EXPR" ] ; then
        FIND_EXPR="$FIND_EXPR -o $1"
    else
        FIND_EXPR="$1"
    fi
}

while [ $# -gt 0 ] ; do
    case "$1" in
        -h) ;& --help)
            echo "$HELP"
            exit 0
            ;;
        --version)
            echo "gg v$VERSION"
            exit 0
            ;;
        -p) ;& --path)
            shift
            PATH_LIST="$PATH_LIST $1"
            ;;
        -e) ;& --expr)
            shift
            if [ -z "$IGNORE_CASE" ] ; then
                next_find_expr "-name $1"
            else
                next_find_expr "-iname $1"
            fi
            ;;
        -E) ;& --ext)
            shift
            if [ -z "$IGNORE_CASE" ] ; then
                next_find_expr "-name *.$1"
            else
                next_find_expr "-iname *.$1"
            fi
            ;;
        -r) ;& --regex)
            shift
            next_find_expr "-regextype grep -regex $1"
            ;;
        -v) ;& --exclude)
            shift
            EXCLUDE_PATH_LIST="$EXCLUDE_PATH_LIST -e $1"
            ;;
        -V) ;& --exclude-ext)
            shift
            EXCLUDE_PATH_LIST="$EXCLUDE_PATH_LIST -e \.$1\$"
            ;;
        -c) ;& --case-sensitive)
            IGNORE_CASE=""
            ;;
        -H) ;& --include-hidden)
            IGNORE_HIDDEN_FILES=false
            ;;
        --)
            shift
            break
            ;;
        *)
            break
            ;;
    esac
    shift
done

if [ -z "$PATH_LIST" ] ; then
    PATH_LIST=`find . -maxdepth 1 -name '[^.]\*'`
fi

if $IGNORE_HIDDEN_FILES ; then
    EXCLUDE_PATH_LIST="$EXCLUDE_PATH_LIST \(\/\|^\)\.[^/]"
fi

if [ -z "$EXCLUDE_PATH_LIST" ] ; then
    EXCLUDE_PATH_LIST="^$"
fi

if [ $# -eq 0 ] ; then
    echo "$HELP"
    exit 1
fi

set -f
find $PATH_LIST -type f \( -true $FIND_EXPR \) -print0 \
    | grep -zZ -v $IGNORE_CASE $EXCLUDE_PATH_LIST \
    | xargs -0 grep --color $NUMBER "$@" /dev/null
