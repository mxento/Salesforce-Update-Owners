select sf_account_id,  sf_owner_id,  vendor_id
into outfile '/tmp/sf_acct_owners.csv' fields terminated by ',' optionally enclosed by '"' lines terminated by '\n'
from test.export_sf_owners
