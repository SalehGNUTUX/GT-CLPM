# GT-CLPM - GNUTUX Command Line Package Manager

![GT-CLPM](https://img.shields.io/badge/GT--CLPM-Package_Manager-blue)
![Version](https://img.shields.io/badge/Version-1.2.2-green)
![License](https://img.shields.io/badge/License-GPLv2-orange)
![Platform](https://img.shields.io/badge/Platform-Linux-lightgrey)

<img width="256" height="256" alt="GT-CLPM Logo" src="https://github.com/user-attachments/assets/6805474c-a20d-4ba4-b066-cf83536dbf31" />

مدير حزم سطر الأوامر الشامل لأنظمة جنو/لينكس  
**الإصدار:** 1.2.2  
**المطور:** GNUTUX  
**الرخصة:** GPLv2

---

## 🆕 ما الجديد في الإصدار 1.2.2

### ✨ الميزات الجديدة
- 🔍 **بحث فلاتباك مُصلَح** - نتائج صحيحة وكاملة بما فيها `org.telegram.desktop` وما شابهه
- 📄 **تنقل بين صفحات النتائج** - استخدم `n` للصفحة التالية و`p` للسابقة
- 🔢 **50 نتيجة** بدلاً من 20 لكل عملية بحث
- 🛠️ **جميع قوائم أدوات اللغات مكتملة** - Ruby, Rust, Go, Java, PHP, Haskell, Scientific
- ➕ **إدارة المستودعات** - PPA, COPR, AUR helper, Packman, RPM Fusion
- 🍺 **دعم Homebrew** على Linux/macOS
- 🔬 **أدوات علمية** - Spack, Conda/Miniconda, Mamba
- 🐍 **Python محسّن** - pip --user, pipx, venv مع إدارة كاملة
- 🐹 **Go** - تثبيت تلقائي إذا لم يكن موجوداً

### 📊 مقارنة الإصدارات

| الميزة | v1.0 | v1.1 | v1.2.2 |
|--------|------|------|--------|
| الإزالة الذكية | ❌ | ✅ | ✅ |
| التثبيت من نتائج البحث | ❌ | ✅ | ✅ |
| بحث فلاتباك صحيح | ❌ | ⚠️ | ✅ |
| تنقل بين صفحات النتائج | ❌ | ❌ | ✅ |
| أدوات اللغات (pip/pipx/gem/cargo...) | ❌ | ⚠️ جزئي | ✅ كامل |
| إدارة المستودعات | ❌ | ❌ | ✅ |
| Spack / Conda / Mamba | ❌ | ❌ | ✅ |
| Homebrew | ❌ | ❌ | ✅ |
| حد نتائج البحث | - | 20 | 50 |

---

## 🇲🇦 العربية 🇸🇦

### 🚀 النظرة العامة
GT-CLPM هو مدير حزم سطر أوامر شامل لأنظمة جنو/لينكس، يُتيح لك إدارة الحزم عبر أشهر مديري الحزم من خلال واجهة طرفية واحدة موحدة وسهلة الاستخدام.

### ✨ المميزات الرئيسية
- 🌐 دعم لغات متعددة (العربية والإنجليزية)
- 📦 دعم 13+ مدير حزم مختلف
- 📱 دعم فلاتباك وسناب مع بحث تفاعلي مُصلَح
- 📄 تصفح نتائج البحث بالصفحات (n/p)
- ⚙️ أدوات صيانة النظام والنسخ الاحتياطي
- 🎨 واجهة ملونة وسهلة الاستخدام
- 🔧 إصلاح الحزم المعطلة تلقائياً
- 🧠 إزالة ذكية للحزم
- 🛠️ إدارة المستودعات والـ PPA
- 🐍 دعم كامل لمديري حزم اللغات البرمجية

### 📋 مديرو الحزم المدعومون
- **APT** (Debian, Ubuntu, Mint)
- **DNF/YUM** (Fedora, RHEL, CentOS)
- **Pacman** (Arch, Manjaro, EndeavourOS)
- **Zypper** (openSUSE)
- **Eopkg** (Solus)
- **XBPS** (Void Linux)
- **Emerge** (Gentoo)
- **PKG** (FreeBSD)
- **APK** (Alpine Linux)
- **Nix** (NixOS)
- **Homebrew** (Linux/macOS)
- **Flatpak** (التطبيقات العالمية)
- **Snap** (حزم كانونيكال)

### 🛠️ مديرو حزم اللغات البرمجية
- **🐍 Python** - pip, pip --user, pipx, virtual environments
- **📦 Node.js** - npm, yarn, pnpm, npx
- **💎 Ruby** - gem, bundler
- **🦀 Rust** - cargo, rustup
- **🐹 Go** - go install (تثبيت تلقائي)
- **☕ Java** - maven, gradle, SDKMAN
- **🐘 PHP** - composer, إضافات PHP
- **🧊 Haskell** - cabal, stack, ghcup
- **🔬 Scientific** - Spack, Conda/Miniconda, Mamba

### 🛠️ التثبيت

#### التثبيت السريع:
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
rm -f ~/gt-clpm-backup-*.txt
```

### 🎯 طريقة الاستخدام
```bash
gt-clpm
```

### 📄 التنقل في نتائج البحث (جديد في v1.2.2)
```
Search Results (47) — Page 1/5:
════════════════════════════════════════
1. Telegram Desktop [flathub/stable]
   ...
10. ...

  n → Next page (results 11-20)
  0 → Return to menu

Enter package number (1-47, n/p/0): n   ← للصفحة التالية
```

### 📁 الهيكل التنظيمي
```
GT-CLPM/
├── install.sh        # مثبت سريع
├── uninstall.sh      # مزيل سريع
├── GT-CLPM/
│   └── gt-clpm.sh    # البرنامج الرئيسي (يُحدَّث في مكانه)
└── README.md         # هذا الملف
```

### 🐛 الإبلاغ عن المشكلات
[📝 إنشاء إشكالية على GitHub](https://github.com/SalehGNUTUX/GT-CLPM/issues)

---

## 🇬🇧 English

### 🚀 Overview
GT-CLPM is a comprehensive command-line package manager for GNU/Linux systems. It provides a unified terminal interface for managing packages across 13+ package managers, with full support for language-specific package tools and universal formats like Flatpak and Snap.

### ✨ Key Features
- 🌐 Multi-language support (Arabic & English)
- 📦 Support for 13+ system package managers
- 📱 Fixed Flatpak & Snap search with interactive selection
- 📄 Paginated search results (n/p navigation)
- ⚙️ System maintenance and backup/restore tools
- 🎨 Colorful and user-friendly terminal interface
- 🔧 Automatic broken package repair
- 🧠 Smart package removal (browse & select)
- ➕ Repository/PPA management per distro
- 🐍 Full programming language package manager support

### 🆕 What's New in v1.2.2

- 🔍 **Fixed Flatpak search** — correct results including `org.telegram.desktop` and similar
- 📄 **Paginated results** — `n` next page, `p` previous page, up to 50 results loaded
- 🛠️ **All language tool menus fully implemented** — Ruby, Rust, Go, Java, PHP, Haskell, Scientific
- ➕ **Repository management** — PPA (APT), COPR (DNF), AUR helper (Pacman), Packman (Zypper)
- 🍺 **Homebrew support** added
- 🔬 **Scientific tools** — Spack, Conda/Miniconda, Mamba with environment management
- 🐍 **Enhanced Python tools** — pip --user, pipx, named venvs
- 🐹 **Go auto-install** if not present

### 📋 Supported System Package Managers
- **APT** (Debian, Ubuntu, Mint)
- **DNF/YUM** (Fedora, RHEL, CentOS)
- **Pacman** (Arch, Manjaro, EndeavourOS)
- **Zypper** (openSUSE)
- **Eopkg** (Solus)
- **XBPS** (Void Linux)
- **Emerge** (Gentoo)
- **PKG** (FreeBSD)
- **APK** (Alpine Linux)
- **Nix** (NixOS)
- **Homebrew** (Linux/macOS)
- **Flatpak** (Universal)
- **Snap** (Canonical)

### 🛠️ Programming Language Package Managers
- **🐍 Python** - pip, pip --user, pipx, virtual environments
- **📦 Node.js** - npm, yarn, pnpm, npx
- **💎 Ruby** - gem, bundler
- **🦀 Rust** - cargo, rustup
- **🐹 Go** - go install (auto-installs Go if missing)
- **☕ Java** - maven, gradle, SDKMAN, JDK switching
- **🐘 PHP** - composer, PHP extensions
- **🧊 Haskell** - cabal, stack, ghcup
- **🔬 Scientific** - Spack, Conda/Miniconda, Mamba

### 🛠️ Installation

#### Quick Install:
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
rm -f ~/gt-clpm-backup-*.txt
```

### 🎯 Usage
```bash
gt-clpm
```

### 📄 Paginated Search Results (new in v1.2.2)
```
Search Results (47) — Page 1/5:
════════════════════════════════════════
1. Telegram Desktop [flathub/stable]
   Messaging app
   ID: org.telegram.desktop
...
10. ...

  n → Next page (results 11-20)
  0 → Return to menu

Enter package number (1-47, n/p/0):
```

### 📁 Project Structure
```
GT-CLPM/
├── install.sh        # Quick installer
├── uninstall.sh      # Quick uninstaller
├── GT-CLPM/
│   └── gt-clpm.sh    # Main program (updated in-place)
└── README.md         # This file
```

### 🐛 Reporting Issues
[📝 Create GitHub Issue](https://github.com/SalehGNUTUX/GT-CLPM/issues)

---

## 📄 الرخصة / License
هذا المشروع مرخص تحت رخصة GPLv2. راجع ملف LICENSE للتفاصيل.  
This project is licensed under GPLv2. See LICENSE file for details.

## 👥 المساهمة / Contributing
المساهمات مرحب بها! لا تتردد في عمل Fork وعمل Pull Request.  
Contributions are welcome! Feel free to fork and submit Pull Requests.

## 📞 الدعم / Support
- 💬 GitHub Issues: [https://github.com/SalehGNUTUX/GT-CLPM/issues](https://github.com/SalehGNUTUX/GT-CLPM/issues)

---
