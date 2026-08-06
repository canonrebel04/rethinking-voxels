## 2024-05-24 - Optimize Dictionary Lookups in Loop
**Learning:** In tight loops parsing files where values need to be checked multiple times for string conditions, iterating over a dictionary using `.items()` prevents redundant lookup overheads compared to `.keys()`.
**Action:** Always prefer `.items()` unpacking when both the key and the mapped value are required in Python loops.
