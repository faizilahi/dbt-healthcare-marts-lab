select
    attribution_status,
    count(*) as claim_line_count,
    sum(paid_amount) as paid_amount
from {{ ref('fct_claim_lines') }}
group by 1
