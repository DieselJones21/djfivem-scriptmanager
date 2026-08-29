import os
import sys
import unittest

sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..'))

from tools.generate_license import DEFAULT_SECRET, make_key, verify


class LicenseTests(unittest.TestCase):
    def test_known_vector(self):
        self.assertTrue(verify(DEFAULT_SECRET, 'DJSM-A7F3-C91B-CF54-1C80', '*'))

    def test_roundtrip(self):
        key = make_key(DEFAULT_SECRET, '*')
        self.assertTrue(verify(DEFAULT_SECRET, key, '*'))
        self.assertFalse(verify(DEFAULT_SECRET, key, 'other-server'))

    def test_garbage(self):
        self.assertFalse(verify(DEFAULT_SECRET, 'nope', '*'))
        self.assertFalse(verify(DEFAULT_SECRET, 'DJSM-AAAA-BBBB-CCCC-DDDD', '*'))


if __name__ == '__main__':
    unittest.main()
