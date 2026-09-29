with source as (
    select * from {{ ref('raw_encounters') }}
)
select
    trim(encounter_id) as encounter_id,
    trim(patient_token) as patient_token,
    cast(admit_ts as timestamp) as admit_ts,
    cast(discharge_ts as timestamp) as discharge_ts,
    trim(facility_id) as facility_id
from source
where encounter_id is not null
