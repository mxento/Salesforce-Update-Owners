require 'salesforce_bulk'
require 'csv'
puts "===== ruby update_owner starting ====="

client = SalesforceBulk::Api.new("[yourmeail_for_salesforce]", "[your api key]")

puts "time start"
puts  Time.now.getutc

records_to_update = Array.new
CSV.foreach("/home/ubuntu/salesforce_up/update_owners/sf_acct_owners.csv") do |row|
  record = { "id" => row[0], "OwnerId" => row[1] || "#N/A" }
  #print row[0]
  records_to_update << record

  if records_to_update.size == 9999
    client.update("Account", records_to_update)
    records_to_update = []
  end
end

if records_to_update.size > 0
  client.update("Account", records_to_update)
end


puts "time ended"
puts  Time.now.getutc
