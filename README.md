# GT-CLPM - GNUTUX Command Line Package Manager

![GT-CLPM](https://img.shields.io/badge/GT--CLPM-Package_Manager-blue)
![Version](https://img.shields.io/badge/Version-1.0-green)
![License](https://img.shields.io/badge/License-GPLv2-orange)
![Platform](https://img.shields.io/badge/Platform-Linux-lightgrey)

<img width="256" height="256" alt="GT-CLPM Logo" src="https://github.com/user-attachments/assets/6805474c-a20d-4ba4-b066-cf83536dbf31" />

مدير حزم سطر الأوامر الشامل لأنظمة جنو/لينكس  
**الإصدار:** 1.0  
**المطور:** GNUTUX  
**الرخصة:** GPLv2

---

## 🇦🇪 العربية

### 🚀 النظرة العامة
GT-CLPM هو مدير حزم سطر أوامر شامل لأنظمة جنو/لينكس، يُتيح لك إدارة الحزم عبر أشهر مديري الحزم من خلال واجهة طرفية واحدة موحدة وسهلة الاستخدام.

### ✨ المميزات الرئيسية
- 🌐 دعم لغات متعددة (العربية والإنجليزية)
- 📦 دعم 12+ مدير حزم مختلف
- 📱 دعم فلاتباك وسناب
- ⚙️ أدوات صيانة النظام والنسخ الاحتياطي
- 🎨 واجهة ملونة وسهلة الاستخدام
- 🔧 إصلاح الحزم المعطلة تلقائياً

### 📋 مديرو الحزم المدعومون
- **APT** (Debian, Ubuntu)
- **DNF/YUM** (Fedora, RHEL)
- **Pacman** (Arch, Manjaro)
- **Zypper** (openSUSE)
- **Eopkg** (Solus)
- **XBPS** (Void Linux)
- **Emerge** (Gentoo)
- **PKG** (FreeBSD)
- **APK** (Alpine)
- **Nix** (NixOS)

### 🛠️ التثبيت

#### التثبيت السريع (مستودع جيتهاب):
```bash
curl -fsSL https://raw.githubusercontent.com/SalehGNUTUX/GT-CLPM/main/install.sh | bash
```

#### باستخدام wget:
```bash
wget -q -O - https://raw.githubusercontent.com/SalehGNUTUX/GT-CLPM/main/install.sh | bash
```

#### التثبيت اليدوي:
```bash
git clone https://github.com/SalehGNUTUX/GT-CLPM.git
cd GT-CLPM
chmod +x install.sh
./install.sh
```

### 🗑️ إلغاء التثبيت

#### إلغاء التثبيت عن بُعد:
```bash
curl -fsSL https://raw.githubusercontent.com/SalehGNUTUX/GT-CLPM/main/uninstall.sh | bash
```

#### إلغاء التثبيت المحلي:
```bash
sudo rm -f /usr/local/bin/gt-clpm
rm -f ~/.gt-clpm-lang
rm -f ~/.gt-clpm-backup-*.txt
```

### 🎯 طريقة الاستخدام
بعد التثبيت، شغّل البرنامج بالأمر:
```bash
gt-clpm
```

<img width="1440" height="900" alt="واجهة البرنامج" src="https://github.com/user-attachments/assets/91287643-8f19-4af6-a78e-23cfea894b68" />

### 📁 الهيكل التنظيمي
```
GT-CLPM/
├── install.sh          # مثبت سريع
├── uninstall.sh        # مزيل سريع
└── GT-CLPM/
    ├── gt-clpm.sh      # البرنامج الرئيسي
    └── installer.sh    # المثبت التفصيلي
```

### 🐛 الإبلاغ عن المشكلات
لتبليغ عن الأخطاء أو اقتراح ميزات جديدة:  
[📝 إنشاء إشكالية على GitHub](https://github.com/SalehGNUTUX/GT-CLPM/issues)

---

## 🇬🇧 English

### 🚀 Overview
GT-CLPM is a comprehensive command-line package manager for GNU/Linux systems. It provides a unified terminal interface for managing packages across multiple package managers.

### ✨ Key Features
- 🌐 Multi-language support (Arabic & English)
- 📦 Support for 12+ package managers
- 📱 Flatpak and Snap integration
- ⚙️ System maintenance and backup tools
- 🎨 Colorful and user-friendly interface
- 🔧 Automatic broken package repair

### 📋 Supported Package Managers
- **APT** (Debian, Ubuntu)
- **DNF/YUM** (Fedora, RHEL)
- **Pacman** (Arch, Manjaro)
- **Zypper** (openSUSE)
- **Eopkg** (Solus)
- **XBPS** (Void Linux)
- **Emerge** (Gentoo)
- **PKG** (FreeBSD)
- **APK** (Alpine)
- **Nix** (NixOS)

### 🛠️ Installation

#### Quick Install (GitHub Repository):
```bash
curl -fsSL https://raw.githubusercontent.com/SalehGNUTUX/GT-CLPM/main/install.sh | bash
```

#### Using wget:
```bash
wget -q -O - https://raw.githubusercontent.com/SalehGNUTUX/GT-CLPM/main/install.sh | bash
```

#### Manual Installation:
```bash
git clone https://github.com/SalehGNUTUX/GT-CLPM.git
cd GT-CLPM
chmod +x install.sh
./install.sh
```

### 🗑️ Uninstallation

#### Remote Uninstall:
```bash
curl -fsSL https://raw.githubusercontent.com/SalehGNUTUX/GT-CLPM/main/uninstall.sh | bash
```

#### Local Uninstall:
```bash
sudo rm -f /usr/local/bin/gt-clpm
rm -f ~/.gt-clpm-lang
rm -f ~/.gt-clpm-backup-*.txt
```

### 🎯 Usage
After installation, run the program with:
```bash
gt-clpm
```

<img width="1440" height="900" alt="Program Interface" src="https://github.com/user-attachments/assets/754d5049-e673-42d3-9c97-3c574f337917" />

### 📁 Project Structure
```
GT-CLPM/
├── install.sh          # Quick installer
├── uninstall.sh        # Quick uninstaller
└── GT-CLPM/
    ├── gt-clpm.sh      # Main program
    └── installer.sh    # Detailed installer
```

### 🐛 Reporting Issues
To report bugs or request new features:  
[📝 Create GitHub Issue](https://github.com/SalehGNUTUX/GT-CLPM/issues)

---

## 📄 الرخصة
هذا المشروع مرخص تحت رخصة GPLv2. راجع ملف LICENSE للتفاصيل.

## 👥 المساهمة
المساهمات مرحب بها! لا تتردد في عمل Fork وعمل Pull Request.

## 📞 الدعم
- 📧 البريد الإلكتروني: [إضافة بريدك هنا]
- 💬 GitHub Issues: [رابط Issues](https://github.com/SalehGNUTUX/GT-CLPM/issues)

