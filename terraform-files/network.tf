resource "esxi_vswitch" "vSwitchx" {
  for_each = toset([ for net_lst in var.network_list : net_lst.name ]) # List of network names
  name              = "vSwitch_${each.key}"
  promiscuous_mode  = "true"
  mac_changes       = "true"
  forged_transmits  = "true"
}

resource "esxi_portgroup" "PGx" {
  for_each = toset([ for net_lst in var.network_list : net_lst.name ]) # List of network names
  name              = "PG_${each.key}"
  vswitch           = esxi_vswitch.vSwitchx[each.key].name
}

