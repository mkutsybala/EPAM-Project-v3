output "mk_web_srv_ip" {
  value = aws_instance.mk_web_srv.public_ip 
}

output "mk_web_srv_end_point" {
  value = "http://${aws_instance.mk_web_srv.public_dns}"
}

output "source_ip" {
  value = "${chomp(data.http.source_public_ip.response_body)}"
}