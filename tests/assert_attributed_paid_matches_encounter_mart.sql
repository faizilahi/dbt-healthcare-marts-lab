-- Attributed claim paid total should equal sum of mart_paid_by_encounter
with claim_total as (
    select coalesce(sum(paid_amount), 0) as amt
    from {{ ref('fct_claim_lines') }}
    where attribution_status = 'ATTRIBUTED'
),
mart_total as (
    select coalesce(sum(paid_amount), 0) as amt
    from {{ ref('mart_paid_by_encounter') }}
)
select 1
from claim_total, mart_total
where abs(claim_total.amt - mart_total.amt) > 0.01
