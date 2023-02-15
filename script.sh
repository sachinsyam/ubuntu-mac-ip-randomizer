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
NEW_MAC=$(printf '52:54:%02x:%02x:%02x:%02x\n' $((RANDOM%256)) $((RANDOM%256)) $((RANDOM%256)) $((RANDOM%256)))

# Generate a new IP address
NEW_IP="192.168.$((RANDOM % 256)).$((RANDOM % 256))"

# Check if the new IP address is already in use
ping -c 1 $NEW_IP > /dev/null
while [ $? -eq 0 ]; do
  # If the new IP address is in use, generate a new one and check again
  NEW_IP="192.168.$((RANDOM % 256)).$((RANDOM % 256))"
  ping -c 1 $NEW_IP > /dev/null
done

# Set the new MAC address
sudo ip link set dev eth0 down
sudo ip link set dev eth0 address $NEW_MAC
sudo ip link set dev eth0 up

# Set the new IP address
sudo ip addr add $NEW_IP/24 dev eth0

# Make the script executable
chmod +x $RESTORE_NETWORK_FILE

echo "New MAC address: $NEW_MAC"
echo "New IP address: $NEW_IP"
