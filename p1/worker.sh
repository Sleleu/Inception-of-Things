apt update
apt install curl -y

while [ ! -f /vagrant/token ]; do
    echo "Waiting for token..."
    sleep 5
done

TOKEN=$(cat /vagrant/token)
curl -sfL https://get.k3s.io | K3S_URL=https://192.168.56.110:6443 K3S_TOKEN=$TOKEN INSTALL_K3S_EXEC='--flannel-iface=eth1' sh -
rm /vagrant/token