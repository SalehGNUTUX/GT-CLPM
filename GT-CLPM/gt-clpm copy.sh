#!/bin/bash
# GT-CLPM - GNUTUX Command Line Package Manager
# رخصة GPLv2
# تطوير: GNUTUX

VERSION="1.0.0"
LANG="en" # اللغة الافتراضية

# تهيئة المتغيرات
PKG_MANAGER=""
declare -A PKG_COMMANDS=()

# --- دوال اللغة والواجهة ---
load_language() {
  if [ "$LANG" == "ar" ]; then
    # النصوص العربية
    MSG_WELCOME="مرحبًا بكم في GT-CLPM - مدير الحزم من GNUTUX"
    MSG_SELECT_ACTION="اختر الإجراء المطلوب:"
    MSG_INSTALL_PKG="تثبيت حزمة"
    MSG_REMOVE_PKG="إزالة حزمة"
    MSG_UPDATE_SYS="تحديث النظام"
    MSG_SEARCH_PKG="بحث عن حزمة"
    MSG_FLATPAK="إدارة حزم Flatpak"
    MSG_SNAP="إدارة حزم Snap"
    MSG_REPAIR="إصلاح المشاكل"
    MSG_ADD_REPO="إضافة مستودع"
    MSG_EXIT="خروج"
    MSG_INVALID_OPT="خيار غير صالح!"
    MSG_PKG_NOT_FOUND="لم يتم العثور على مدير الحزم!"
    MSG_PKG_INSTALLED="تم تثبيت الحزمة بنجاح!"
    MSG_PKG_REMOVED="تم إزالة الحزمة بنجاح!"
    MSG_FLATPAK_INSTALL="تثبيت Flatpak بنجاح!"
    MSG_SNAP_INSTALL="تم تثبيت Snap بنجاح!"
    MSG_REPAIR_COMPLETED="تم إصلاح المشاكل بنجاح!"
  else
    # English texts
    MSG_WELCOME="Welcome to GT-CLPM - GNUTUX Package Manager"
    MSG_SELECT_ACTION="Select an action:"
    MSG_INSTALL_PKG="Install package"
    MSG_REMOVE_PKG="Remove package"
    MSG_UPDATE_SYS="Update system"
    MSG_SEARCH_PKG="Search for package"
    MSG_FLATPAK="Manage Flatpak packages"
    MSG_SNAP="Manage Snap packages"
    MSG_REPAIR="Repair issues"
    MSG_ADD_REPO="Add repository"
    MSG_EXIT="Exit"
    MSG_INVALID_OPT="Invalid option!"
    MSG_PKG_NOT_FOUND="Package manager not found!"
    MSG_PKG_INSTALLED="Package installed successfully!"
    MSG_PKG_REMOVED="Package removed successfully!"
    MSG_FLATPAK_INSTALL="Flatpak installed successfully!"
    MSG_SNAP_INSTALL="Snap installed successfully!"
    MSG_REPAIR_COMPLETED="Repair completed successfully!"
  fi
}

# --- اكتشاف مدير الحزم ---
detect_pkg_manager() {
  declare -A pkg_managers=(
    ["apt"]="/etc/debian_version"
    ["dnf"]="/etc/fedora-release"
    ["pacman"]="/etc/arch-release"
    ["zypper"]="/etc/SuSE-release"
    ["eopkg"]="/etc/solus-release"
    ["xbps-install"]="/etc/void-version"
    ["emerge"]="/etc/gentoo-release"
  )

  for manager in "${!pkg_managers[@]}"; do
    if [ -x "$(command -v $manager)" ] || [ -f "${pkg_managers[$manager]}" ]; then
      PKG_MANAGER="$manager"
      set_pkg_manager_commands
      return 0
    fi
  done

  echo "$MSG_PKG_NOT_FOUND"
  return 1
}

