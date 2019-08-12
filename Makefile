exspa-venv/bin/activate:
	virtualenv -p /usr/bin/python3.5 ./exspa-venv

install_reqs:
	. ./exspa-venv/bin/activate && pip install -r requirements_dev.txt

exspa-venv/bin/node:
	. ./exspa-venv/bin/activate && nodeenv -p

create: ./exspa-venv/bin/activate install_reqs ./exspa-venv/bin/node
	@. ./exspa-venv/bin/activate && yarn --version >/dev/null 2>&1 || echo -e "'yarn' not found\nplease install it\nfor Debian/Ubuntu:\n\
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -\n\
echo \"deb https://dl.yarnpkg.com/debian/ stable main\" | sudo tee /etc/apt/sources.list.d/yarn.list\n"

recreate: destroy create

destroy:
	@deactivate >/dev/null 2>&1 || true
	rm -rf ./exspa-venv || true
	rm -rf ./node_modules || true

check:
	. ./exspa-venv/bin/activate && python --version

.PHONY: install_reqs destroy create recreate check
