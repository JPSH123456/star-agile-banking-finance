//Security group creation and whitelisting the ip
resource "aws_security_group" "allow_tls" {
  name = "terraform-sg"

  ingress {
 description = "HTTPS traffic"
 from_port = 443
 to_port = 443
 protocol = "tcp"
 cidr_blocks = ["0.0.0.0/0"]
 }
ingress {
 description = "HTTP traffic"
 from_port = 0
 to_port = 65000
 protocol = "tcp"
 cidr_blocks = ["0.0.0.0/0"]
 }
 ingress {
 description = "SSH port"
 from_port = 22
 to_port = 22
 protocol = "tcp"
 cidr_blocks = ["0.0.0.0/0"]
 }
 egress {
 from_port = 0
 to_port = 0
 protocol = "-1"
 cidr_blocks = ["0.0.0.0/0"]
 ipv6_cidr_blocks = ["::/0"]
 }
}
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region     = "ap-northeast-1"
}
resource "aws_instance" "myec2" {
  ami                    = "ami-0b828c1c5ac3f13ee"
  instance_type          = "t2.micro"
  availability_zone = "ap-northeast-1a"
  vpc_security_group_ids = [aws_security_group.allow_tls.id]
  key_name = "tokyo1"
  tags = {
    Name = "test-server"
  }

  provisioner "local-exec" {
    command = "echo ${aws_instance.myec2.public_ip} > /etc/ansible/hosts"
  }
}
resource "aws_key_pair" "deployer" {
  key_name   = "dep_key"
  public_key = "-----BEGIN RSA PRIVATE KEY-----
MIIEowIBAAKCAQEAoBIMdmkEREkx4tIFEesvOt27xRGf52LIelCcpWUdxHfGpTiw
ye7YulWTKPXoJ6oP01ptSmMjoPsUpX2OxJXQlyOrTdE5m3eckTCTsaCui5Ds38LF
iCVAZCjQbPbuY2fmJBHo9dSrgBTG4bpZKWpKLktgb+0Qg6GU+N76WLKmbDYx2kz6
+g4IALvEKIk8DHUhNkczU4uqzy/YwSfnWghHF5Ww/fRxOYFt1sen3iv481+TJsxj
0wXWdYtEOq6A74LRgdC3wZIDClyeYaYjtNbcBp97FfLLLIdo8unWXG7bVTkf+32y
a7XYbl358MUp3YIT2juoa7k8C+EuShMDKdwAGQIDAQABAoIBAAZArjvx3jjMoyY5
DfmlNjMWdj88cQKY2Tvt6jCLwp3qD9hkXoOE0PJ2ZUk0Ud06x2N6JMrDFKE1LZlJ
Tkpfj8ZXnllr0tQ/193UB/DoVekdwCL9eLnYuqsu7PVUr/syE8tU58SyigB2z04B
+XmkrUEhsKKun/aEWU1faGgOknGnnF2IkR8D4S9BMuUohLG76VHdcphMqAMvy+k9
rmMAjK9BcEscBSht2EibRQRiI+eudX874RiGCU3HSKqeJ8qBjRiIehH7lmkBuByV
RevPvM83rbzlQCje2X4RcX+wnJ0YOoXlUvajKKOapMLwQb2mjrgel3QTRF2pLMDo
l+QgaAECgYEA5AwdVH37i+diE/ZKdLuM/gbHjiIz5GGEzBbvVLkLziBpCc9JFm5p
qVTG9biPHnsgo1XIpSy77THdxMm1wPvbeTvwWFJJd8J21MNFxHnn1X7tSyWRYu38
b4WsuSP0BdWeqdqVBVWlyxdEzzGxJr05atwqp+9joHIeJcjDkoPE9DsCgYEAs7Dk
lbn43WK2RfXnZLDYoc7SZjfRWAtJiilDAo9+GpXDGSCjU/LK5XZyiJTln+M1nnJ6
HJv5unuedA0W6K+E/BCE6Za3tGviecnWhYWRXQjY5EgU5tUKvO9YW4HeZ1PrTLdS
/X1zUxBeuvz58bxBBey8Pp52XRubl38s9cbcO7sCgYEAseX1d3U0J2agbzwhx0CL
85rsT6fE3XNpuiBmIaydVfaYmkt3E6WcjbkR4JxSIZAh3OlNtfTYwWe2Pg6w19Rh
2Qh2LSA8Kc2tD7spkOUcgsMacBXlfcxzsbgRDvjKI0cLGCvpNpki1fTX+94i+TqC
MSeBqzIngQGlHQqp7oEWwwMCgYAMUatKLIbIPrU6VKJ5f7pKVZCNG3SJsbRn+W4z
pbzCe9P1TAyGe9W3J4iwnmyjqoMJitWeUn8rbsAtOpyAdVALq+JA1WlgwCi1qsW/
P6n4k9uywtJUBPUIgOww0dV6hgFSsBrLcCdQ4YVtElzcWsimbFV3gYuh1Hu1Ri3B
59E/cwKBgFfqLQ+Y4BkbC/z+3qgRrUO1XyRtb9kgM6eydB29tR2igxdgMogaz9q9
dh0zA6QwHHMMejPyXhnE4/OB8TJH1QB+NlEtXjZ0a0dL5JFWvtMWsEQ36YlfzL1n
AIApMrssCEWnDsrzz7S8e8n7Q5KwnXH8Swv8T6WSAg9FVBqVRyqo
-----END RSA PRIVATE KEY-----"
}