set_pkg_manager_commands() {
  case "$PKG_MANAGER" in
    "apt")
      PKG_COMMANDS=(
        ["INSTALL"]="sudo apt install -y"
        ["REMOVE"]="sudo apt remove -y"
        ["UPDATE"]="sudo apt update"
        ["UPGRADE"]="sudo apt upgrade -y"
        ["SEARCH"]="apt search"
        ["REPAIR"]="sudo apt --fix-broken install && sudo apt autoremove -y"
        ["ADD_REPO"]="sudo add-apt-repository -y"
      )
      ;;
    "dnf")
      PKG_COMMANDS=(
        ["INSTALL"]="sudo dnf install -y"
        ["REMOVE"]="sudo dnf remove -y"
        ["UPDATE"]="sudo dnf update -y"
        ["UPGRADE"]="sudo dnf upgrade -y"
        ["SEARCH"]="dnf search"
        ["REPAIR"]="sudo dnf clean all && sudo dnf autoremove -y"
        ["ADD_REPO"]="sudo dnf config-manager --add-repo"
      )
      ;;
    "pacman")
      PKG_COMMANDS=(
        ["INSTALL"]="sudo pacman -S --noconfirm"
        ["REMOVE"]="sudo pacman -R --noconfirm"
        ["UPDATE"]="sudo pacman -Sy"
        ["UPGRADE"]="sudo pacman -Syu --noconfirm"
        ["SEARCH"]="pacman -Ss"
        ["REPAIR"]="sudo pacman -Syy --noconfirm && sudo pacman -Sc --noconfirm"
        ["ADD_REPO"]="echo 'Edit /etc/pacman.conf manually'"
      )
      ;;
    "zypper")
      PKG_COMMANDS=(
        ["INSTALL"]="sudo zypper install -y"
        ["REMOVE"]="sudo zypper remove -y"
        ["UPDATE"]="sudo zypper refresh"
        ["UPGRADE"]="sudo zypper update -y"
        ["SEARCH"]="zypper search"
        ["REPAIR"]="sudo zypper verify && sudo zypper dup --allow-vendor-change"
        ["ADD_REPO"]="sudo zypper addrepo"
      )
      ;;
    "eopkg")
      PKG_COMMANDS=(
        ["INSTALL"]="sudo eopkg install -y"
        ["REMOVE"]="sudo eopkg remove -y"
        ["UPDATE"]="sudo eopkg update-repo"
        ["UPGRADE"]="sudo eopkg upgrade -y"
        ["SEARCH"]="eopkg search"
        ["REPAIR"]="sudo eopkg check | sudo eopkg fix -y"
        ["ADD_REPO"]="sudo eopkg add-repo"
      )
      ;;
    "xbps-install")
      PKG_COMMANDS=(
        ["INSTALL"]="sudo xbps-install -Suy"
        ["REMOVE"]="sudo xbps-remove -y"
        ["UPDATE"]="sudo xbps-install -Su"
        ["UPGRADE"]="sudo xbps-install -Suy"
        ["SEARCH"]="xbps-query -Rs"
        ["REPAIR"]="sudo xbps-pkgdb -a"
        ["ADD_REPO"]="echo 'Edit /etc/xbps.d/*.conf manually'"
      )
      ;;
    "emerge")
      PKG_COMMANDS=(
        ["INSTALL"]="sudo emerge -av"
        ["REMOVE"]="sudo emerge --unmerge"
        ["UPDATE"]="sudo emerge --sync"
        ["UPGRADE"]="sudo emerge -uDU @world"
        ["SEARCH"]="emerge --search"
        ["REPAIR"]="sudo emerge --depclean && sudo revdep-rebuild"
        ["ADD_REPO"]="echo 'Edit /etc/portage/repos.conf manually'"
      )
      ;;
    *)
      echo "Unsupported package manager: $PKG_MANAGER"
      return 1
      ;;
  esac
}

# --- دوال إدارة الحزم ---
install_package() {
  read -p "$([ "$LANG" == "ar" ] && echo "أدخل اسم الحزمة لتثبيتها: " || echo "Enter package name to install: ")" pkg
  eval "${PKG_COMMANDS[INSTALL]} $pkg"
  echo "$MSG_PKG_INSTALLED"
  pause_and_return
}

remove_package() {
  read -p "$([ "$LANG" == "ar" ] && echo "أدخل اسم الحزمة لإزالتها: " || echo "Enter package name to remove: ")" pkg
  eval "${PKG_COMMANDS[REMOVE]} $pkg"
  echo "$MSG_PKG_REMOVED"
  pause_and_return
}

update_system() {
  eval "${PKG_COMMANDS[UPDATE]} && ${PKG_COMMANDS[UPGRADE]}"
  pause_and_return
}

search_package() {
  read -p "$([ "$LANG" == "ar" ] && echo "أدخل اسم الحزمة للبحث عنها: " || echo "Enter package name to search: ")" pkg
  eval "${PKG_COMMANDS[SEARCH]} $pkg"
  pause_and_return
}

