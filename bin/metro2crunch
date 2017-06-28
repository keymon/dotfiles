#!/bin/bash

IFS=','
read
echo "date,description,amount,balance"
tr -d '\r' | while read date reference transaction_type money_in money_out balance; do
    if [ -n "$date" ]; then
        echo "$date,$reference,$(awk "BEGIN { printf(\"%.2f\", $money_in - $money_out) } "),$balance"
    fi
done
