#!/bin/bash

# Function to set up OpenVPN
setup_openvpn() {
    mkdir -p openvpn-data/conf
    docker-compose run --rm openvpn ovpn_genconfig -u udp://YOUR_VPN_SERVER_IP
    docker-compose run --rm openvpn ovpn_initpki
    echo "OpenVPN setup complete."
}

# Function to start OpenVPN
start_openvpn() {
    docker-compose up -d
    echo "OpenVPN server started."
}

# Function to generate a certificate for a user
generate_certificate() {
    if [ -z "$2" ]; then
        echo "Please provide a username for the certificate."
        exit 1
    fi
    docker-compose run --rm openvpn easyrsa build-client-full "$2" nopass
    echo "Certificate generated for user $2."
}

# Function to retrieve client configuration
retrieve_client_config() {
    if [ -z "$2" ]; then
        echo "Please provide a username to retrieve the client configuration."
        exit 1
    fi
    docker-compose run --rm openvpn ovpn_getclient "$2" > "$2.ovpn"
    echo "Client configuration for $2 has been saved to $2.ovpn."
}

# Main script logic
if [ "$1" == "setup" ]; then
    setup_openvpn
elif [ "$1" == "start" ]; then
    start_openvpn
elif [ "$1" == "gen_cert" ]; then
    generate_certificate "$@"
elif [ "$1" == "get_client" ]; then
    retrieve_client_config "$@"
else
    echo "Invalid option. Use 'setup' to configure, 'start' to run the OpenVPN server, 'gen_cert' to generate a user certificate, or 'get_client' to retrieve a client configuration."
    exit 1
fi
