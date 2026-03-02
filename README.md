# GT-CLPM - GNUTUX Command Line Package Manager

![GT-CLPM](https://img.shields.io/badge/GT--CLPM-Package_Manager-blue)
![Version](https://img.shields.io/badge/Version-1.4.0-green)
![License](https://img.shields.io/badge/License-GPLv2-orange)
![Platform](https://img.shields.io/badge/Platform-Linux-lightgrey)

<img width="256" height="256" alt="GT-CLPM Logo" src="https://github.com/user-attachments/assets/6805474c-a20d-4ba4-b066-cf83536dbf31" />

مدير حزم سطر الأوامر الشامل لأنظمة جنو/لينكس  
**الإصدار:** 1.4.0  
**المطور:** GNUTUX  
**الرخصة:** GPLv2

---

## 🆕 ما الجديد في الإصدار 1.4.0

### ✨ الميزات الجديدة
- 🖥️ **دعم KDialog و Zenity** — اكتشاف تلقائي لنوع سطح المكتب (GTK أو Qt/KDE) واختيار الأداة المناسبة
- 🔀 **التبديل اليدوي بين Zenity و KDialog** مباشرة من قائمة الإعدادات
- 🔐 **إصلاح صلاحيات الجذر** — نافذة كلمة مرور رسومية عبر `pkexec` أو `SUDO_ASKPASS` بدون طرفية
- ⬆️ **ترقية شاملة (Dist Upgrade)** — خيار فرعي تحت قائمة التحديث لكل مدراء الحزم المدعومين
- 📦 **تثبيت تلقائي للتبعيات** مع رسالة خطأ رسومية تذكر أسماء التبعيات وأوامر تثبيتها
- 🎨 **تطبيق سمة النظام تلقائياً** (GTK_THEME من gsettings)

### 📊 مقارنة الإصدارات

| الميزة | v1.0 | v1.1 | v1.2.2 | v1.4.0 |
|--------|------|------|--------|--------|
| الإزالة الذكية | ❌ | ✅ | ✅ | ✅ |
| التثبيت من نتائج البحث | ❌ | ✅ | ✅ | ✅ |
| بحث فلاتباك صحيح | ❌ | ⚠️ | ✅ | ✅ |
| أدوات اللغات كاملة | ❌ | ⚠️ | ✅ | ✅ |
| إدارة المستودعات | ❌ | ❌ | ✅ | ✅ |
| Spack / Conda / Mamba | ❌ | ❌ | ✅ | ✅ |
| دعم KDialog (KDE/Qt) | ❌ | ❌ | ❌ | ✅ |
| اكتشاف سطح المكتب تلقائياً | ❌ | ❌ | ❌ | ✅ |
| نافذة كلمة مرور رسومية | ❌ | ❌ | ❌ | ✅ |
| ترقية شاملة (Dist Upgrade) | ❌ | ❌ | ❌ | ✅ |
| تبديل Zenity/KDialog من الإعدادات | ❌ | ❌ | ❌ | ✅ |

---

## 🇲🇦 العربية 🇸🇦

### 🚀 النظرة العامة
GT-CLPM هو مدير حزم شامل لأنظمة جنو/لينكس، يُتيح إدارة الحزم عبر أشهر مديري الحزم من خلال واجهة رسومية موحدة تدعم كلاً من بيئات GTK (Zenity) وبيئات Qt/KDE (KDialog) مع اكتشاف تلقائي لنوع سطح المكتب.

### 🖥️ لقطات الشاشة

| الواجهة الإنجليزية | الواجهة العربية |
|---|---|
| ![EN](https://github.com/SalehGNUTUX/GT-CLPM/blob/main/screenshot/GT-CLPM-GUI-EN.png?raw=true) | ![AR](https://github.com/SalehGNUTUX/GT-CLPM/blob/main/screenshot/GT-CLPM-GUI-AR.png?raw=true) |

### ✨ المميزات الرئيسية
- 🌐 دعم لغات متعددة (العربية والإنجليزية)
- 📦 دعم 13+ مدير حزم مختلف
- 🖥️ دعم Zenity (GTK) و KDialog (Qt/KDE) مع اكتشاف تلقائي
- 🔐 نافذة كلمة مرور رسومية عند الحاجة لصلاحيات الجذر
- ⬆️ ترقية شاملة للنظام (Dist Upgrade) لكل المدراء المدعومين
- 📱 دعم فلاتباك وسناب مع بحث تفاعلي مُصلَح
- ⚙️ أدوات صيانة النظام والنسخ الاحتياطي
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

### 📥 التثبيت

#### 🖥️ تثبيت الواجهة الرسومية (GUI):
```bash
curl -fsSL https://raw.githubusercontent.com/SalehGNUTUX/GT-CLPM/main/install-gui.sh | bash
```

#### 💻 تثبيت نسخة سطر الأوامر (CLI):
```bash
curl -fsSL https://raw.githubusercontent.com/SalehGNUTUX/GT-CLPM/main/install.sh | bash
```

#### باستخدام wget (CLI):
```bash
wget -q -O - https://raw.githubusercontent.com/SalehGNUTUX/GT-CLPM/main/install.sh | bash
```

#### التثبيت اليدوي:
```bash
git clone https://github.com/SalehGNUTUX/GT-CLPM.git
cd GT-CLPM
# للواجهة الرسومية
chmod +x install-gui.sh && ./install-gui.sh
# لسطر الأوامر
chmod +x install.sh && ./install.sh
```

### 📦 تنزيل AppImage (بدون تثبيت)

| الإصدار | الرابط |
|---------|--------|
| واجهة رسومية (GUI) | [GT-CLPM-GUI-x86_64.AppImage](https://github.com/SalehGNUTUX/GT-CLPM/releases/download/GT-CLPM-2026-x86_64.AppImage/GT-CLPM-GUI-x86_64.AppImage) |
| سطر أوامر (CLI) | [GT-CLPM_.CLI.-x86_64.AppImage](https://github.com/SalehGNUTUX/GT-CLPM/releases/download/GT-CLPM-2026-x86_64.AppImage/GT-CLPM_.CLI.-x86_64.AppImage) |
| جميع الإصدارات | [صفحة الإصدارات](https://github.com/SalehGNUTUX/GT-CLPM/releases) |

```bash
# تشغيل AppImage مباشرة
chmod +x GT-CLPM-GUI-x86_64.AppImage
./GT-CLPM-GUI-x86_64.AppImage
```

### 🗑️ إلغاء التثبيت

#### إلغاء تثبيت الواجهة الرسومية عن بُعد:
```bash
curl -fsSL https://raw.githubusercontent.com/SalehGNUTUX/GT-CLPM/main/uninstall-gui.sh | bash
```

#### إلغاء تثبيت سطر الأوامر عن بُعد:
```bash
curl -fsSL https://raw.githubusercontent.com/SalehGNUTUX/GT-CLPM/main/uninstall.sh | bash
```

#### إلغاء التثبيت اليدوي:
```bash
# الواجهة الرسومية
sudo rm -f /usr/local/bin/gt-clpm-gui
rm -f ~/.gt-clpm-lang ~/.gt-clpm-mode ~/.gt-clpm-ui
# سطر الأوامر
sudo rm -f /usr/local/bin/gt-clpm
rm -f ~/.gt-clpm-lang
rm -f ~/gt-clpm-backup-*.txt
```

### 🎯 طريقة الاستخدام
```bash
# الواجهة الرسومية
gt-clpm-gui

# سطر الأوامر
gt-clpm
```

### ⚙️ الإعدادات المتاحة
- **تغيير اللغة** — العربية / الإنجليزية
- **تغيير النمط** — فاتح / داكن (يتبع سمة النظام تلقائياً)
- **تغيير أداة الواجهة** — التبديل بين Zenity و KDialog

### 📄 التنقل في نتائج البحث — نسخة سطر الأوامر (CLI)
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

### ⬆️ قائمة التحديث (جديد في v1.4.0)
عند اختيار "تحديث النظام" تظهر قائمة فرعية:
```
┌─────────────────────────────────┐
│  تحديث النظام (upgrade)         │
│  ترقية شاملة (dist-upgrade)     │
│  رجوع                           │
└─────────────────────────────────┘
```
> **ملاحظة:** خيار الترقية الشاملة يعمل مع: APT (dist-upgrade), DNF (distro-sync), Pacman (Syyu), Zypper (dup). في المدراء الأخرى تظهر رسالة توضيحية.

---

## 🇬🇧 English

### 🚀 Overview
GT-CLPM is a comprehensive GUI package manager for GNU/Linux. It provides a unified graphical interface for managing packages across 13+ package managers, with automatic detection of the desktop environment to use Zenity (GTK) or KDialog (Qt/KDE) accordingly.

### 🖥️ Screenshots

| English Interface | Arabic Interface |
|---|---|
| ![EN](https://github.com/SalehGNUTUX/GT-CLPM/blob/main/screenshot/GT-CLPM-GUI-EN.png?raw=true) | ![AR](https://github.com/SalehGNUTUX/GT-CLPM/blob/main/screenshot/GT-CLPM-GUI-AR.png?raw=true) |

### ✨ Key Features
- 🌐 Multi-language support (Arabic & English)
- 📦 Support for 13+ system package managers
- 🖥️ Auto-detects desktop environment — uses Zenity (GTK) or KDialog (Qt/KDE)
- 🔐 Graphical root password prompt via `pkexec` / `SUDO_ASKPASS` — no terminal needed
- ⬆️ Full system upgrade (dist-upgrade) submenu for all supported package managers
- 📱 Fixed Flatpak & Snap search with interactive selection
- ⚙️ System maintenance, backup & restore tools
- 🔧 Automatic broken package repair
- 🧠 Smart package removal (browse & select)
- ➕ Repository/PPA management per distro
- 🐍 Full programming language package manager support

### 🆕 What's New in v1.4.0

- 🖥️ **KDialog support** — auto-detects KDE/Qt desktops and uses KDialog natively
- 🔀 **Manual UI switcher** — switch between Zenity and KDialog from Settings
- 🔐 **Fixed root privileges** — graphical password dialog via `pkexec` or `SUDO_ASKPASS`, no terminal window required
- ⬆️ **Dist Upgrade submenu** — separate option under system update for full distribution upgrade
- 📦 **Auto dependency install** — attempts automatic install of missing UI tools with a clear error message listing dependency names and install commands if it fails
- 🎨 **System theme applied automatically** (reads `GTK_THEME` from gsettings)

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

### 📥 Installation

#### 🖥️ GUI Install:
```bash
curl -fsSL https://raw.githubusercontent.com/SalehGNUTUX/GT-CLPM/main/install-gui.sh | bash
```

#### 💻 CLI Install:
```bash
curl -fsSL https://raw.githubusercontent.com/SalehGNUTUX/GT-CLPM/main/install.sh | bash
```

#### Using wget (CLI):
```bash
wget -q -O - https://raw.githubusercontent.com/SalehGNUTUX/GT-CLPM/main/install.sh | bash
```

#### Manual Installation:
```bash
git clone https://github.com/SalehGNUTUX/GT-CLPM.git
cd GT-CLPM
# For GUI
chmod +x install-gui.sh && ./install-gui.sh
# For CLI
chmod +x install.sh && ./install.sh
```

### 📦 Download AppImage (no install required)

| Edition | Link |
|---------|------|
| Graphical UI (GUI) | [GT-CLPM-GUI-x86_64.AppImage](https://github.com/SalehGNUTUX/GT-CLPM/releases/download/GT-CLPM-2026-x86_64.AppImage/GT-CLPM-GUI-x86_64.AppImage) |
| Command Line (CLI) | [GT-CLPM_.CLI.-x86_64.AppImage](https://github.com/SalehGNUTUX/GT-CLPM/releases/download/GT-CLPM-2026-x86_64.AppImage/GT-CLPM_.CLI.-x86_64.AppImage) |
| All releases | [Releases page](https://github.com/SalehGNUTUX/GT-CLPM/releases) |

```bash
# Run AppImage directly
chmod +x GT-CLPM-GUI-x86_64.AppImage
./GT-CLPM-GUI-x86_64.AppImage
```

### 🗑️ Uninstallation

#### Remote GUI Uninstall:
```bash
curl -fsSL https://raw.githubusercontent.com/SalehGNUTUX/GT-CLPM/main/uninstall-gui.sh | bash
```

#### Remote CLI Uninstall:
```bash
curl -fsSL https://raw.githubusercontent.com/SalehGNUTUX/GT-CLPM/main/uninstall.sh | bash
```

#### Manual Uninstall:
```bash
# GUI
sudo rm -f /usr/local/bin/gt-clpm-gui
rm -f ~/.gt-clpm-lang ~/.gt-clpm-mode ~/.gt-clpm-ui
# CLI
sudo rm -f /usr/local/bin/gt-clpm
rm -f ~/.gt-clpm-lang
rm -f ~/gt-clpm-backup-*.txt
```

### 🎯 Usage
```bash
# GUI
gt-clpm-gui

# CLI
gt-clpm
```

### ⚙️ Available Settings
- **Change language** — Arabic / English
- **Change theme** — Light / Dark (auto-detected from system)
- **Change UI tool** — Switch between Zenity and KDialog

### 📄 Paginated Search Results — CLI
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

### ⬆️ Update Submenu (new in v1.4.0)
Selecting "Update system packages" now opens a submenu:
```
┌──────────────────────────────────────┐
│  Update system (upgrade)             │
│  Full system upgrade (dist-upgrade)  │
│  Back                                │
└──────────────────────────────────────┘
```
> **Note:** dist-upgrade maps to: APT (`dist-upgrade`), DNF (`distro-sync`), Pacman (`-Syyu`), Zypper (`dup`). Other package managers display an informational message.

### 📁 Project Structure
```
GT-CLPM/
├── install.sh            # CLI installer
├── uninstall.sh          # CLI uninstaller
├── install-gui.sh        # GUI installer
├── uninstall-gui.sh      # GUI uninstaller
├── GT-CLPM/
│   ├── gt-clpm.sh        # Main CLI script
│   └── gt-clpm-gui.sh    # Main GUI script
└── README.md             # This file
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
- 📦 Releases: [https://github.com/SalehGNUTUX/GT-CLPM/releases](https://github.com/SalehGNUTUX/GT-CLPM/releases)

---
