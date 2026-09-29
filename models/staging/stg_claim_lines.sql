-- Staging: preserve null encounter_id (do NOT coalesce to 'UNKNOWN')
with source as (
    select * from {{ ref('raw_claim_lines') }}
),
typed as (
    select
        claim_line_id,
        nullif(trim(encounter_id), '') as encounter_id,
        trim(provider_id) as provider_id,
        cast(service_date as date) as service_date,
        cast(allowed_amount as decimal(18, 2)) as allowed_amount,
        cast(paid_amount as decimal(18, 2)) as paid_amount,
        trim(cpt_code) as cpt_code
    from source
)
select * from typed