# --- إدارة Flatpak ---
check_install_flatpak() {
  if ! command -v flatpak &> /dev/null; then
    echo "Flatpak not found. Installing..."
    case "$PKG_MANAGER" in
      "apt") sudo apt install -y flatpak ;;
      "dnf") sudo dnf install -y flatpak ;;
      "pacman") sudo pacman -S --noconfirm flatpak ;;
      "zypper") sudo zypper install -y flatpak ;;
      "eopkg") sudo eopkg install -y flatpak ;;
      "xbps-install") sudo xbps-install -Suy flatpak ;;
      *) echo "Cannot install Flatpak automatically on this system"; return 1 ;;
    esac

    flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    echo "$MSG_FLATPAK_INSTALL"
  fi
}

flatpak_menu() {
  check_install_flatpak || return

  while true; do
    clear
    echo "=== Flatpak Management ==="
    echo "1. $([ "$LANG" == "ar" ] && echo "تثبيت حزمة Flatpak" || echo "Install Flatpak package")"
    echo "2. $([ "$LANG" == "ar" ] && echo "إزالة حزمة Flatpak" || echo "Remove Flatpak package")"
    echo "3. $([ "$LANG" == "ar" ] && echo "عرض الحزم المثبتة" || echo "List installed Flatpaks")"
    echo "4. $([ "$LANG" == "ar" ] && echo "تحديث الحزم" || echo "Update Flatpaks")"
    echo "5. $([ "$LANG" == "ar" ] && echo "العودة للقائمة الرئيسية" || echo "Return to main menu")"

    read -p "> " choice

    case $choice in
      1)
        read -p "$([ "$LANG" == "ar" ] && echo "أدخل اسم حزمة Flatpak: " || echo "Enter Flatpak package name: ")" pkg
        flatpak install flathub "$pkg" -y
        ;;
      2)
        read -p "$([ "$LANG" == "ar" ] && echo "أدخل اسم الحزمة للإزالة: " || echo "Enter Flatpak package to remove: ")" pkg
        flatpak remove "$pkg" -y
        ;;
      3) flatpak list ;;
      4) flatpak update -y ;;
      5) return ;;
      *) echo "$MSG_INVALID_OPT" ;;
    esac

    read -p "$([ "$LANG" == "ar" ] && echo "اضغط Enter للمتابعة..." || echo "Press Enter to continue...")"
  done
}

# --- إدارة Snap ---
check_install_snap() {
  if ! command -v snap &> /dev/null; then
    echo "Snap not found. Installing..."
    case "$PKG_MANAGER" in
      "apt")
        sudo apt install -y snapd
        sudo systemctl enable --now snapd.socket
        ;;
      "dnf")
        sudo dnf install -y snapd
        sudo ln -s /var/lib/snapd/snap /snap
        sudo systemctl enable --now snapd.socket
        ;;
      "pacman")
        if command -v yay &> /dev/null; then
          yay -S snapd --noconfirm
        elif command -v paru &> /dev/null; then
          paru -S snapd --noconfirm
        else
          echo "Please install snapd manually from AUR"
          return 1
        fi
        sudo systemctl enable --now snapd.socket
        ;;
      "zypper")
        sudo zypper addrepo --refresh https://download.opensuse.org/repositories/system:/snappy/openSUSE_Leap_15.4 snappy
        sudo zypper --gpg-auto-import-keys refresh
        sudo zypper dup --from snappy
        sudo zypper install -y snapd
        sudo systemctl enable --now snapd.socket
        ;;
      *)
        echo "Cannot install Snap automatically on this system"
        return 1
        ;;
    esac
    echo "$MSG_SNAP_INSTALL"
  fi
}

snap_menu() {
  check_install_snap || return

  while true; do
    clear
    echo "=== Snap Management ==="
    echo "1. $([ "$LANG" == "ar" ] && echo "تثبيت حزمة Snap" || echo "Install Snap package")"
    echo "2. $([ "$LANG" == "ar" ] && echo "إزالة حزمة Snap" || echo "Remove Snap package")"
    echo "3. $([ "$LANG" == "ar" ] && echo "عرض الحزم المثبتة" || echo "List installed Snaps")"
    echo "4. $([ "$LANG" == "ar" ] && echo "تحديث الحزم" || echo "Update Snaps")"
    echo "5. $([ "$LANG" == "ar" ] && echo "العودة للقائمة الرئيسية" || echo "Return to main menu")"

    read -p "> " choice

    case $choice in
      1)
        read -p "$([ "$LANG" == "ar" ] && echo "أدخل اسم حزمة Snap: " || echo "Enter Snap package name: ")" pkg
        sudo snap install "$pkg"
        ;;
      2)
        read -p "$([ "$LANG" == "ar" ] && echo "أدخل اسم الحزمة للإزالة: " || echo "Enter Snap package to remove: ")" pkg
        sudo snap remove "$pkg"
        ;;
      3) snap list ;;
      4) sudo snap refresh ;;
      5) return ;;
      *) echo "$MSG_INVALID_OPT" ;;
    esac

    read -p "$([ "$LANG" == "ar" ] && echo "اضغط Enter للمتابعة..." || echo "Press Enter to continue...")"
  done
}

