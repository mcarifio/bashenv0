'''
Helper functions for pip.
'''
import semver
__self__ = dict(author='Mike Carifio', email='mike@carif.io',version=semver.VersionInfo.parse('0.1.1'))

from typing import List
import pip

def pipi(pkgs:str)->int:
    """
    Install list of packages specified as a string delimited with spaces, e.g. '
    :param pkgs:
    :return:
    """
    return pipil(pkgs.split())

def pipil(pkgs:List[str])->int:
    '''
    Install (or upgrade if already installed) a list of packages using python pip.
    @usage: from piputil import pipil; pipil('
    :param pkgs:
    :return:
    '''
    return pip.main(['install', '--upgrade'] + pkgs)

def pipipip()->int():
    '''Upgrade pip itself. Does not currently work.'''
    return pip.main('install --upgrade pip'.split())