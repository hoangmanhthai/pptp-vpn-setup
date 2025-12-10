# 📘 VPN ALL-IN-ONE INSTALLER  
### Hỗ trợ Ubuntu / Debian / CentOS / Rocky / AlmaLinux  
### Tự động tạo PPTP VPN + Random username/password  

---

## 🚀 Giới thiệu

Script **vpn_all.sh** là trình cài đặt PPTP VPN tự động, hỗ trợ nhiều hệ điều hành Linux:

- Ubuntu (16.04 → 24.04)  
- Debian  
- CentOS 6 / 7 / 8  
- Rocky Linux  
- AlmaLinux  

Script sẽ tự:

- ✔ Nhận dạng hệ điều hành  
- ✔ Cài đặt gói cần thiết (pptpd, ppp, iptables)  
- ✔ Bật IP forwarding  
- ✔ Cấu hình PPTP server  
- ✔ Thêm NAT + GRE firewall  
- ✔ Khởi động dịch vụ VPN  
- ✔ Tạo **username + password ngẫu nhiên**  

---

## 📦 Hỗ trợ hệ điều hành

| Hệ điều hành | Hỗ trợ |
|--------------|--------|
| Ubuntu | ✅ |
| Debian | ✅ |
| CentOS 6 | ⚠️ Giới hạn |
| CentOS 7 | ✅ |
| CentOS 8 | ⚠️ Cần repo PowerTools |
| Rocky Linux | ✅ |
| AlmaLinux | ✅ |

---

## 📥 Cài đặt

### 1. Tải script

```bash
wget -O vpn_all.sh https://raw.githubusercontent.com/hoangmanhthai/pptp-vpn-setup/refs/heads/main/setup.sh
```
### 2. Cấp quyền chạy

```bash
chmod +x setup.sh
```
### 3. Chạy script
```bash
sudo ./setup.sh
```
## 📥 Cài đặt nhanh
```bash
wget -O vpn_all.sh https://raw.githubusercontent.com/hoangmanhthai/pptp-vpn-setup/refs/heads/main/setup.sh
chmod +x setup.sh
sudo ./setup.sh
```
