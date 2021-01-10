# noqa: E701 E305 E231
import semver
__self__ = dict(author='Mike Carifio', email='mike@carif.io',version=semver.VersionInfo.parse('0.1.1'))



from typing import Callable  # for List[T]
import os
import pathlib

# Callable https://docs.python.org/3/library/typing.html#callable
def is_gitdir(p:pathlib.PurePath)->bool:
    return os.path.isdir(str(p) + os.sep + '.git')


def gitroot(start:str, condition:Callable[[pathlib.PurePath],bool]=is_gitdir)->pathlib.PurePath:
    '''
    Step up the directory path to root (/) starting at directory `start` looking for a .git subdirectory.
    @usage: if _var := gitroot(os.getcwd()): pass # do something here...

    :param start:str, where to start searching as a string pathname (platform specific), e.g. '/you/are/here'
    :param condition:Callable[[pathlib.PurePath], bool], a predicate of one argument returning True or False.
    This condition callback tells you if you've found what you're looking for as you "step up the directory hierarchy".
    In gitroot's case, you're looking for the _first_ directory that has a `.git` subdirectory.

    :return:pathlib.PurePath: Return the found path if `condition` is met, None otherwise.

    Notes:

    * You will rarely pass your own `condition`. But `is_gitdir()` will let you test a pathname for "gitdir-ness" in
    a REPL. This can speed debugging.

    '''

    # TODO mike@carif.io: how do you test this? Does python provide a mocktest for os.path?
    _root = pathlib.Path(os.sep)
    _path = pathlib.Path(start)
    while _path != _root:
        if condition(_path): return _path
        _path = _path.parent
    return None

