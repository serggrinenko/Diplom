resource "aws_ecs_cluster" "ecs-cluster" {
  name = "${var.ClusterName}-${var.Environment}"
}

resource "aws_key_pair" "deployer" {
  key_name   = "itea-test-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDcByHntP4vKEsMqzfaIGqaisL2Bk9n1ADT+v967pURHZXGIqIAVoUYEPdgNyWWtX+njUGrxs8QgqIGoE3FYtv2gbZdUPgtf70K9uJuCqn4tRr/EBclTKxMVVVBCB4nLoOKbXYisMowLOcMj5YnzAu0PWE2Dq6/kEWf+sqW0xo+kPw7EhyaojrBayr11n6VsKL47P6xXir+fX5I+DeGHSh3ODMUQF7UYtWhrJX9R5SnFpf9iCpyszcaSPRBpEWHMQDcvwcbxPlCnsin5PXj6IY8omzNpymUxXYLsPJYFsqjOHGX2kiyJE5x4xCvxGt2ZfM264J2KsW69OgItaWLvDQN grinenko@grinenko
"
}

data "template_file" "user_data" {
  template = "${file("templates/user_data.sh")}"

  vars {
    cluster_name = "${var.ClusterName}-${var.Environment}"
  }
}

module "ecs-instances" {
  source = "/home/grinenko/devops/proj2/devops-itea-1/Diplom/terraform/asg_module"
  environment = "dev"
  name = "Itea-ASG"
  aws_ami = "${var.ami_id}"
  key_name = "${aws_key_pair.deployer.key_name}"
  security_groups = ["${aws_security_group.cluster-sg.id}"]
  iam_instance_profile_arn = "${aws_iam_instance_profile.instance_profile.name}"
  subnet_ids = "${var.subnet_ids}"
  lifecycle_hook = 1
  user_data = "${data.template_file.user_data.rendered}"
}
