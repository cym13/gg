#!/bin/bash

HELP="gg - A good grep wrapper

Usage: gg [OPTION]... PATTERN...

Options:
    -h          Print this help and exits
    -p PATH     Add path to search path list
                Default is current directory
    -e EXPR     Select by name, find -iname expression
    -E EXT      Select by extension, similar to  -e \"*.EXT\"
    -r EXPR     Select by regex on the whole path (grep style)
    -v EXPR     Exclude expr from search path list
    -V EXT      Exclude files with extension EXT from search path list
    -c          Be case sensitive in path search
    --          End of gg options
                Everything after that is either a grep option or expression

Arguments:
    PATTERN     Any legal set of grep arguments"

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

next_find_expr() {
    if [ -n "$FIND_EXPR" ] ; then
        FIND_EXPR="$FIND_EXPR -o $1"
    else
        FIND_EXPR="$1"
    fi
}

while [ $# -gt 0 ] ; do
    case "$1" in
        -h)
            echo "$HELP"
            exit 0
        ;;
        -p)
            shift
            PATH_LIST="$PATH_LIST $1"
        ;;
        -e)
            shift

            if [ -z "$IGNORE_CASE" ] ; then
                next_find_expr "-name $1"
            else
                next_find_expr "-iname $1"
            fi
        ;;
        -E)
            shift

            if [ -z "$IGNORE_CASE" ] ; then
                next_find_expr "-name *.$1"
            else
                next_find_expr "-iname *.$1"
            fi
        ;;
        -r)
            shift

            next_find_expr "-regextype grep -regex $1"
        ;;
        -v)
            shift
            EXCLUDE_PATH_LIST="$EXCLUDE_PATH_LIST -e $1"
        ;;
        -V)
            shift
            EXCLUDE_PATH_LIST="$EXCLUDE_PATH_LIST -e \.$1\$"
        ;;
        -c)
            IGNORE_CASE=""
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

if [ -z "$EXCLUDE_PATH_LIST" ] ; then
    EXCLUDE_PATH_LIST="^$"
fi

if [ $# -eq 0 ] ; then
    echo "$HELP"
    exit 1
fi

set -f
find $PATH_LIST -type f \( $FIND_EXPR \) -print0 \
    | grep -FzZ -v $IGNORE_CASE $EXCLUDE_PATH_LIST \
    | xargs -0 grep --color $NUMBER "$@" /dev/null
