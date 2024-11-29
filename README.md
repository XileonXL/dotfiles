# Steps

Install git and clone this repository

_IMPORTANT: If you are using Arch Linux based distribution you will need to install ansible modules before running the playbook. Use the following command:_

`ansible-galaxy install -r ansible/requirements.yml`

To configure your environment use:

`ansible-playbook -i ansible/hosts ansible/setup.yml --ask-become`

In addition, you can run specific tasks by tags:

`ansible-playbook -i ansible/hosts ansible/setup.yml --ask-become --tags "apps,neovim"`
