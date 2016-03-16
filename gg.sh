#!/bin/bash

HELP="gg - A good grep wrapper

Usage: gg [OPTION]... PATTERN...

Options:
    -h          Print this help and exits
    -p PATH     Add path to search path list
                Default is current directory
    -e EXPR     Select by name, find -iname expression
    -r EXPR     Select by regex on the whole path (grep style)
    -v EXPR     Exclude expr from search path list
    -n          Display line numbers
    --          End of gg options
                Eveything after that is either a grep option or expression

Arguments:
    PATTERN     Any legal set of grep arguments"

if [ $# -eq 0 ] ; then
    echo "$HELP"
    exit 1
fi

NUMBER=""
FIND_EXPR=""
PATH_LIST=""
EXCLUDE_PATH_LIST=""

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
            FIND_EXPR="-iname $1"
        ;;
        -r)
            shift
            FIND_EXPR="-regextype grep -regex $1"
        ;;
        -v)
            shift
            EXCLUDE_PATH_LIST="$EXCLUDE_PATH_LIST -e $1"
        ;;
        -n)
            NUMBER="--line-number"
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
    PATH_LIST="*"
fi

if [ -z "$EXCLUDE_PATH_LIST" ] ; then
    EXCLUDE_PATH_LIST="-e'TH1S SH0LDNT_mATch ANYTHING but the_longer_the_better'"
fi

if [ $# -eq 0 ] ; then
    echo "$HELP"
    exit 1
fi

find $PATH_LIST -type f $FIND_EXPR \
    | grep -v $EXCLUDE_PATH_LIST \
    | xargs -d '\n' grep --color $NUMBER "$@"
