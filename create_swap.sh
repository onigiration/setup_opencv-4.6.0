sudo dd if=/dev/zero of=/swapfile bs=1M count=8192 
sudo chmod 600 /swapfile 
sudo mkswap /swapfile 
sudo swapon /swapfile
