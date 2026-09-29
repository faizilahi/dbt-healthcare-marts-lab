-- Only attributed claims — inner join enforces dim presence
select
    e.encounter_id,
    e.facility_id,
    e.los_hours,
    count(*) as claim_line_count,
    sum(c.allowed_amount) as allowed_amount,
    sum(c.paid_amount) as paid_amount
from {{ ref('fct_claim_lines') }} c
inner join {{ ref('dim_encounter') }} e
    on c.encounter_id = e.encounter_id
where c.attribution_status = 'ATTRIBUTED'
group by 1, 2, 3
