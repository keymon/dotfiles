#!/usr/bin/env ruby
# Crunch requires a special date format, the balance and a filtered description.
#
#     ./tide2crunch.rb < tide.csv  > crunch.csv
#
# There is a thread requesting the balance in the CSV here[1]
#   https://www.tide.co/community/t/balance-on-csv/1732/7
require "csv"

# Extract the hash of entries
rows = CSV.parse(STDIN.read())
keys = rows[0].map { |x| x.downcase.gsub(' ', '_').to_sym }
entries = rows[1..-1].map do |row|
    Hash[keys.zip(row)]
end

# Enrich it with the accumulated balance and fix some fields like date, description...
balance = 0
entries = entries.reverse.map { |x|
    balance += x[:amount].to_f
    x[:balance] = "%.2f" % balance
    x[:date].gsub!(/(....)-(..)-(..)/, '\3/\2/\1')
    x[:transaction_description].gsub!(/ +/, ' ')
    x
}.reverse

# Print it
puts "date,description,amount,balance"
entries.each { |x|
    puts '%<date>s,"%<transaction_description>s",%<amount>s,%<balance>s' % x
}
