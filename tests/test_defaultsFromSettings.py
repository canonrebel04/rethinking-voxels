import sys
import unittest
import subprocess
import os

class TestDefaultsFromSettings(unittest.TestCase):
    def setUp(self):
        self.script_path = os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(__file__))), "shaders", "lib", "materials", "defaultsFromSettings.py")

    def test_missing_settings_file_argument(self):
        # Run the script with -s but no argument
        result = subprocess.run([sys.executable, self.script_path, "-s"], capture_output=True, text=True)

        # Check that it prints the usage string which indicates wrongArgs was True
        self.assertIn("Settings to Defaults script by gri573", result.stdout)
        self.assertIn("Usage:", result.stdout)

    def test_settings_file_starts_with_dash(self):
        # Run the script with -s followed by another flag instead of a file
        result = subprocess.run([sys.executable, self.script_path, "-s", "-i"], capture_output=True, text=True)

        # Check that it prints the usage string which indicates wrongArgs was True
        self.assertIn("Settings to Defaults script by gri573", result.stdout)
        self.assertIn("Usage:", result.stdout)

    def test_missing_suffix_argument(self):
        # Run the script with -a but no argument
        result = subprocess.run([sys.executable, self.script_path, "-s", "dummy.txt", "-a"], capture_output=True, text=True)

        self.assertIn("Settings to Defaults script by gri573", result.stdout)
        self.assertIn("Usage:", result.stdout)

if __name__ == '__main__':
    unittest.main()
