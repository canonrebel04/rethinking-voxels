import unittest
import os
import subprocess
import tempfile
import shutil

class TestDefaultsFromSettings(unittest.TestCase):
    def setUp(self):
        self.test_dir = tempfile.mkdtemp()
        self.script_path = os.path.abspath("shaders/lib/materials/defaultsFromSettings.py")

    def tearDown(self):
        shutil.rmtree(self.test_dir)

    def test_missing_args(self):
        result = subprocess.run(
            ["python3", self.script_path],
            cwd=self.test_dir,
            capture_output=True,
            text=True
        )
        self.assertIn("Usage:", result.stdout)

    def test_update_shader_file(self):
        shader_file = os.path.join(self.test_dir, "test.glsl")
        with open(shader_file, "w") as f:
            f.write("/* Some comments */\n")
            f.write("#define SOME_VAR 100\n")
            f.write("//#define SOME_BOOL\n")
            f.write("#define FALSE_BOOL\n")

        settings_file = os.path.join(self.test_dir, "settings.txt")
        with open(settings_file, "w") as f:
            f.write("SOME_VAR=200\n")
            f.write("SOME_BOOL=true\n")
            f.write("FALSE_BOOL=false\n")

        result = subprocess.run(
            ["python3", self.script_path, "-s", settings_file, shader_file],
            cwd=self.test_dir,
            capture_output=True,
            text=True
        )

        new_shader_file = os.path.join(self.test_dir, "test_newdefaults.glsl")
        self.assertTrue(os.path.exists(new_shader_file))

        with open(new_shader_file, "r") as f:
            content = f.read()

        self.assertIn("#define SOME_VAR 200", content)
        self.assertIn("#define SOME_BOOL", content)
        self.assertNotIn("//#define SOME_BOOL", content)
        self.assertIn("//#define FALSE_BOOL", content)

    def test_walkdir_directory_traversal(self):
        os.makedirs(os.path.join(self.test_dir, "dir_a"))
        os.makedirs(os.path.join(self.test_dir, "dir_b"))
        with open(os.path.join(self.test_dir, "dir_a", "file_a.glsl"), "w") as f:
            f.write("#define A 1\n")
        with open(os.path.join(self.test_dir, "dir_b", "file_b.glsl"), "w") as f:
            f.write("#define B 1\n")

        settings_file = os.path.join(self.test_dir, "settings.txt")
        with open(settings_file, "w") as f:
            f.write("A=2\n")

        result = subprocess.run(
            ["python3", self.script_path, "-s", "settings.txt"],
            cwd=self.test_dir,
            capture_output=True,
            text=True
        )

        self.assertNotIn("IndexError", result.stderr)

        new_file_a = os.path.join(self.test_dir, "dir_a", "file_a_newdefaults.glsl")
        self.assertTrue(os.path.exists(new_file_a))

if __name__ == '__main__':
    unittest.main()
