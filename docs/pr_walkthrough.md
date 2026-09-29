# PR walkthrough — relationship test failure and fix

## Failing test (before)

```
Failure in test relationships_fct_claim_lines_encounter_id__encounter_id__ref_dim_encounter_
  Got 142 results, configured to fail if != 0

select *
from (
  select f.encounter_id
  from fct_claim_lines f
  left join dim_encounter d on f.encounter_id = d.encounter_id
  where d.encounter_id is null
) orphans
```

Root cause: staging coalesced nulls to `'UNKNOWN'`; dim had no such key.

## After fix

- Staging preserves SQL NULL for missing encounter_id.
- Relationship test uses `config.where: encounter_id is not null`.
- Audit model lists null-encounter claims for source follow-up.
- `mart_paid_by_encounter` inner-joins dim — paid totals match finance control for attributed claims.
