Description
===========

gg - A good grep wrapper

gg is inspired by ag to prove that giving a good way to select on which files
you want to grep was giving as good (and actually in many cases) performances
as using ag while being more precise than its politics to avoid what's in the
gitignore.

By default gg is *not* case-sensitive for the path part of the search but is
with the in-file one for this behaviour seemed to match what I most often
need.

A big part of gg's speed is that it doesn't by default look into the
top-directories hidden files and directories as those files are often hidden
for a good reason. Overriding this behaviour is easy:

::

    $ gg -p . <other arguments and options>

Documentation
=============

::

    Usage: gg [OPTION]... PATTERN...

    Options:
        -h          Print this help and exits
        -p PATH     Add path to search path list
                    Default is current directory
        -e EXPR     Select by name, find -iname expression
        -E EXT      Select by extension, similar to  -e "*.EXT"
        -r EXPR     Select by regex on the whole path (grep style)
        -v EXPR     Exclude expr from search path list
        -V EXT      Exclude files with extension EXT from search path list
        -c          Be case sensitive in path search
        --          End of gg options
                    Eveything after that is either a grep option or expression

    Arguments:
        PATTERN     Any legal set of grep arguments

On performances
===============

Experience shows that ag is generaly faster on naive tests whith no file
selection. This is partly due to our using lots of useless processes.  But
when selection must occur on big codebase (more than 100,000 files) gg proved
to be almost always faster even with only little selection.

Examples:
=========

::

    # Search for the system() function in C or C++ files and all python tests
    $ gg -e "test_*.py" -E c -E cpp -E h -E hpp 'system('

    # Search for either pony or cat in all files that aren't css ones
    $ gg -V css -- -e pony -e cat

    # Search for Main class in all java files that aren't test or xml related
    $ gg -E java -v Test -v XML "class Main"

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
