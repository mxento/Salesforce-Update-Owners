**This is simple mysql dump to csv and using Salesforce API to upload**

**Environment**: Ubuntu linux  
**Database**: MySql  
**Languages** used: Ruby, Bash Shell, SQL, and salesforce API  

**dump_data_from_mysql_to_csv.sql** : simple example of dumping  
**update_owners.rb** : ruby script with salesfore interaction  
**update_owners.sh**: shell script to process upload and update and verify data.   

step 0) make sure you have the right fields and mapping and api key in ruby file   
step 1) dump your owner_id to new owner_id into csv  
step 2) ./update_owners.sh or ruby bundle exec update_owners.rb   

note there's quite of bit of configuration before this script will work. Ned to add keys, change paths, etc, nodify variables  