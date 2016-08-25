echo ------------------------------ start  ------------------------- 
echo -- `date +%Y-%m-%d_%H:%M:%S` -- 

. /home/ubuntu/.gatekeeper


 echo "check validity of rep mapping"
EMAILMESSAGE="/home/ubuntu/salesforce_up/update_rep_region/update_rep_region.log"
EMAILADDRESS="bi-service@yourwebsite.com"

# run mysql audit check of data before uploading to salesforce.
mysql -h${LANNISTER} -u${ETLDBUSER} -p${ETLDBPASS} -e "call salesforce_dw.update_lu_name_sf_id_audit(0)	" > /home/ubuntu/salesforce_up/update_rep_region/rep_region_audit_check.txt

if ( grep "Error" /home/ubuntu/salesforce_up/update_rep_region/rep_region_audit_check.txt )
then
    echo "Rep Assignment Match Issue" `date`
    echo "Rep Assignment Match Issue at" `date` > $EMAILMESSAGE
    echo "---------------------------------------------------- " >>  $EMAILMESSAGE
    cat /home/ubuntu/salesforce_up/update_rep_region/rep_region_audit_check.txt  >> $EMAILMESSAGE
    /usr/bin/mail -s "Rep Assignment Match Issue." $EMAILADDRESS < $EMAILMESSAGE
else
    echo "Sales Rep region Mapping  script completed successfully with no warnings or errors." `date`
fi

cd /home/ubuntu/salesforce_up/update_owners 
echo "updating owners" 
mysql -h${LANNISTER} -u${ETLDBUSER} -p${ETLDBPASS} -e "call salesforce_dw.update_lu_sf_accounts_owners()"


echo "sending to sf "
date1=$(date +"%s")

ruby update_owners.rb sf_acct_owners.csv


date2=$(date +"%s")
diff=$(($date2-$date1))
diffmin=$(($diff / 60))
diffsec=$(($diff % 60))
echo "$diffmin minutes and $diffsec seconds elapsed."
if [ $diffmin -lt 1 ]
then
    echo "time for ruby upload was too quick, it probably did not run properly, exiting now" `date` >> /home/ubuntu/salesforce_up/update_owners/update_owners_error.log
    echo "update_owners finished too quickly, failed at" `date` > $EMAILMESSAGE
    echo " took only $diffmin minutes and $diffsec seconds to complete" >> $EMAILMESSAGE
    /usr/bin/mail -s "Update SF Account Owners Failure" $EMAILADDRESS < $EMAILMESSAGE
    exit 1
else
    echo "ruby upload to salesforce finished at " `date`
fi


echo "cleaning up"
mv sf_acct_owners.csv "`date +%Y%m%d`sf_acct_owners.csv"
mv *.csv old/

# no longer dumping sql files
# mv export_sf_owners.sql "date +%Y%m%dexport_sf_owners.sql"
# mv 20*.sql old/

echo -- `date +%Y-%m-%d_%H:%M:%S` --
echo ------------------------------ end -------------------------
