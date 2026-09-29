select
    c.claim_line_id,
    c.encounter_id,
    c.provider_id,
    c.service_date,
    c.allowed_amount,
    c.paid_amount,
    c.cpt_code,
    case when c.encounter_id is null then 'NULL_ENCOUNTER'
         when e.encounter_id is null then 'ORPHAN_ENCOUNTER'
         else 'ATTRIBUTED' end as attribution_status
from {{ ref('stg_claim_lines') }} c
left join {{ ref('dim_encounter') }} e
    on c.encounter_id = e.encounter_id
