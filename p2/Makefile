all:
	vagrant up --provider libvirt
	sudo bash scripts/add_hosts.sh

destroy:
	vagrant destroy sleleuS -f
	rm -rfd .vagrant

re:
	make destroy
	make all

.PHONY: all destroy re
