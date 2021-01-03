# dots

My usual environment configs

I've stored my secure keys (.ssh, webservice certs, etc) on Google Drive, so this script uses the PASSPHASE to
generate my password for Google, downloads the file and decrypts it. This allows it to use my SSH key for
accessing other resources such as Github.

## INSTALLATION

1. Get rid of the need for a sudo password:

   run "sudo visudo"
   change "%sudo ALL=(ALL:ALL) ALL"
   to "%sudo ALL=(ALL:ALL) NOPASSWD: ALL"

2. Add ssh key from other computer/vm (.ssh folder)

3. Run ```PASSPHRASE=<My passphrase> </Personal>cd ~ && wget https://raw.githubusercontent.com/LurkingFrog/dots/master/setup.sh && sh setup.sh | tee -a setup_output.log```


## Future

I have the idea of dev environment management called Panama. If/When I get further with that, this will
likely switch to a Panama config file.
