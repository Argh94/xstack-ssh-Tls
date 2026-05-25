# xStack - SSH over TLS (Stunnel)

![GitHub Repo stars](https://img.shields.io/github/stars/Argh94/xstack-ssh-Tls?style=social)
![License](https://img.shields.io/github/license/Argh94/xstack-ssh-Tls)
![Ubuntu](https://img.shields.io/badge/Supported-Ubuntu%20%7C%20Debian-blue)
![Shell](https://img.shields.io/badge/Shell-Bash-4EAA25)

**xStack** is a simple, fast, and powerful tool to set up **SSH over TLS** using Stunnel. It allows you to run SSH on port 443 (HTTPS) with SNI Spoofing — perfect for bypassing strict network restrictions.

---

## ✨ Features

- 🔒 SSH over TLS on port 443 (Highly stealth)
- 🎭 SNI Spoofing support (chatgpt.com, google.com, deepseek, etc.)
- ⚡ One-command fully automated installation
- 🌐 Automatic public IP detection
- 📜 Self-signed SSL certificate generation
- 👤 Username and Password prompt during installation
- 🔐 Strong and readable random password generation
- ✅ Fully compatible with **Ubuntu and Debian**
- 📱 Installable via **Termux** on mobile
- 🔑 Root access verification
- 🗑️ Clean uninstall option
- 🎨 Beautiful ASCII banner interface

---

## 🚀 Quick Installation

### Recommended Method (One-line):

```bash
curl -fsSL https://raw.githubusercontent.com/Argh94/xstack-ssh-Tls/refs/heads/main/xstack.sh | sudo bash
```

### Safer Method (Download First):

```bash
curl -fsSL https://raw.githubusercontent.com/Argh94/xstack-ssh-Tls/refs/heads/main/xstack.sh -o xstack.sh && sudo bash xstack.sh
```

---

## 📋 Requirements

- Ubuntu 20.04 / 22.04 / 24.04 or Debian 11/12
- Root access (`sudo` or `root` user)
- Minimum 512MB RAM
- Port 443 open in firewall

---

## 📸 Screenshots

<div align="center">
  <img src="https://github.com/Argh94/xstack-ssh-Tls/blob/main/img/IMG_20260525_131919_836.jpg" alt="Chicken Crossy Road Desktop Screenshot" width="320"/>
  <img src="https://github.com/Argh94/xstack-ssh-Tls/blob/main/img/IMG_20260525_131925_014.jpg" alt="Chicken Crossy Road Mobile Screenshot" width="200"/>
</div>

---
## 📖 How to Use

1. Run the script
2. Choose option **1** for installation
3. Enter your desired username (default: `xstack`)
4. Enter your desired password or leave empty for a strong random password
5. Connection details will be displayed after installation

### Sample Connection Info

```
Protocol  : SSH over TLS (Stunnel)
Host      : your_server_ip
Port      : 443
Username  : xstack
Password  : your_password
SNI       : chat.deepseek.com or www.google.com
```

**Tip:** Use SSH clients that support SNI Spoofing (e.g., Shadowrocket, v2rayNG, Nekobox, etc.)

---

## 🔧 Manual Configuration (Optional)

After installation, the main configuration files are located at:

- `/etc/stunnel/stunnel.conf` - Stunnel configuration
- `/etc/stunnel/stunnel.pem` - SSL certificate and key
- Local SSH Port: `22`

---

## 🗑️ Complete Removal

Run the script again and select option **2** to completely remove all files, services, and configurations.

```bash
sudo bash xstack.sh
```

Then choose option `2` and confirm the removal.

---

## ⚠️ Important Notes

- The script does not restart the SSH service automatically to prevent disconnecting your current session
- If needed, manually restart SSH after installation:

```bash
systemctl restart ssh
```

- Always use a strong password
- This tool is intended for legitimate and educational purposes only

---

## 📁 File Structure

```
xstack-ssh-Tls/
├── xstack.sh          # Main installation script
├── README.md          # This file
└── LICENSE            # MIT License
```

---

## 🔐 Security Features

- Root privilege verification
- Self-signed SSL/TLS certificates
- Secure password handling
- Automatic service enablement
- Clean configuration management

---

## 📄 License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

---

## ⭐ Show Your Support

If you find this project helpful, please consider giving it a ⭐ Star on GitHub!

[Star History](https://api.star-history.com/svg?repos=Argh94/xstack-ssh-Tls&type=Date)

---

Made with ❤️ for network freedom
