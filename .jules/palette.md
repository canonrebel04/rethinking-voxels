## 2024-05-23 - Minecraft UI Missing Translations
**Learning:** In Minecraft shaderpacks (Iris/OptiFine), orphaned `.lang` strings or missing entries in `shaders.properties` result in inaccessible options or unformatted technical variable names shown to the user, creating a poor UX. Finding these missing properties and bridging them restores functionality and tooltips.
**Action:** Use regex validation scripts (like python parsers checking properties against .lang) to find misconfigured UI options and expose them correctly.
