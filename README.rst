Description
===========

gg - A good grep wrapper

gg is inspired by ag to prove that giving a good way to select on which files
you want to grep was giving as good (and actually in many cases) performances
as using ag while being more precise than its politics to avoid what's in the
gitignore.

Documentation
=============

::

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
        PATTERN     Any legal set of grep arguments

On performances
===============

Experience shows that ag is clearly *clearly* faster on naive tests whith no
file selection. This is partly due to our using lots of useless processes.
But when selection must occur on big codebase (more than 100,000 files) gg
proved to be almost always faster even with only little selection.

Examples:
=========

::

    # Search for the system() function in C files
    $ gg -e '*.[ch]' 'system('

    # Search for either pony or cat in all files that aren't css ones
    $ gg -v '\.css$' pony cat

License
=======

This program is under the GPLv3 License.

You should have received a copy of the GNU General Public License
along with this program. If not, see <http://www.gnu.org/licenses/>.

Contact
=======

::

    Main developper: Cédric Picard
    Email:           cedric.picard@efrei.net
