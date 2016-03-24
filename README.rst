========================
gg - A good grep wrapper
========================

Description
===========

`gg` is inspired by `ack` and `ag`. I've been told over and over that they are
faster than grep and I wanted to prove that giving a good way to select on
which files you want to grep was giving as good (and actually in many cases
better) performances as using `ack` or `ag`.

Doing so also is more precise than `ag`'s politics to avoid what's in the
gitignore for I often want to search in files that are in the gitignore. When
I port a codebase from one language to another for example I generally copy
the original files to gradually convert them. Those files are in my gitignore
because I don't want them to be tr`ack`ed but they clearly are search-worthy.

`gg` isn't built to solve the exact same problem as `ag` and `ack` though. While
both allow for quick search in files in a development oriented environment `ag`
and `ack` and designed toward use from a text editor. `gg` isn't and exists
because I find that different environments call for different tools. I can't
see a reason not to use `ack` or `ag` in an editor, but I can't think of a reason
to use them instead of `gg` from the command-line either.

By default `gg` is *not* case-sensitive for the path part of the search but is
with the in-file one for this behaviour seemed to match what I most often
need.

A big part of `gg`'s speed is that it doesn't by default look into the
top-directories hidden files and directories as those files are often hidden
for a good reason. Overriding this behaviour is easy:

::

    $ gg -p . <other arguments and options>

Documentation
=============

::

    Usage: gg [OPTION]... PATTERN...

    Options:
        -h, --help              Print this help and exits
        -p, --path PATH         Add path to search path list
                                Default is current directory
        -e, --expr EXPR         Select by name, find -iname expression
        -E, --ext EXT           Select by extension, similar to  -e "*.EXT"
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
        PATTERN     Any legal set of grep arguments

On performances
===============

Experience shows that `ag` is generaly faster on naive tests whith no file
selection. This is partly due to our using lots of useless processes. But
when selection must occur on big codebase (more than 100,000 files) `gg` proved
to be almost always faster even with only little selection.

The difference in speed compared to `ack` or `ag` can be explained by the fact
that:

- We mostly use the same strategies:
    - look only in interesting files
    - use multiple processes (with pipelining in the case of `gg`)

- `gg` doesn't display line numbers by default
    and counting lines before hits takes time

- `gg` makes it easier to restrict the files to search in
      by making the user explicitely list files of interest and proposing
      regex-based selection.

- `gg` is built on grep,
      and GNU grep is awesome_.

.. _awesome: https://lists.freebsd.org/pipermail/freebsd-current/2010-August/019310.html

Examples:
=========

- I want a reccursive cat-finding grep! (Short answer: use grep)

::

    $ gg cat

- But I really wanted was a find! (Short answer: use find)

::

    $ gg -l '^$'

- Search for the system() function in C or C++ files and all python tests

::

    $ gg -e "test_*.py" -E c -E cpp -E h -E hpp 'system('

- Search for either pony or cat in all files that aren't css ones

::

    $ gg -V css -- -e pony -e cat

- Search for Main class in all java files that aren't test or xml related

::

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
