## 2023-10-24 - Exposing Orphaned UI Settings
**Learning:** Some localization (.lang) files contain fully documented strings and tooltips for options that are missing from the configuration property trees (.properties). Users effectively lose access to these options in the interface, reducing usability and control over the experience.
**Action:** Always cross-reference options specified in localization strings with the structural definitions of menus to ensure that all valid settings are exposed (by replacing placeholder spacers in layout grids) and available to the user.
