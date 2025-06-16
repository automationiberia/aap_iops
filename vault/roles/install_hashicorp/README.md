Role Name
=========

This role is installing the Hashicorp Vault Server in an Openshift Instance.

Requirements
------------

Connection to the internet is needed for the target Openshift instance as the application will deploy via a Helm template located at <https://helm.releases.hashicorp.com>.

Role Variables
--------------

A description of the settable variables for this role should go here, including any variables that are in defaults/main.yml, vars/main.yml, and any variables that can/should be set via parameters to the role. Any variables that are read from other roles and/or the global scope (ie. hostvars, group vars, etc.) should be mentioned here as well.

| Variable         | Type | Required | Default | Description |
| :--------------- | :--: | :------: | :-----: | :---------- |
| ssh_key_username | str  | no       | user1   | The username to assign the Vault secret to. |
| instance_name    | str  | yes      |         | The name of the Application to be created. |

Dependencies
------------

The collection `kubernetes.core` is used to interact with the Openshift instance.

Example Playbook
----------------

Including an example of how to use your role (for instance, with variables passed in as parameters) is always nice for users too:

    # SPDX-License-Identifier: MIT-0
    ---
    - hosts: localhost
      remote_user: root
      roles:
        - install_hashicorp

License
-------

GPL3.0+

Author Information
------------------

* [ivarmu](https://github.com/ivarmu)
