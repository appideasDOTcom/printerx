```
# Enable serial
sudo raspi-config
# Get node/nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.37.2/install.sh | bash
source ~/.bashrc
nvm install --lts
sudo apt-get update
sudo apt-get install pigpio g++
```