sudo apt-get update
curl -fsSL https://get.docker.com/ | sh
sudo usermod -aG docker $(whoami)
sudo reboot