# --- إصلاح النظام ---
repair_system() {
  echo "$([ "$LANG" == "ar" ] && echo "جاري إصلاح النظام باستخدام $PKG_MANAGER..." || echo "Running repair operations for $PKG_MANAGER...")"

  eval "${PKG_COMMANDS[REPAIR]}"

  echo "$MSG_REPAIR_COMPLETED"
  sleep 2
}

# --- إدارة المستودعات ---
add_repository() {
  echo "$([ "$LANG" == "ar" ] && echo "اختر نوع المستودع لإضافته:" || echo "Select repository type to add:")"
  echo "1. $([ "$LANG" == "ar" ] && echo "المستودع الرئيسي ($PKG_MANAGER)" || echo "Main repository ($PKG_MANAGER)")"
  echo "2. $([ "$LANG" == "ar" ] && echo "Flatpak (Flathub)" || echo "Flatpak (Flathub)")"
  echo "3. $([ "$LANG" == "ar" ] && echo "Snap" || echo "Snap")"
  echo "4. $([ "$LANG" == "ar" ] && echo "إلغاء" || echo "Cancel")"

  read -p "> " choice

  case $choice in
    1)
      read -p "$([ "$LANG" == "ar" ] && echo "أدخل المستودع لإضافته:" || echo "Enter repository to add:") " repo
      eval "${PKG_COMMANDS[ADD_REPO]} \"$repo\""
      eval "${PKG_COMMANDS[UPDATE]}"
      ;;
    2)
      check_install_flatpak
      flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
      ;;
    3)
      check_install_snap
      echo "$([ "$LANG" == "ar" ] && echo "يتم إدارة مستودعات Snap تلقائيًا لكل حزمة" || echo "Snap repositories are managed per package automatically")"
      ;;
    4) return ;;
    *) echo "$MSG_INVALID_OPT" ;;
  esac
}

# --- دوال مساعدة ---
pause_and_return() {
  read -p "$([ "$LANG" == "ar" ] && echo "اضغط Enter للعودة إلى القائمة..." || echo "Press Enter to return to menu...")"
  main_menu
}

change_language() {
  if [ "$LANG" == "en" ]; then
    LANG="ar"
    echo "$([ "$LANG" == "ar" ] && echo "تم تغيير اللغة إلى العربية" || echo "Language changed to Arabic")"
  else
    LANG="en"
    echo "Language changed to English"
  fi
  load_language
  sleep 1
}

show_version() {
  echo "GT-CLPM v$VERSION - GNUTUX Command Line Package Manager"
  echo "License: GPLv2"
}

# --- الواجهة الرئيسية ---
main_menu() {
  clear
  echo "$MSG_WELCOME"
  echo "-------------------------------------"
  echo "$MSG_SELECT_ACTION"
  echo "1) $MSG_INSTALL_PKG"
  echo "2) $MSG_REMOVE_PKG"
  echo "3) $MSG_UPDATE_SYS"
  echo "4) $MSG_SEARCH_PKG"
  echo "5) $MSG_FLATPAK"
  echo "6) $MSG_SNAP"
  echo "7) $MSG_REPAIR"
  echo "8) $MSG_ADD_REPO"
  echo "9) $([ "$LANG" == "ar" ] && echo "تغيير اللغة" || echo "Change language")"
  echo "10) $([ "$LANG" == "ar" ] && echo "عرض الإصدار" || echo "Show version")"
  echo "11) $MSG_EXIT"
  echo "-------------------------------------"
  echo "$([ "$LANG" == "ar" ] && echo "مدير الحزم الحالي: $PKG_MANAGER" || echo "Current package manager: $PKG_MANAGER")"
  echo "-------------------------------------"

  read -p "> " choice

  case $choice in
    1) install_package ;;
    2) remove_package ;;
    3) update_system ;;
    4) search_package ;;
    5) flatpak_menu ;;
    6) snap_menu ;;
    7) repair_system ;;
    8) add_repository ;;
    9) change_language; main_menu ;;
    10) show_version; pause_and_return ;;
    11) exit 0 ;;
    *) echo "$MSG_INVALID_OPT"; sleep 1; main_menu ;;
  esac
}

# --- بدء البرنامج ---
detect_pkg_manager || exit 1
load_language
main_menu
