output "api_server_ip" {
  value = module.servers["api"].public_ip
}

output "payments_server_ip" {
  value = module.servers["payments"].public_ip
}

output "logs_server_ip" {
  value = module.servers["logs"].public_ip
}