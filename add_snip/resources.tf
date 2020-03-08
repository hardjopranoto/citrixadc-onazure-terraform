resource "citrixadc_nsip" "nsip" {
    ipaddress = "10.8.2.4"
    type = "SNIP"
    netmask = "255.255.255.0"
    icmp = "ENABLED"
    state = "ENABLED"
} 