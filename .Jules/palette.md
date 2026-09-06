## 2026-09-06 - Expose unmapped sliders
**Learning:** Variables defined in `sliders=` and implemented in GLSL are often missing from `shaders.properties` screen definitions, hiding them from the user interface.
**Action:** When cross-referencing UI options, always check `sliders=` for defined options and ensure they are mapped to a screen, replacing `<empty>` layout tokens where appropriate to maintain intended layout.
