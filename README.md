# dots

My usual environment configs

## INSTALLATION

1. Get rid of the need for a sudo password:

   run "sudo visudo"
   change "%sudo ALL=(ALL:ALL) ALL"
   to "%sudo ALL=(ALL:ALL) NOPASSWD: ALL"

2. Add ssh key from other computer/vm (.ssh folder)

3. Run ```cd ~ && wget https://raw.githubusercontent.com/LurkingFrog/dots/master/setup.sh && sh setup.sh | tee -a setup_output.log```


## Future

I have the idea of dev environment management called Panama. If/When I get further with that, this will
likely switch to a Panama config file.
