# Staging conventions used in this PR

1. Never invent dimension keys (`UNKNOWN`, `N/A`, `-1`) in staging.
2. `nullif(trim(col), '')` for string natural keys from CSV seeds.
3. Attribution status is derived on the fact, not forced in staging.
4. Orphans land in `stg_claim_lines__orphan_encounters` for source tickets — they do not silently pass relationship tests.
