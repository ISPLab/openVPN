# Use the official kylemanna/openvpn image as the base with platform specification
FROM --platform=linux/amd64 kylemanna/openvpn

# Add any custom configuration or scripts here
# For example, you could copy custom scripts or configuration files
COPY ./openvpn-data/ /etc/openvpn/
# RUN chmod +x /usr/local/bin/my-custom-script.sh

# Expose the default OpenVPN port
EXPOSE 1194/tcp 