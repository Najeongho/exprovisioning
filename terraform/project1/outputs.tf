#####################################################################
##
##      Created 1/21/19 by admin. for project1
##
#####################################################################

output "alb_target_group_arn_suffixes" {
  value = "${module.alb.target_group_arn_suffixes}"
  description = "ARN suffixes of our target groups - can be used with CloudWatch."
}

output "alb_load_balancer_id" {
  value = "${module.alb.load_balancer_id}"
  description = "The ID and ARN of the load balancer we created."
}

output "alb_load_balancer_arn_suffix" {
  value = "${module.alb.load_balancer_arn_suffix}"
  description = "ARN suffix of our load balancer - can be used with CloudWatch."
}

output "alb_https_listener_arns" {
  value = "${module.alb.https_listener_arns}"
  description = "The ARNs of the HTTPS load balancer listeners created."
}

output "alb_http_tcp_listener_ids" {
  value = "${module.alb.http_tcp_listener_ids}"
  description = "The IDs of the TCP and HTTP load balancer listeners created."
}

output "alb_target_group_names" {
  value = "${module.alb.target_group_names}"
  description = "Name of the target group. Useful for passing to your CodeDeploy Deployment Group."
}

output "alb_target_group_arns" {
  value = "${module.alb.target_group_arns}"
  description = "ARNs of the target groups. Useful for passing to your Auto Scaling group."
}

output "alb_load_balancer_zone_id" {
  value = "${module.alb.load_balancer_zone_id}"
  description = "The zone_id of the load balancer to assist with creating DNS records."
}

output "alb_https_listener_ids" {
  value = "${module.alb.https_listener_ids}"
  description = "The IDs of the load balancer listeners created."
}

output "alb_http_tcp_listener_arns" {
  value = "${module.alb.http_tcp_listener_arns}"
  description = "The ARN of the TCP and HTTP load balancer listeners created."
}

output "alb_dns_name" {
  value = "${module.alb.dns_name}"
  description = "The DNS name of the load balancer."
}

output "vpn_gateway_vpn_connection_tunnel2_cgw_inside_address" {
  value = "${module.vpn_gateway.vpn_connection_tunnel2_cgw_inside_address}"
  description = "A list with the the RFC 6890 link-local address of the second VPN tunnel (Customer Gateway Side) if `create_vpn_connection = true`, or empty otherwise"
}

output "vpn_gateway_vpn_connection_tunnel2_address" {
  value = "${module.vpn_gateway.vpn_connection_tunnel2_address}"
  description = "A list with the the public IP address of the second VPN tunnel if `create_vpn_connection = true`, or empty otherwise"
}

output "vpn_gateway_vpn_connection_tunnel1_vgw_inside_address" {
  value = "${module.vpn_gateway.vpn_connection_tunnel1_vgw_inside_address}"
  description = "A list with the the RFC 6890 link-local address of the first VPN tunnel (VPN Gateway Side) if `create_vpn_connection = true`, or empty otherwise"
}

output "vpn_gateway_vpn_connection_tunnel1_cgw_inside_address" {
  value = "${module.vpn_gateway.vpn_connection_tunnel1_cgw_inside_address}"
  description = "A list with the the RFC 6890 link-local address of the first VPN tunnel (Customer Gateway Side) if `create_vpn_connection = true`, or empty otherwise"
}

output "vpn_gateway_vpn_connection_tunnel1_address" {
  value = "${module.vpn_gateway.vpn_connection_tunnel1_address}"
  description = "A list with the the public IP address of the first VPN tunnel if `create_vpn_connection = true`, or empty otherwise"
}

output "vpn_gateway_vpn_connection_id" {
  value = "${module.vpn_gateway.vpn_connection_id}"
  description = "A list with the VPN Connection ID if `create_vpn_connection = true`, or empty otherwise"
}

output "vpn_gateway_vpn_connection_tunnel2_vgw_inside_address" {
  value = "${module.vpn_gateway.vpn_connection_tunnel2_vgw_inside_address}"
  description = "A list with the the RFC 6890 link-local address of the second VPN tunnel (VPN Gateway Side) if `create_vpn_connection = true`, or empty otherwise"
}

