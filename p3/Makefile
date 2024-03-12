all:
	sudo bash ./scripts/add_host.sh
	bash ./scripts/setup.sh

clean:
	k3d cluster delete sleleuC

re : clean all

.PHONY: all clean re
