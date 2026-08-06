import unittest
from tabstospaces import format_content

class TestTabsToSpaces(unittest.TestCase):
    def test_basic_braces(self):
        input_lines = [
            "void main() {",
            "int x = 5;",
            "if (x > 0) {",
            "x = 0;",
            "}",
            "}"
        ]
        expected_lines = [
            "void main() {",
            "\tint x = 5;",
            "\tif (x > 0) {",
            "\t\tx = 0;",
            "\t}",
            "}"
        ]
        self.assertEqual(format_content(input_lines), expected_lines)

    def test_parentheses(self):
        input_lines = [
            "vec3 compute(",
            "vec3 color,",
            "vec3 normal",
            ") {",
            "return color;",
            "}"
        ]
        expected_lines = [
            "vec3 compute(",
            "\tvec3 color,",
            "\tvec3 normal",
            ") {",
            "\treturn color;",
            "}"
        ]
        self.assertEqual(format_content(input_lines), expected_lines)

    def test_if_directives(self):
        input_lines = [
            "#ifdef GL_FRAGMENT_PRECISION_HIGH",
            "precision highp float;",
            "#endif"
        ]
        expected_lines = [
            "#ifdef GL_FRAGMENT_PRECISION_HIGH",
            "\tprecision highp float;",
            "#endif"
        ]
        self.assertEqual(format_content(input_lines), expected_lines)

    def test_empty_lines(self):
        input_lines = [
            "void main() {",
            "",
            "}"
        ]
        expected_lines = [
            "void main() {",
            "",
            "}"
        ]
        self.assertEqual(format_content(input_lines), expected_lines)

    def test_strip_whitespace(self):
        input_lines = [
            "    void main() {  ",
            "        int x = 5;    ",
            "    }  "
        ]
        expected_lines = [
            "void main() {",
            "\tint x = 5;",
            "}"
        ]
        self.assertEqual(format_content(input_lines), expected_lines)

if __name__ == '__main__':
    unittest.main()
