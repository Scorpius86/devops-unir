variable "admin_user" {
  type = object({
    username = string
    password = string
  })
  default = {
    username = "adminUser"
    password = "P@ssword1234"
  }  
}

variable "location" {
  type        = string
  description = "Región de Azure donde crearemos la infraestructura"
  default     = "West Europe"
}

variable "vm_size" {
  type        = string
  description = "Tamaño de la máquina virtual"
  #default     = "Standard_D1_v2" # 3.5 GB, 1 CPU 
  #default     = "Standard_B2s" # 4 GB, 2 CPU 
  #default     = "Standard_B2ms" # 8GB, 2 CPU, 
  default     = "Standard_DS2_v2" # 7GB, 2 CPU,   
}

variable "vm_master_config"{
  type = list(object({
    type        = string
    name        = string
    ip          = string
    cpus        = number
    mem         = number    
    osDisk    = object({
      size      = number
      type  = string
    })
  }))
  default = [    
    {
      type        = "master"
      name        = "k8s-c8-master"
      ip          = "10.0.1.10"
      cpus        = 1
      mem         = 3.5      
      osDisk      = {
        size = 40
        type = "Standard_LRS"
      }
    }   
  ]
}

variable "vm_node_config" {
  type = list(object({
    type        = string
    name        = string
    ip          = string
    cpus        = number
    mem         = number
    osDisk    = object({
      size      = number
      type  = string
    })
  }))
  default = [    
    {
      type        = "node"
      name        = "k8s-c8-node01"
      ip          = "10.0.1.11"
      cpus        = 1
      mem         = 3.5   
      osDisk      = {
        size = 40
        type = "Standard_LRS"
      }   
    },
    {
      type        = "node"
      name        = "k8s-c8-node02"
      ip          = "10.0.1.12"
      cpus        = 1
      mem         = 3.5 
      osDisk      = {
        size = 40
        type = "Standard_LRS"
      }     
    }
  ]
}

variable "vm_nfs_config" {
  type = list(object({
    type        = string
    name        = string
    ip          = string
    cpus        = number
    mem         = number
    osDisk      = object({
      size      = number
      type  = string
    })
    dataDisk    = object({
      size      = number
      type  = string
    })
  }))
  default = [    
    {
      type        = "nfs"
      name        = "k8s-c8-nfs"
      ip          = "10.0.1.15"
      cpus        = 1
      mem         = 3.5
      osDisk      = {
        size = 4
        type = "Standard_LRS"
      }   
      dataDisk    = {
        size  = 10
        type  = "Standard_LRS"
      }
    }
  ]
}

variable "vm_configurator_config" {
  type = list(object({
    type        = string
    name        = string
    ip          = string
    cpus        = number
    mem         = number
    osDisk      = object({
      size      = number
      type  = string
    })   
  }))
  default = [
    {
      type        = "conf"
      name        = "configurator-host"
      ip          = "10.0.1.9"
      cpus        = 1
      mem         = 3.5
      osDisk      = {
        size = 4
        type = "Standard_LRS"
      }  
    }
  ]
}

locals{  
  vm_config = concat(var.vm_configurator_config, var.vm_nfs_config, var.vm_master_config, var.vm_node_config)
}
