select
    encounter_id,
    patient_token,
    admit_ts,
    discharge_ts,
    facility_id,
    date_diff('hour', admit_ts, discharge_ts) as los_hours
from {{ ref('stg_encounters') }}
