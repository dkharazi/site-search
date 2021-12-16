# Copy log contents to temp file
cp /home/dkharazif/typesense-server-data/typesense-server-data.log /home/dkharazif/typesense-server-data/typesense-
server-data-temp.log

# Print last 100 lines to log file
tail -100 /home/dkharazif/typesense-server-data/typesense-server-data-temp.log > /home/dkharazif/typesense-server-d
ata/typesense-server-data.log

# Delete temp file
rm /home/dkharazif/typesense-server-data/typesense-server-data-temp.log

# Print number of lines in file
wc -l /home/dkharazif/typesense-server-data/typesense-server-data.log
