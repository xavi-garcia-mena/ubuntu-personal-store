#!/bin/bash

set -e

openssl aes-256-cbc -K $encrypted_527ca8567c65_key -iv $encrypted_527ca8567c65_iv -in travis/id_rsa_snapwebci_enc -out id_rsa_snapwebci -d
rm travis/id_rsa_snapwebci_enc
chmod 600 id_rsa_snapwebci; mv id_rsa_snapwebci ~/.ssh/id_rsa
ssh-add ~/.ssh/id_rsa
ssh-keyscan -t ecdsa $host 2>&1 | tee -a $HOME/.ssh/known_hosts


