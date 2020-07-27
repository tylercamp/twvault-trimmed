#!/bin/bash

set -e
run_cmd="dotnet run -p $1"

cd TW.Vault.Migration
until dotnet run "$ConnectionStrings__Vault"; do
>&2 echo "Executing migrations"
sleep 1
done
cd ..

>&2 echo "SQL Server is up - starting application"
exec $run_cmd
