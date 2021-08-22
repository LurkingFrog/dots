#! /usr/bin/env bash

# This is to synchronize all my certs and keys with an encrypted backup file hosted on Google Drive
# Salt/Password stored in my lastpass account
# https://www.fosslinux.com/27018/best-ways-to-encrypt-files-in-linux.htm

# Files:
FILES=(.ssh/authorized_keys .ssh/id_rsa .ssh/id_rsa.pub .secure/google_oauth2.env .secure/fhl_service_acct.json)

function init() {
  mkdir -p ~/.secure
  chmod 700 ~/.secure
  cd ~/.secure
}


# Generate my secure passowrd from my passphrase (matches my user account on google)
function  makePassword() {

}

# Generate the GPG key
function makeGPGKey() {

}


function encrypt

# Use curl to push the file to Google
function upload() {

}

# init
# if no secure, create the directory and google drive curl command to pull it
