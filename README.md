# ubuntu-mac-ip-randomizer
A script to randomize the IP and MAC.
# Overview
The Bash script periodically randomizes the IP and MAC addresses on Ubuntu, and saves the original IP and MAC addresses to a restore_network.sh script for easy restoration. The script generates a new MAC address and IP address and sets them on the eth0 interface. The new IP address is checked to ensure that it is not already in use before being set. If the restore_network.sh script already exists, the script does not save the original IP and MAC addresses to it. Instead, it uses the saved IP and MAC addresses to restore the network configuration.

# Prerequisites
Ubuntu based OS
Basic knowledge of the command line interface (CLI)
ip command

# Installation
Open a terminal on your Ubuntu machine.

# Create a new file called randomize_network.sh using the following command:


touch randomize_network.sh

Open the randomize_network.sh file in a text editor of your choice, and copy and paste the following code:
bash
Copy code

    #!/bin/bash

RESTORE_NETWORK_FILE=restore_network.sh

# Save the original MAC and IP addresses in restore_network.sh if it doesn't exist
    if [ ! -f "$RESTORE_NETWORK_FILE" ]; then
        CURRENT_MAC=$(cat /sys/class/net/eth0/address)
        CURRENT_IP=$(ip addr show dev eth0 | awk '/inet / {print $2}' | cut -d'/' -f1)

        echo "CURRENT_MAC=$CURRENT_MAC" > $RESTORE_NETWORK_FILE
        echo "CURRENT_IP=$CURRENT_IP" >> $RESTORE_NETWORK_FILE
    fi

# Generate a random MAC address

  `` NEW_MAC=$(printf '52:54:%02x:%02x:%02x:%02x\n' $((RANDOM%256)) $((RANDOM%256)) $((RANDOM%256)) $((RANDOM%256)))``

# Generate a new IP address
`NEW_IP="192.168.$((RANDOM % 256)).$((RANDOM % 256))"
`
# Check if the new IP address is already in use
``ping -c 1 $NEW_IP > /dev/null
while [ $? -eq 0 ]; do
  # If the new IP address is in use, generate a new one and check again
  NEW_IP="192.168.$((RANDOM % 256)).$((RANDOM % 256))"
  ping -c 1 $NEW_IP > /dev/null
done``

# Set the new MAC address
``sudo ip link set dev eth0 down
sudo ip link set dev eth0 address $NEW_MAC
sudo ip link set dev eth0 up``

# Set the new IP address
``sudo ip addr add $NEW_IP/24 dev eth0``

# Make the script executable
``chmod +x $RESTORE_NETWORK_FILE

echo "New MAC address: $NEW_MAC"
echo "New IP address: $NEW_IP"``

Save and close the file.

Make the script executable using the following command:

bash
Copy code
`chmod +x randomize_network.sh`

# Usage
To run the script, open a terminal and navigate to the directory where you saved the randomize_network.sh file. Then, execute the following command:

bash
Copy code
`sudo ./randomize_network.sh`

The script will generate a new MAC address and IP address and set them on the eth0 interface. The new IP address is checked to ensure that it is not already in use before being set. The original MAC and IP addresses
