select
    trim(provider_id) as provider_id,
    trim(provider_name) as provider_name,
    trim(specialty) as specialty
from {{ ref('raw_providers') }}
