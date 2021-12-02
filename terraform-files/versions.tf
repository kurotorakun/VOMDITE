terraform {
  required_version = ">= 0.13"
  required_providers {
    # enable ESXi provider
    esxi = {
      source = "registry.terraform.io/josenk/esxi"
      version = "1.8.3" # Current version (Dec/2021) is 1.9.1 but has some issue with Portgroup policy that impact on Lab
      #
      # For more information, see the provider source documentation:
      #
      # https://github.com/josenk/terraform-provider-esxi
      # https://registry.terraform.io/providers/josenk/esxi
      #
    }
  }
}
