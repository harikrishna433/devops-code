variable "subscription_id" {
  default = ""
}

variable "client_id" {
  default = ""
}

variable "client_secret" {
  default = ""
}

variable "tenant_id" {
  default =""
}

variable "location" {
    default = "uk south"
}

variable "prefix" {
    default = "haritest"
}

variable "tags" {
    type = map
    default = {
        "creator" = "hari"
        "id"  =   "123456"
    }
}

variable "server_regions" {
  type = map
  default = {
      "0" = "east asia"
       "1" = "uk south"
  }
}
