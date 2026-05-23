#!/usr/bin/env bash
# xStack
# 2025 – Improved version

if [[ $EUID -ne 0 ]]; then
    echo -e "\033[1;31m❌ This script must be run as root!\033[0m"
    echo -e "\033[1;33m   Please run it with: sudo bash $0\033[0m"
    exit 1
fi

set -e

export DEBIAN_FRONTEND=noninteractive

clear

banner() {
    clear
    echo -e "\033[1;36m"
    cat << "EOF"
$$\   $$\             $$\                         $$\       
$$ |  $$ |            $$ |                        $$ |      
\$$\ $$  | $$$$$$$\ $$$$$$\    $$$$$$\   $$$$$$$\ $$ |  $$\ 
 \$$$$  / $$  _____|\_$$  _|   \____$$\ $$  _____|$$ | $$  |
 $$  $$<  \$$$$$$\    $$ |     $$$$$$$ |$$ /      $$$$$$  / 
$$  /\$$\  \____$$\   $$ |$$\ $$  __$$ |$$ |      $$  _$$<  
$$ /  $$ |$$$$$$$  |  \$$$$  |\$$$$$$$ |\$$$$$$$\ $$ | \$$\ 
\__|  \__|\_______/    \____/  \_______| \_______|\__|  \__|
EOF
    echo -e "\033[0m"
}

banner

echo -e "  \033[1;33m1) Install Stunnel + SSH Panel\033[0m"
echo -e "  \033[1;33m2) Completely Remove Panel\033[0m"
echo -e "  \033[1;37m0) Exit\033[0m\n"

read -p "Your choice (1/2/0): " choice

get_public_ip() {
    curl -s ifconfig.me 2>/dev/null ||
    curl -s icanhazip.com 2>/dev/null ||
    curl -s api.ipify.org 2>/dev/null ||
    hostname -I | awk '{print $1}' 2>/dev/null ||
    echo "YOUR_SERVER_PUBLIC_IP"
}

case $choice in
    1)
        clear
        banner
        echo -e "\033[1;32m→ Updating package lists ...\033[0m\n"
        apt update -y 2>/dev/null || true

        echo -e "\033[1;32m→ Installing / upgrading required packages ...\033[0m\n"
        apt install -y --no-install-recommends \
            openssh-server stunnel4 curl wget openssl ca-certificates

        echo -e "\n\033[1;32m→ Generating self-signed SSL certificate ...\033[0m"
        mkdir -p /etc/stunnel
        openssl req -new -x509 -days 3650 -nodes -sha256 \
            -subj "/C=IR/O=XStack/CN=ssh.xstack" \
            -out /etc/stunnel/stunnel.pem \
            -keyout /etc/stunnel/stunnel.pem >/dev/null 2>&1
        chmod 600 /etc/stunnel/stunnel.pem

        echo -e "\033[1;32m→ Configuring Stunnel ...\033[0m"
        cat > /etc/stunnel/stunnel.conf << 'EOF'
pid = /var/run/stunnel4/stunnel.pid
output = /var/log/stunnel4/stunnel.log
setuid = stunnel4
setgid = stunnel4

[ssh]
accept = 443
connect = 127.0.0.1:22
cert = /etc/stunnel/stunnel.pem
EOF

        echo -e "\033[1;32m→ Enabling & starting services ...\033[0m"
        sed -i 's/ENABLED=0/ENABLED=1/' /etc/default/stunnel4 2>/dev/null || true

        systemctl enable ssh >/dev/null 2>&1 || true
        systemctl enable stunnel4 >/dev/null 2>&1 || true

        systemctl restart stunnel4 2>/dev/null || true

        echo -e "\n\033[1;33mEnter desired username (default: xstack):\033[0m"
        read -r username
        username=${username:-xstack}

        echo -e "\n\033[1;33mEnter desired password (empty = random):\033[0m"
        read -r password
        if [[ -z "$password" ]]; then
            password="xst$(date +%s | sha256sum | base64 | head -c 10 | tr '[:upper:]' '[:lower:]')"
            echo -e "\033[1;35mGenerated password: \033[1;32m$password\033[0m"
        fi

        echo -e "\n\033[1;32m→ Creating/updating user ...\033[0m"
        useradd -m -s /bin/bash "$username" 2>/dev/null || true
        echo "$username:$password" | chpasswd
        usermod -aG sudo "$username" 2>/dev/null || true   

        clear
        banner

        IP=$(get_public_ip)

        echo -e "\033[1;32m✅ Setup finished!\033[0m\n"
        echo -e "\033[1;37m================ CONFIGURATION =================\033[0m"
        echo -e "Protocol  : \033[1;36mSSH over TLS (Stunnel)\033[0m"
        echo -e "Host      : \033[1;33m$IP\033[0m"
        echo -e "Port      : \033[1;33m443\033[0m"
        echo -e "Username  : \033[1;32m$username\033[0m"
        echo -e "Password  : \033[1;32m$password\033[0m"
        echo -e "SNI       : \033[1;35mchat.deepseek.com  or  chatgpt.com  or  www.google.com\033[0m"
        echo -e "\033[1;37m================================================\033[0m\n"

        echo -e "\033[0;37mTip: Use SSH client with port 443 + SNI spoofing (most bypass tools support it)\033[0m\n"
        echo -e "\033[0;33mNote: SSH service was NOT restarted automatically to prevent disconnect.\033[0m"
        echo -e "\033[0;33m      Run 'systemctl restart ssh' manually if needed.\033[0m\n"
        ;;

    2)
        clear
        banner
        echo -e "\033[1;31mAre you sure you want to COMPLETELY REMOVE the setup?\033[0m"
        echo -e "  This action is irreversible!\n"
        read -p "Confirm (y/n): " confirm
        if [[ "$confirm" =~ ^[Yy]$ ]]; then

            echo -e "\n\033[1;33m→ Removing components ...\033[0m\n"
            systemctl stop stunnel4 2>/dev/null || true
            systemctl disable stunnel4 2>/dev/null || true

            rm -rf /etc/stunnel 2>/dev/null
            rm -f /etc/default/stunnel4 2>/dev/null
            rm -rf /var/log/stunnel4 2>/dev/null

            apt purge -y stunnel4 2>/dev/null || true
            apt autoremove -y 2>/dev/null || true

            echo -e "\033[1;32mRemoval finished.\033[0m"
            echo -e "Stunnel and related configs have been removed.\n"
        else
            echo -e "\033[1;33mOperation cancelled.\033[0m"
            sleep 1
            exec "$0"
        fi
        ;;

    0)
        echo -e "\n\033[1;37mExiting ...\033[0m"
        exit 0
        ;;

    *)
        echo -e "\n\033[1;31mInvalid choice! Please enter 1, 2 or 0.\033[0m"
        sleep 2
        exec "$0"
        ;;
esac
