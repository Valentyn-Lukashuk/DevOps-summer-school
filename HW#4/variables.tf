variable "user" {
    type = string
    default = "terraform"
}
#variable "email" {
#    type = string
#    default = "~/DevOps-Summer-School-2021/terraform/terraform_gcp_key.json"
}
variable "privatekeypath" {
    type = string
    default = "~/.ssh/id_rsa"
}
variable "publickeypath" {
    type = string
    default =  "~/.ssh/id_rsa.pub"
}
