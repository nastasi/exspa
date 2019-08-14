# virtualenv

PROJ = exspa

timestamps/virtualenv.tstamp:
	virtualenv -p /usr/bin/python3.5 ./$(PROJ)-venv
	touch $@

virtualenv: timestamps/virtualenv.tstamp

install_dev_reqs:
	. ./$(PROJ)-venv/bin/activate && pip install -r requirements_dev.txt

# node
timestamps/node.tstamp:
	. ./$(PROJ)-venv/bin/activate && nodeenv -p
	touch $@

node: install_dev_reqs timestamps/node.tstamp

# yarn_check
timestamps/yarn_check.tstamp:
	@. ./$(PROJ)-venv/bin/activate && yarn --version >/dev/null 2>&1 || echo -e "'yarn' not found\nplease install it\nfor Debian/Ubuntu:\n\
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -\n\
echo \"deb https://dl.yarnpkg.com/debian/ stable main\" | sudo tee /etc/apt/sources.list.d/yarn.list\n"
	touch $@

yarn_check: timestamps/yarn_check.tstamp

#
# MAIN TARGETS
#

create: virtualenv install_dev_reqs node yarn_check
	. ./$(PROJ)-venv/bin/activate && yarn

recreate: destroy create

clean:
	rm -rf ./dist

destroy: clean
	@deactivate >/dev/null 2>&1 || true
	rm -rf ./$(PROJ)-venv
	rm -rf ./node_modules
	rm -f timestamps/[a-z]*

env:
	@echo ". ./$(PROJ)-venv/bin/activate"

build:
	. ./$(PROJ)-venv/bin/activate && yarn build

start:
	. ./$(PROJ)-venv/bin/activate && yarn start

check:
	. ./$(PROJ)-venv/bin/activate && python --version

.PHONY: install_reqs clean destroy virtualenv install_dev_reqs node yarn_check create recreate env build start check
