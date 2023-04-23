INIT_COMMAND_OPTIONS ?= -backend-config="bucket=$(TF_STATE_BUCKET)" -backend-config="key=$(TF_VAR_stack_name)/$(TF_VAR_environment)/terraform.tfstate" -backend-config="dynamodb_table=$(TF_STATE_LOCK_TABLE)"
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
