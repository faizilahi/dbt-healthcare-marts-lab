-- Audit model: claims that cannot resolve to dim_encounter
select
    c.claim_line_id,
    c.encounter_id,
    c.provider_id,
    c.service_date,
    c.paid_amount,
    case
        when c.encounter_id is null then 'NULL_ENCOUNTER_ID'
        else 'MISSING_FROM_DIM'
    end as orphan_reason
from {{ ref('stg_claim_lines') }} c
left join {{ ref('dim_encounter') }} e
    on c.encounter_id = e.encounter_id
where e.encounter_id is null
