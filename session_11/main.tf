resource "aws_sqs_queue" "first_sqs" {
  name = "${terraform.workspace}-example-queque"
}