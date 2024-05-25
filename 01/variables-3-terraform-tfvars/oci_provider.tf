# Variables.
variable "tenancy_ocid"         { type = string }
variable "user_ocid"            { type = string }
variable "private_key_path"     { type = string }
variable "fingerprint"          { type = string }
variable "region"               { type = string }
variable "root_compartment_id"  { type = string }


provider "oci" {
  region           = var.region
  tenancy_ocid     = var.tenancy_ocid
  user_ocid        = var.user_ocid
  fingerprint      = var.fingerprint
  private_key_path = var.private_key_path
}
