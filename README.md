# GT-CLPM - GNUTUX Command Line Package Manager

![GT-CLPM](https://img.shields.io/badge/GT--CLPM-Package_Manager-blue)
![Version](https://img.shields.io/badge/Version-1.1-green)
![License](https://img.shields.io/badge/License-GPLv2-orange)
![Platform](https://img.shields.io/badge/Platform-Linux-lightgrey)

<img width="256" height="256" alt="GT-CLPM Logo" src="https://github.com/user-attachments/assets/6805474c-a20d-4ba4-b066-cf83536dbf31" />

مدير حزم سطر الأوامر الشامل لأنظمة جنو/لينكس  
**الإصدار:** 1.1  
**المطور:** GNUTUX  
**الرخصة:** GPLv2

---

## 🆕 ما الجديد في الإصدار 1.1

### ✨ الميزات الجديدة
- 🧠 **الإزالة الذكية** - تصفح الحزم المثبتة وإزالتها بسهولة
- 🔢 **التثبيت من نتائج البحث** - اختر الحزمة من قائمة البحث المرقمة
- 🛠️ **أدوات تثبيت إضافية** - دعم مديري حزم اللغات البرمجية
- 🐍 **مدير حزم بايثون** - تثبيت وإزالة حزم Python بطرق آمنة
- 📦 **مدير حزم Node.js** - إدارة حزم npm/yarn/pnpm
- 🎯 **واجهة محسنة** - رموز تعبيرية وإخراج أكثر تنظيماً

### 📊 مقارنة بين الإصدارين

| الميزة | v1.0 | v1.1 |
|--------|------|------|
| الإزالة الذكية | ❌ | ✅ |
| التثبيت من نتائج البحث | ❌ | ✅ |
| أدوات بايثون (pip/pipx) | ❌ | ✅ |
| أدوات Node.js (npm/yarn) | ❌ | ✅ |
| واجهة مترابطة مع رموز | أساسية | 🎨 محسنة |
| البحث التفاعلي | أساسي | 🔢 تفاعلي |
| إدارة البيئات الافتراضية | ❌ | ✅ |

---

## 🇲🇦 العربية 🇸🇦

### 🚀 النظرة العامة
GT-CLPM هو مدير حزم سطر أوامر شامل لأنظمة جنو/لينكس، يُتيح لك إدارة الحزم عبر أشهر مديري الحزم من خلال واجهة طرفية واحدة موحدة وسهلة الاستخدام.

### ✨ المميزات الرئيسية
- 🌐 دعم لغات متعددة (العربية والإنجليزية)
- 📦 دعم 12+ مدير حزم مختلف
- 📱 دعم فلاتباك وسناب
- ⚙️ أدوات صيانة النظام والنسخ الاحتياطي
- 🎨 واجهة ملونة وسهلة الاستخدام
- 🔧 إصلاح الحزم المعطلة تلقائياً
- 🧠 إزالة ذكية للحزم
- 🔢 تثبيت تفاعلي من نتائج البحث
- 🐍 دعم مديري حزم اللغات البرمجية

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
- **Flatpak** (التطبيقات العالمية)
- **Snap** (حزم كانونيكال)

### 🛠️ مديرو حزم اللغات البرمجية
- **🐍 Python** - pip, pipx, virtual environments
- **📦 Node.js** - npm, yarn, pnpm, npx
- **💎 Ruby** - gem
- **🦀 Rust** - cargo
- **🐹 Go** - go install
- **☕ Java** - maven, gradle
- **🐘 PHP** - composer
- **🧊 Haskell** - cabal, stack
- **🔬 Scientific** - Spack

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

### 🧠 الميزات الجديدة في v1.1

#### الإزالة الذكية
```bash
# تصفح جميع الحزم المثبتة وإزالة ما تريد
gt-clpm → مدير الحزم → إزالة ذكية
```

#### البحث التفاعلي
```bash
# ابحث عن حزمة وثبتها مباشرة من القائمة
gt-clpm → مدير الحزم → بحث → اختر رقم الحزمة
```

#### إدارة حزم بايثون
```bash
gt-clpm → طرق تثبيت أخرى → بايثون
# الخيارات المتاحة:
# 1. تثبيت بـ pipx (موصى به)
# 2. تثبيت في بيئة افتراضية  
# 3. إزالة حزم بايثون
# 4. عرض الحزم المثبتة
```

#### إدارة حزم Node.js
```bash
gt-clpm → طرق تثبيت أخرى → Node.js
# الخيارات المتاحة:
# 1. تثبيت حزمة بشكل عام
# 2. تثبيت حزمة بشكل محلي
# 3. تشغيل حزمة بـ npx
# 4. إزالة حزمة Node.js
```

### 📸 لقطات الشاشة

<img width="1440" height="900" alt="واجهة البرنامج" src="https://github.com/user-attachments/assets/91287643-8f19-4af6-a78e-23cfea894b68" />

*القائمة الرئيسية المحسنة برموز تعبيرية*

<img width="1440" height="900" alt="البحث التفاعلي" src="https://github.com/user-attachments/assets/sample-search" />

*البحث التفاعلي مع الترقيم - ميزة جديدة في v1.1*

### 📁 الهيكل التنظيمي
```
GT-CLPM/
├── install.sh          # مثبت سريع
├── uninstall.sh        # مزيل سريع
├── gt-clpm-v1.1.sh     # النسخة الرئيسية v1.1
├── gt-clpm-v1.0.sh     # النسخة السابقة v1.0
└── README.md           # هذا الملف
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
- 🧠 Smart package removal
- 🔢 Interactive installation from search results
- 🐍 Programming language package managers

### 🆕 What's New in Version 1.1

#### New Features
- 🧠 **Smart Remove** - Browse and remove installed packages easily
- 🔢 **Install from Search Results** - Select packages from numbered search lists
- 🛠️ **Additional Installers** - Support for programming language package managers
- 🐍 **Python Tools** - Install/remove Python packages safely
- 📦 **Node.js Tools** - Manage npm/yarn/pnpm packages
- 🎯 **Enhanced Interface** - Emojis and better organized output

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
- **Flatpak** (Universal applications)
- **Snap** (Canonical packages)

### 🛠️ Programming Language Package Managers
- **🐍 Python** - pip, pipx, virtual environments
- **📦 Node.js** - npm, yarn, pnpm, npx
- **💎 Ruby** - gem
- **🦀 Rust** - cargo
- **🐹 Go** - go install
- **☕ Java** - maven, gradle
- **🐘 PHP** - composer
- **🧊 Haskell** - cabal, stack
- **🔬 Scientific** - Spack

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

### 🧠 New Features in v1.1

#### Smart Removal
```bash
# Browse all installed packages and remove what you want
gt-clpm → Package Manager → Smart Remove
```

#### Interactive Search
```bash
# Search for a package and install directly from the list
gt-clpm → Package Manager → Search → Choose package number
```

#### Python Package Management
```bash
gt-clpm → Other Installation Methods → Python
# Available options:
# 1. Install with pipx (recommended)
# 2. Install in virtual environment
# 3. Remove Python packages
# 4. List installed packages
```

#### Node.js Package Management
```bash
gt-clpm → Other Installation Methods → Node.js
# Available options:
# 1. Install package globally
# 2. Install package locally
# 3. Run package with npx
# 4. Remove Node.js package
```

### 📸 Screenshots

<img width="1440" height="900" alt="Program Interface" src="https://github.com/user-attachments/assets/754d5049-e673-42d3-9c97-3c574f337917" />

*Enhanced main menu with emojis*

<img width="1440" height="900" alt="Interactive Search" src="https://github.com/user-attachments/assets/sample-search-en" />

*Interactive search with numbering - new in v1.1*

### 📁 Project Structure
```
GT-CLPM/
├── install.sh          # Quick installer
├── uninstall.sh        # Quick uninstaller
├── gt-clpm-v1.1.sh     # Main program v1.1
├── gt-clpm-v1.0.sh     # Previous version v1.0
└── README.md           # This file
```

### 🐛 Reporting Issues
To report bugs or request new features:  
[📝 Create GitHub Issue](https://github.com/SalehGNUTUX/GT-CLPM/issues)

---

## 📄 الرخصة / License
هذا المشروع مرخص تحت رخصة GPLv2. راجع ملف LICENSE للتفاصيل.  
This project is licensed under GPLv2. See LICENSE file for details.

## 👥 المساهمة / Contributing
المساهمات مرحب بها! لا تتردد في عمل Fork وعمل Pull Request.  
Contributions are welcome! Feel free to fork and submit Pull Requests.

## 📞 الدعم / Support
- 📧 البريد الإلكتروني / Email: [إضافة بريدك هنا / Add your email here]
- 💬 GitHub Issues: [رابط Issues / Issues Link](https://github.com/SalehGNUTUX/GT-CLPM/issues)

---
