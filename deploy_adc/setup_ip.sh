add_vip () {
# $1 Public NSIP
# $2 Password
# $3 VIP
# $4 Netmask

echo "add_vip $*"

curl \
--progress-bar \
-H "Content-Type: application/json" \
-H "X-NITRO-USER: nsroot" \
-H "X-NITRO-PASS: $2" \
-d "{\"nsip\" : { \"ipaddress\": \"$3\", \"netmask\": \"$4\", \"type\": \"VIP\" }}" \
-k \
https://$1/nitro/v1/config/nsip
}

add_snip () {
# $1 Public NSIP
# $2 Password
# $3 SNIP
# $4 Netmask

echo "add_snip $*"

curl \
--progress-bar \
-H "Content-Type: application/json" \
-H "X-NITRO-USER: nsroot" \
-H "X-NITRO-PASS: $2" \
-d "{\"nsip\" : { \"ipaddress\": \"$3\", \"netmask\": \"$4\", \"type\": \"SNIP\" }}" \
-k \
https://$1/nitro/v1/config/nsip
}


save_config () {
# $1 Public NSIP
# $2 Password

echo "save_config $*"

curl \
--progress-bar \
-H "Content-Type: application/json" \
-H "X-NITRO-USER: nsroot" \
-H "X-NITRO-PASS: $2" \
-d "{\"nsconfig\":{}}" \
-k \
https://$1/nitro/v1/config/nsconfig?action=save
}

echo "Waiting for $INITIAL_WAIT_SEC seconds before running ADC configuration script"
sleep $INITIAL_WAIT_SEC
add_vip $PUBLIC_NSIP $INSTANCE_PWD $VIP_IPADDR $SUBNET_MASK
sleep 15
add_snip $PUBLIC_NSIP $INSTANCE_PWD $SNIP_IPADDR $SUBNET_MASK
sleep 15
save_config $PUBLIC_NSIP $INSTANCE_PWD
echo "Script completed"
