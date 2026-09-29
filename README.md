# PR Writeup: Staging Claim Lines, a Failing Relationship Test, and the Mart Fix on DuckDB

Faiz Elahi — [LinkedIn](https://www.linkedin.com/in/faizilahi) — [pendataco.com](https://pendataco.com) — [GitHub](https://github.com/faizilahi)

Claim, encounter, and provider rows here are generated — not PHI.

> **Engine note:** Models and YAML are dbt Core style. The runnable profile targets **DuckDB** so the PR can be exercised without a Snowflake warehouse. The same model SQL and tests are what you would run under `dbt-snowflake` against a `analytics` database.

## Pull request narrative

**Title:** fix(marts): restore encounter_id grain so fct_claim_lines relationship to dim_encounter passes

**Why:** `dbt test` failed on `relationships` from `fct_claim_lines.encounter_id` → `dim_encounter.encounter_id` after a staging refactor coalesced null encounter ids to `'UNKNOWN'`. Downstream paid-amount marts inflated and the relationship test correctly blocked merge.

### What staging looked like before

`stg_claim_lines` did:

```sql
coalesce(encounter_id, 'UNKNOWN') as encounter_id
```

`dim_encounter` never contained `'UNKNOWN'`. One hundred forty-two claim lines pointed at a ghost key. The relationship test failed with 142 orphan rows.

### The fix

1. Keep null `encounter_id` as null in staging (do not invent dimension keys).
2. Add `stg_claim_lines__orphan_encounters` as an audit model materializing orphans for ops.
3. Gate `fct_claim_lines` with `where encounter_id is not null` on the relationship test, plus a singular test that orphan count is tracked but does not silently pass.
4. Rebuild `mart_paid_by_encounter` exclusively from claims that resolve to `dim_encounter`.

## Models in this PR

| Model | Materialization | Job |
|-------|-----------------|-----|
| `stg_claim_lines` | view | Type casts, trim, preserve null encounter_id |
| `stg_encounters` | view | Encounter header from EHR extract |
| `dim_encounter` | table | Encounter dimension |
| `fct_claim_lines` | table | Claim line fact at claim_line_id grain |
| `mart_paid_by_encounter` | table | Paid amount rolled to encounter |
| `stg_claim_lines__orphan_encounters` | table | Audit: claims whose encounter_id is null or missing |

## Run (DuckDB profile)

```powershell
cd dbt-healthcare-marts-lab
python -m venv .venv
.\.venv\Scripts\Activate.ps1
pip install -r requirements.txt
python scripts/seed_synthetic.py
$env:DBT_PROFILES_DIR = (Get-Location).Path
dbt seed --profiles-dir .
dbt run --profiles-dir .
dbt test --profiles-dir .
```

See `docs/pr_walkthrough.md` for the failing test output and the post-fix green run.
