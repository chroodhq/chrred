INIT_COMMAND_OPTIONS ?=
COMMAND_OPTIONS ?= -reconfigure

fmt:
	terraform fmt -recursive $(COMMAND_OPTIONS)

init:
	terraform init $(COMMAND_OPTIONS) $(INIT_COMMAND_OPTIONS)

validate:
	terraform validate $(COMMAND_OPTIONS)

plan:
	terraform plan $(COMMAND_OPTIONS)

apply:
	terraform apply $(COMMAND_OPTIONS)

destroy:
	terraform destroy $(COMMAND_OPTIONS)
