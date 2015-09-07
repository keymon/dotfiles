#!/bin/sh -e

iface=en0
mac_prefix="08:00:27"
old_address=$(ifconfig $iface |grep ether | awk '{print $2}')
new_address=${1:-$mac_prefix:$(openssl rand -hex 3 | sed 's/\(..\)/\1:/g; s/.$//')}
save_file=/tmp/$iface.$(date +%Y%m%d-%H%M%S.txt)

cat <<EOF
Changing MAC address of $iface from $old_address to $new_address.

EOF

echo "Running: sudo ifconfig en0 ether $new_address"
sudo ifconfig en0 ether $new_address

echo $old_address > $save_file

echo "Current new address in interface $iface: $(ifconfig en0 |grep ether | awk '{print $2}')"

cat <<EOF

Done.

Old adress is stored in $save_file.
Revert with: $0 \$(<$save_file)
EOF
