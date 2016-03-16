#!/bin/sh

HELP="gg - A good grep wrapper

Usage: gg [OPTION]... PATTERN...

Options:
    -h          Print this help and exits
    -p PATH     Add path to search path list
                Default is current directory
    -e EXPR     Select by name (find -name style)
    -v EXPR     Exclude expr from search path list
    -n          Display line numbers
    --          End of gg options
                Eveything after that is either a grep option or expression

Arguments:
    PATTERN     Any legal set of grep arguments"

NUMBER=""
PATH_LIST=""
EXPR_LIST=""
INAME_LIST=""
SELECT_PATH_LIST=""
EXCLUDE_PATH_LIST=""

while [ $# -gt 0 ] ; do
    case "$1" in
        -h)
            echo "$HELP"
            exit 0
        ;;
        -p)
            shift
            PATH_LIST="${PATH_LIST} '$1' "
        ;;
        -e)
            shift
            INAME_LIST="-iname $1 "
        ;;
        -v)
            shift
            EXCLUDE_PATH_LIST="${EXCLUDE_PATH_LIST}-e $1 "
        ;;
        -n)
            COLOR="--line-number"
        ;;
        --)
            EXPR_LIST="${EXPR_LIST}${@} "
            break
        ;;
        *)
            EXPR_LIST="${EXPR_LIST}-e $1 "
        ;;
    esac
    shift
done

if [ -z "$PATH_LIST" ] ; then
    PATH_LIST="*"
fi

if [ -z "$EXCLUDE_PATH_LIST" ] ; then
    EXCLUDE_PATH_LIST="-e 'TH1S SH0LDNT_mATch ANYTHING'"
fi

if [ -z "$EXPR_LIST" ] ; then
    echo "$HELP"
    exit 1
fi

find $PATH_LIST -type f $INAME_LIST \
    | grep -v $EXCLUDE_PATH_LIST \
    | xargs -d '\n' grep --color $NUMBER $COLOR $EXPR_LIST
