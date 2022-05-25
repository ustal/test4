resource "tls_private_key" "pk" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "test" {
  key_name   = "test"       # Create "myKey" to AWS!!
  public_key = tls_private_key.pk.public_key_openssh

  provisioner "local-exec" { # Create "myKey.pem" to your computer!!
    command = <<-EOT
      rm -rf ./test.pem
      echo '${tls_private_key.pk.private_key_pem}' > ./test.pem
      chmod 400 ./test.pem
    EOT
  }
}