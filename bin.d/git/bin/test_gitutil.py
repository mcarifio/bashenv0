import pytest
from unittest import TestCase
import gitutil as gu

class Test(TestCase):
    def test_gitroot(self):
        _gr = gu.gitroot('/home/mcarifio/.local/share/bashenv/bin.d/python/bin')
        assert '/home/mcarifio/.local/share/bashenv' == str(_gr)

        assert None == gu.gitroot('/tmp')
        assert None == gu.gitroot('/')
