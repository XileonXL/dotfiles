.PHONY ansible

ansible:
	ansible-playbook -i ansible/hosts ansible/setup.yml --ask-become 
