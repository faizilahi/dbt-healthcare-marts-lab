-- If staging has null encounter_ids, the audit model must surface them
with nulls as (
    select count(*) as n from {{ ref('stg_claim_lines') }} where encounter_id is null
),
audit as (
    select count(*) as n from {{ ref('stg_claim_lines__orphan_encounters') }}
)
select 1
from nulls, audit
where nulls.n > 0 and audit.n = 0
