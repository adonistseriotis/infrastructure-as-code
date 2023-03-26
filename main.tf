# Define required providers
terraform {
  required_version = ">= 0.14.0"
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "~> 1.48.0"
    }
  }
}

# Set the OpenStack authentication variables
provider "openstack" {
  user_name   = var.username
  token       = var.token
  auth_url    = var.auth_url
  tenant_name = var.project_name
}

# Create a security group
resource "openstack_networking_secgroup_v2" "full_access" {
  name = "test-full access"
}

# Set the rules
resource "openstack_networking_secgroup_rule_v2" "full_access" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = ""
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.full_access.id
}

# resource "openstack_networking_router_v2" "router" {
#   # (resource arguments)
# }

# # Attach the subnet to a router (assuming you have a router already created)
# resource "openstack_networking_router_interface_v2" "interface" {
#   subnet_id = openstack_networking_subnet_v2.subnet.id
#   router_id = openstack_networking_router_v2.router.id
# }

resource "openstack_networking_network_v2" "network" {
  # (resource arguments)
  name = "thesis-iac"
}


# Create master
resource "openstack_compute_instance_v2" "master" {
  name            = "master"
  image_name      = "ubuntu-22.04"
  flavor_name     = "m1.medium"
  key_pair        = "Cherry"
  security_groups = [openstack_networking_secgroup_v2.full_access.name]

  network {
    name = openstack_networking_network_v2.network.name
  }
}

# Create first worker
resource "openstack_compute_instance_v2" "worker_1" {
  name            = "worker_1"
  image_name      = "ubuntu-22.04"
  flavor_name     = "m1.medium"
  key_pair        = "Cherry"
  security_groups = [openstack_networking_secgroup_v2.full_access.name]

  network {
    name = openstack_networking_network_v2.network.name
  }
}

# Create second worker
resource "openstack_compute_instance_v2" "worker_2" {
  name            = "worker_2"
  image_name      = "ubuntu-22.04"
  flavor_name     = "m1.small"
  key_pair        = "Cherry"
  security_groups = [openstack_networking_secgroup_v2.full_access.name]

  network {
    name = openstack_networking_network_v2.network.name
  }
}

# Create floating IP
resource "openstack_networking_floatingip_v2" "fip" {
  pool = "external"
}

# Associate it with master
resource "openstack_compute_floatingip_associate_v2" "fip" {
  floating_ip = openstack_networking_floatingip_v2.fip.address
  instance_id = openstack_compute_instance_v2.master.id
}
