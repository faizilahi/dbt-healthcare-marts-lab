select
    c.provider_id,
    p.specialty,
    count(*) as claim_line_count,
    sum(c.allowed_amount) as allowed_amount,
    sum(c.paid_amount) as paid_amount
from {{ ref('fct_claim_lines') }} c
inner join {{ ref('dim_provider') }} p
    on c.provider_id = p.provider_id
where c.attribution_status = 'ATTRIBUTED'
group by 1, 2
