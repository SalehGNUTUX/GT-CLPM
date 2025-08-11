#!/bin/bash

# GT-CLPM - GNUTUX Command Line Package Manager
# Version: 1.0
# License: GPLv2
# Developer: GNUTUX
# Description: Universal package manager for GNU/Linux systems

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# Language settings
LANG_FILE="$HOME/.gt-clpm-lang"
if [[ -f "$LANG_FILE" ]]; then
    CURRENT_LANG=$(cat "$LANG_FILE")
else
    CURRENT_LANG="en"
fi

# Language arrays
declare -A MESSAGES_EN=(
    ["title"]="GT-CLPM - GNUTUX Command Line Package Manager"
    ["version"]="Version 1.0 - GPLv2 License - Developed by GNUTUX"
    ["main_menu"]="🏠 Main Menu"
    ["package_manager"]="📦 Package Manager Operations"
    ["flatpak_manager"]="📱 Flatpak Manager"
    ["snap_manager"]="🔧 Snap Manager"
    ["system_tools"]="⚙️  System Tools"
    ["settings"]="🛠️  Settings"
    ["exit"]="🚪 Exit"
    ["install"]="📥 Install package"
    ["remove"]="🗑️  Remove package"
    ["search"]="🔍 Search for package"
    ["update"]="🔄 Update system packages"
    ["upgrade"]="⬆️  Upgrade system packages"
    ["list"]="📋 List installed packages"
    ["info"]="ℹ️  Package information"
    ["fix"]="🔧 Fix broken packages"
    ["clean"]="🧹 Clean package cache"
    ["autoremove"]="🗑️  Remove orphaned packages"
    ["install_flatpak"]="📥 Install Flatpak package"
    ["remove_flatpak"]="🗑️  Remove Flatpak package"
    ["search_flatpak"]="🔍 Search Flatpak packages"
    ["update_flatpak"]="🔄 Update Flatpak packages"
    ["list_flatpak"]="📋 List Flatpak packages"
    ["add_flatpak_repo"]="➕ Add Flatpak repository"
    ["install_snap"]="📥 Install Snap package"
    ["remove_snap"]="🗑️  Remove Snap package"
    ["search_snap"]="🔍 Search Snap packages"
    ["update_snap"]="🔄 Update Snap packages"
    ["list_snap"]="📋 List Snap packages"
    ["enable_snap"]="🔧 Enable Snap service"
    ["backup_packages"]="💾 Backup package list"
    ["restore_packages"]="📦 Restore packages from backup"
    ["system_info"]="💻 Show system information"
    ["disk_usage"]="💽 Show disk usage"
    ["change_lang"]="🌐 Change language"
    ["about"]="ℹ️  About GT-CLPM"
    ["back"]="⬅️  Back to main menu"
    ["detected"]="Detected package manager:"
    ["not_found"]="Package manager not found"
    ["no_package"]="No package name provided"
    ["installing"]="Installing"
    ["removing"]="Removing"
    ["searching"]="Searching for"
    ["updating"]="Updating system packages..."
    ["upgrading"]="Upgrading system packages..."
    ["fixing"]="Fixing broken packages..."
    ["listing"]="Listing installed packages..."
    ["cleaning"]="Cleaning package cache..."
    ["autoremoving"]="Removing orphaned packages..."
    ["error"]="❌ Error:"
    ["success"]="✅ Success:"
    ["warning"]="⚠️  Warning:"
    ["info_msg"]="ℹ️  Info:"
    ["invalid_option"]="Invalid option"
    ["lang_changed"]="Language changed to English"
    ["flatpak_not_installed"]="Flatpak is not installed. Installing..."
    ["snap_not_installed"]="Snap is not installed. Installing..."
    ["enter_package"]="Enter package name:"
    ["enter_choice"]="Enter your choice:"
    ["operation_completed"]="Operation completed"
    ["press_enter"]="Press Enter to continue..."
    ["enter_repo"]="Enter repository URL:"
    ["backup_created"]="Package list backup created"
    ["restore_completed"]="Package restoration completed"
    ["exiting"]="Exiting GT-CLPM... Goodbye!"
)

declare -A MESSAGES_AR=(
    ["title"]="GT-CLPM - مدير حزم سطر الأوامر من جنوتكس"
    ["version"]="الإصدار 1.0 - رخصة GPLv2 - من تطوير GNUTUX"
    ["main_menu"]="🏠 القائمة الرئيسية"
    ["package_manager"]="📦 عمليات مدير الحزم"
    ["flatpak_manager"]="📱 مدير فلاتباك"
    ["snap_manager"]="🔧 مدير سناب"
    ["system_tools"]="⚙️  أدوات النظام"
    ["settings"]="🛠️  الإعدادات"
    ["exit"]="🚪 خروج"
    ["install"]="📥 تثبيت حزمة"
    ["remove"]="🗑️  إزالة حزمة"
    ["search"]="🔍 البحث عن حزمة"
    ["update"]="🔄 تحديث حزم النظام"
    ["upgrade"]="⬆️  ترقية حزم النظام"
    ["list"]="📋 عرض الحزم المثبتة"
    ["info"]="ℹ️  معلومات الحزمة"
    ["fix"]="🔧 إصلاح الحزم المعطلة"
    ["clean"]="🧹 تنظيف ذاكرة التخزين المؤقت"
    ["autoremove"]="🗑️  إزالة الحزم اليتيمة"
    ["install_flatpak"]="📥 تثبيت حزمة فلاتباك"
    ["remove_flatpak"]="🗑️  إزالة حزمة فلاتباك"
    ["search_flatpak"]="🔍 البحث في حزم فلاتباك"
    ["update_flatpak"]="🔄 تحديث حزم فلاتباك"
    ["list_flatpak"]="📋 عرض حزم فلاتباك"
    ["add_flatpak_repo"]="➕ إضافة مستودع فلاتباك"
    ["install_snap"]="📥 تثبيت حزمة سناب"
    ["remove_snap"]="🗑️  إزالة حزمة سناب"
    ["search_snap"]="🔍 البحث في حزم سناب"
    ["update_snap"]="🔄 تحديث حزم سناب"
    ["list_snap"]="📋 عرض حزم سناب"
    ["enable_snap"]="🔧 تفعيل خدمة سناب"
    ["backup_packages"]="💾 نسخ احتياطي لقائمة الحزم"
    ["restore_packages"]="📦 استعادة الحزم من النسخ الاحتياطي"
    ["system_info"]="💻 عرض معلومات النظام"
    ["disk_usage"]="💽 عرض استخدام القرص"
    ["change_lang"]="🌐 تغيير اللغة"
    ["about"]="ℹ️  حول GT-CLPM"
    ["back"]="⬅️  العودة للقائمة الرئيسية"
    ["detected"]="مدير الحزم المكتشف:"
    ["not_found"]="مدير الحزم غير موجود"
    ["no_package"]="لم يتم توفير اسم الحزمة"
    ["installing"]="جاري التثبيت"
    ["removing"]="جاري الإزالة"
    ["searching"]="البحث عن"
    ["updating"]="جاري تحديث حزم النظام..."
    ["upgrading"]="جاري ترقية حزم النظام..."
    ["fixing"]="جاري إصلاح الحزم المعطلة..."
    ["listing"]="جاري عرض الحزم المثبتة..."
    ["cleaning"]="جاري تنظيف ذاكرة التخزين المؤقت..."
    ["autoremoving"]="جاري إزالة الحزم اليتيمة..."
    ["error"]="❌ خطأ:"
    ["success"]="✅ نجح:"
    ["warning"]="⚠️  تحذير:"
    ["info_msg"]="ℹ️  معلومة:"
    ["invalid_option"]="خيار غير صحيح"
    ["lang_changed"]="تم تغيير اللغة إلى العربية"
    ["flatpak_not_installed"]="فلاتباك غير مثبت. جاري التثبيت..."
    ["snap_not_installed"]="سناب غير مثبت. جاري التثبيت..."
    ["enter_package"]="أدخل اسم الحزمة:"
    ["enter_choice"]="أدخل اختيارك:"
    ["operation_completed"]="تمت العملية بنجاح"
    ["press_enter"]="اضغط Enter للمتابعة..."
    ["enter_repo"]="أدخل رابط المستودع:"
    ["backup_created"]="تم إنشاء نسخة احتياطية لقائمة الحزم"
    ["restore_completed"]="تم استعادة الحزم بنجاح"
    ["exiting"]="جاري الخروج من GT-CLPM... وداعاً!"
)

# Function to get message in current language
get_msg() {
    local key="$1"
    if [[ "$CURRENT_LANG" == "ar" ]]; then
        echo "${MESSAGES_AR[$key]}"
    else
        echo "${MESSAGES_EN[$key]}"
    fi
}

# Function to detect package manager
detect_package_manager() {
    if command -v apt &> /dev/null; then
        echo "apt"
    elif command -v dnf &> /dev/null; then
        echo "dnf"
    elif command -v yum &> /dev/null; then
        echo "yum"
    elif command -v pacman &> /dev/null; then
        echo "pacman"
    elif command -v zypper &> /dev/null; then
        echo "zypper"
    elif command -v eopkg &> /dev/null; then
        echo "eopkg"
    elif command -v xbps-install &> /dev/null; then
        echo "xbps"
    elif command -v emerge &> /dev/null; then
        echo "emerge"
    elif command -v pkg &> /dev/null; then
        echo "pkg"
    elif command -v apk &> /dev/null; then
        echo "apk"
    elif command -v nix-env &> /dev/null; then
        echo "nix"
    else
        echo "unknown"
    fi
}

# Function to show header
show_header() {
    local subtitle="$1"
    clear
    echo -e "${CYAN}"
    echo "                           (     (       *     "
    echo " (        *   )       (    )\ )  )\ )  (  \`    "
    echo " )\ )   \` )  /(       )\  (()/( (()/(  )\))(   "
    echo "(()/(    ( )(_))___ (((_)  /(_)) /(_))((_)()\  "
    echo " /(_))_ (_(_())|___|)\___ (_))  (_))  (_()((_) "
    echo "(_)) __||_   _|    ((/ __|| |   | _ \ |  \/  | "
    echo "  | (_ |  | |       | (__ | |__ |  _/ | |\/| | "
    echo "   \___|  |_|        \___||____||_|   |_|  |_| "
    echo "                                               "
    echo -e "${NC}"
    echo -e "${BOLD}${WHITE}$(get_msg "title")${NC}"
    echo -e "${YELLOW}$(get_msg "version")${NC}"
    echo -e "${BLUE}$(get_msg "detected") $(detect_package_manager)${NC}"
    echo
    if [[ -n "$subtitle" ]]; then
        echo -e "${GREEN}${BOLD}$subtitle${NC}"
    fi
    echo "============================================================"
    echo
}

# Function to pause and wait for user input
pause() {
    echo
    echo -e "${CYAN}$(get_msg "press_enter")${NC}"
    read -r
}

# Function to check if flatpak is installed
check_flatpak() {
    if ! command -v flatpak &> /dev/null; then
        echo -e "${YELLOW}$(get_msg "flatpak_not_installed")${NC}"
        install_flatpak_system
    fi
}

# Function to check if snap is installed
check_snap() {
    if ! command -v snap &> /dev/null; then
        echo -e "${YELLOW}$(get_msg "snap_not_installed")${NC}"
        install_snap_system
    fi
}

# Function to install flatpak on system
install_flatpak_system() {
    local pm=$(detect_package_manager)
    case $pm in
        "apt")
            sudo apt update && sudo apt install -y flatpak
            ;;
        "dnf"|"yum")
            sudo $pm install -y flatpak
            ;;
        "pacman")
            sudo pacman -S --noconfirm flatpak
            ;;
        "zypper")
            sudo zypper install -y flatpak
            ;;
        "eopkg")
            sudo eopkg install flatpak
            ;;
        *)
            echo -e "${RED}$(get_msg "error") Flatpak installation not supported for this package manager${NC}"
            return 1
            ;;
    esac

    # Add flathub repository
    flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
}

# Function to install snap on system
install_snap_system() {
    local pm=$(detect_package_manager)
    case $pm in
        "apt")
            sudo apt update && sudo apt install -y snapd
            ;;
        "dnf"|"yum")
            sudo $pm install -y snapd
            sudo systemctl enable --now snapd.socket
            ;;
        "pacman")
            echo -e "${YELLOW}Installing snapd from AUR...${NC}"
            if command -v yay &> /dev/null; then
                yay -S --noconfirm snapd
            elif command -v paru &> /dev/null; then
                paru -S --noconfirm snapd
            else
                echo -e "${RED}$(get_msg "error") AUR helper (yay/paru) needed for snap installation${NC}"
                return 1
            fi
            sudo systemctl enable --now snapd.socket
            ;;
        "zypper")
            sudo zypper install -y snapd
            sudo systemctl enable --now snapd.socket
            ;;
        *)
            echo -e "${RED}$(get_msg "error") Snap installation not supported for this package manager${NC}"
            return 1
            ;;
    esac
}

# Package management functions
install_package() {
    local package="$1"
    local pm=$(detect_package_manager)

    if [[ -z "$package" ]]; then
        echo -e "${RED}$(get_msg "error") $(get_msg "no_package")${NC}"
        return 1
    fi

    echo -e "${GREEN}$(get_msg "installing") $package...${NC}"

    case $pm in
        "apt")
            sudo apt update && sudo apt install -y "$package"
            ;;
        "dnf")
            sudo dnf install -y "$package"
            ;;
        "yum")
            sudo yum install -y "$package"
            ;;
        "pacman")
            sudo pacman -S --noconfirm "$package"
            ;;
        "zypper")
            sudo zypper install -y "$package"
            ;;
        "eopkg")
            sudo eopkg install "$package"
            ;;
        "xbps")
            sudo xbps-install -S "$package"
            ;;
        "emerge")
            sudo emerge "$package"
            ;;
        "pkg")
            sudo pkg install "$package"
            ;;
        "apk")
            sudo apk add "$package"
            ;;
        "nix")
            nix-env -i "$package"
            ;;
        *)
            echo -e "${RED}$(get_msg "error") $(get_msg "not_found")${NC}"
            return 1
            ;;
    esac
}

remove_package() {
    local package="$1"
    local pm=$(detect_package_manager)

    if [[ -z "$package" ]]; then
        echo -e "${RED}$(get_msg "error") $(get_msg "no_package")${NC}"
        return 1
    fi

    echo -e "${YELLOW}$(get_msg "removing") $package...${NC}"

    case $pm in
        "apt")
            sudo apt remove -y "$package"
            ;;
        "dnf")
            sudo dnf remove -y "$package"
            ;;
        "yum")
            sudo yum remove -y "$package"
            ;;
        "pacman")
            sudo pacman -R --noconfirm "$package"
            ;;
        "zypper")
            sudo zypper remove -y "$package"
            ;;
        "eopkg")
            sudo eopkg remove "$package"
            ;;
        "xbps")
            sudo xbps-remove "$package"
            ;;
        "emerge")
            sudo emerge --unmerge "$package"
            ;;
        "pkg")
            sudo pkg delete "$package"
            ;;
        "apk")
            sudo apk del "$package"
            ;;
        "nix")
            nix-env -e "$package"
            ;;
        *)
            echo -e "${RED}$(get_msg "error") $(get_msg "not_found")${NC}"
            return 1
            ;;
    esac
}

search_package() {
    local package="$1"
    local pm=$(detect_package_manager)

    if [[ -z "$package" ]]; then
        echo -e "${RED}$(get_msg "error") $(get_msg "no_package")${NC}"
        return 1
    fi

    echo -e "${CYAN}$(get_msg "searching") $package...${NC}"

    case $pm in
        "apt")
            apt search "$package"
            ;;
        "dnf")
            dnf search "$package"
            ;;
        "yum")
            yum search "$package"
            ;;
        "pacman")
            pacman -Ss "$package"
            ;;
        "zypper")
            zypper search "$package"
            ;;
        "eopkg")
            eopkg search "$package"
            ;;
        "xbps")
            xbps-query -Rs "$package"
            ;;
        "emerge")
            emerge --search "$package"
            ;;
        "pkg")
            pkg search "$package"
            ;;
        "apk")
            apk search "$package"
            ;;
        "nix")
            nix-env -qa | grep "$package"
            ;;
        *)
            echo -e "${RED}$(get_msg "error") $(get_msg "not_found")${NC}"
            return 1
            ;;
    esac
}

update_packages() {
    local pm=$(detect_package_manager)

    echo -e "${BLUE}$(get_msg "updating")${NC}"

    case $pm in
        "apt")
            sudo apt update && sudo apt upgrade -y
            ;;
        "dnf")
            sudo dnf update -y
            ;;
        "yum")
            sudo yum update -y
            ;;
        "pacman")
            sudo pacman -Syu --noconfirm
            ;;
        "zypper")
            sudo zypper update -y
            ;;
        "eopkg")
            sudo eopkg upgrade
            ;;
        "xbps")
            sudo xbps-install -Su
            ;;
        "emerge")
            sudo emerge --sync && sudo emerge -uDN @world
            ;;
        "pkg")
            sudo pkg update && sudo pkg upgrade
            ;;
        "apk")
            sudo apk update && sudo apk upgrade
            ;;
        "nix")
            nix-channel --update && nix-env -u
            ;;
        *)
            echo -e "${RED}$(get_msg "error") $(get_msg "not_found")${NC}"
            return 1
            ;;
    esac
}

fix_packages() {
    local pm=$(detect_package_manager)

    echo -e "${PURPLE}$(get_msg "fixing")${NC}"

    case $pm in
        "apt")
            sudo apt update && sudo apt --fix-broken install -y && sudo dpkg --configure -a
            ;;
        "dnf")
            sudo dnf check && sudo dnf autoremove -y
            ;;
        "yum")
            sudo yum check && sudo yum autoremove -y
            ;;
        "pacman")
            sudo pacman -Dk && sudo pacman -Sc --noconfirm
            ;;
        "zypper")
            sudo zypper verify && sudo zypper clean -a
            ;;
        "eopkg")
            sudo eopkg check
            ;;
        "xbps")
            sudo xbps-pkgdb -a && sudo xbps-remove -Oo
            ;;
        "emerge")
            sudo emerge --depclean && sudo revdep-rebuild
            ;;
        "pkg")
            sudo pkg check -d && sudo pkg autoremove
            ;;
        "apk")
            sudo apk fix && sudo apk cache clean
            ;;
        "nix")
            nix-collect-garbage -d
            ;;
        *)
            echo -e "${RED}$(get_msg "error") $(get_msg "not_found")${NC}"
            return 1
            ;;
    esac
}

list_packages() {
    local pm=$(detect_package_manager)

    echo -e "${WHITE}$(get_msg "listing")${NC}"

    case $pm in
        "apt")
            dpkg -l | grep ^ii
            ;;
        "dnf"|"yum")
            $pm list installed
            ;;
        "pacman")
            pacman -Q
            ;;
        "zypper")
            zypper search -i
            ;;
        "eopkg")
            eopkg list-installed
            ;;
        "xbps")
            xbps-query -l
            ;;
        "emerge")
            qlist -I
            ;;
        "pkg")
            pkg info
            ;;
        "apk")
            apk info
            ;;
        "nix")
            nix-env -q
            ;;
        *)
            echo -e "${RED}$(get_msg "error") $(get_msg "not_found")${NC}"
            return 1
            ;;
    esac
}

package_info() {
    local package="$1"
    local pm=$(detect_package_manager)

    if [[ -z "$package" ]]; then
        echo -e "${RED}$(get_msg "error") $(get_msg "no_package")${NC}"
        return 1
    fi

    case $pm in
        "apt")
            apt show "$package"
            ;;
        "dnf"|"yum")
            $pm info "$package"
            ;;
        "pacman")
            pacman -Si "$package"
            ;;
        "zypper")
            zypper info "$package"
            ;;
        "eopkg")
            eopkg info "$package"
            ;;
        "xbps")
            xbps-query -R "$package"
            ;;
        "emerge")
            emerge --info "$package"
            ;;
        "pkg")
            pkg info "$package"
            ;;
        "apk")
            apk info "$package"
            ;;
        "nix")
            nix-env -qa --description | grep "$package"
            ;;
        *)
            echo -e "${RED}$(get_msg "error") $(get_msg "not_found")${NC}"
            return 1
            ;;
    esac
}

clean_cache() {
    local pm=$(detect_package_manager)

    echo -e "${CYAN}$(get_msg "cleaning")${NC}"

    case $pm in
        "apt")
            sudo apt autoclean && sudo apt autoremove -y
            ;;
        "dnf")
            sudo dnf clean all && sudo dnf autoremove -y
            ;;
        "yum")
            sudo yum clean all && sudo yum autoremove -y
            ;;
        "pacman")
            sudo pacman -Sc --noconfirm && sudo pacman -Rns $(pacman -Qtdq) --noconfirm 2>/dev/null || true
            ;;
        "zypper")
            sudo zypper clean -a
            ;;
        "eopkg")
            sudo eopkg delete-cache
            ;;
        "xbps")
            sudo xbps-remove -Oo
            ;;
        "emerge")
            sudo emerge --depclean && sudo eclean distfiles
            ;;
        "pkg")
            sudo pkg clean && sudo pkg autoremove
            ;;
        "apk")
            sudo apk cache clean
            ;;
        "nix")
            nix-collect-garbage -d
            ;;
        *)
            echo -e "${RED}$(get_msg "error") $(get_msg "not_found")${NC}"
            return 1
            ;;
    esac
}

# System tools functions
show_system_info() {
    echo -e "${CYAN}💻 System Information:${NC}"
    echo "===================="
    echo -e "${YELLOW}OS:${NC} $(lsb_release -d 2>/dev/null | cut -f2 || cat /etc/os-release | grep PRETTY_NAME | cut -d'"' -f2)"
    echo -e "${YELLOW}Kernel:${NC} $(uname -r)"
    echo -e "${YELLOW}Architecture:${NC} $(uname -m)"
    echo -e "${YELLOW}Package Manager:${NC} $(detect_package_manager)"
    echo -e "${YELLOW}Uptime:${NC} $(uptime -p 2>/dev/null || uptime)"
    echo -e "${YELLOW}Memory:${NC} $(free -h | grep Mem | awk '{print $3"/"$2}')"
    echo -e "${YELLOW}CPU:${NC} $(grep "model name" /proc/cpuinfo | head -1 | cut -d':' -f2 | sed 's/^ *//')"
}

show_disk_usage() {
    echo -e "${CYAN}💽 Disk Usage:${NC}"
    echo "=============="
    df -h | grep -v tmpfs | grep -v udev
}

backup_packages() {
    local pm=$(detect_package_manager)
    local backup_file="$HOME/gt-clpm-backup-$(date +%Y%m%d_%H%M%S).txt"

    echo -e "${BLUE}Creating package backup...${NC}"

    case $pm in
        "apt")
            dpkg --get-selections > "$backup_file"
            ;;
        "dnf"|"yum")
            $pm list installed > "$backup_file"
            ;;
        "pacman")
            pacman -Q > "$backup_file"
            ;;
        "zypper")
            zypper search -i > "$backup_file"
            ;;
        "eopkg")
            eopkg list-installed > "$backup_file"
            ;;
        *)
            echo -e "${YELLOW}$(get_msg "warning") Backup not implemented for this package manager${NC}"
            return 1
            ;;
    esac

    echo -e "${GREEN}$(get_msg "backup_created"): $backup_file${NC}"
}

restore_packages() {
    echo -e "${YELLOW}$(get_msg "warning") This feature requires manual implementation for safety${NC}"
    echo "Backup files are stored in: $HOME/gt-clpm-backup-*.txt"
}

# Change language function
change_language() {
    if [[ "$CURRENT_LANG" == "en" ]]; then
        CURRENT_LANG="ar"
        echo "ar" > "$LANG_FILE"
    else
        CURRENT_LANG="en"
        echo "en" > "$LANG_FILE"
    fi
    echo -e "${GREEN}$(get_msg "lang_changed")${NC}"
}

# About function
show_about() {
    echo -e "${CYAN}ℹ️  About GT-CLPM${NC}"
    echo "================"
    echo -e "${WHITE}GT-CLPM - GNUTUX Command Line Package Manager${NC}"
    echo -e "${YELLOW}Version:${NC} 1.0"
    echo -e "${YELLOW}License:${NC} GPLv2"
    echo -e "${YELLOW}Developer:${NC} GNUTUX"
    echo -e "${YELLOW}Description:${NC} Universal package manager for GNU/Linux systems"
    echo
    echo -e "${GREEN}Supported Package Managers:${NC}"
    echo "• APT (Debian, Ubuntu)"
    echo "• DNF/YUM (Fedora, RHEL)"
    echo "• Pacman (Arch, Manjaro)"
    echo "• Zypper (openSUSE)"
    echo "• Eopkg (Solus)"
    echo "• XBPS (Void Linux)"
    echo "• Emerge (Gentoo)"
    echo "• PKG (FreeBSD)"
    echo "• APK (Alpine)"
    echo "• Nix (NixOS)"
    echo "• Flatpak"
    echo "• Snap"
}

# Menu functions
package_manager_menu() {
    while true; do
        show_header "$(get_msg "package_manager")"

        echo "1. $(get_msg "install")"
        echo "2. $(get_msg "remove")"
        echo "3. $(get_msg "search")"
        echo "4. $(get_msg "update")"
        echo "5. $(get_msg "upgrade")"
        echo "6. $(get_msg "list")"
        echo "7. $(get_msg "info")"
        echo "8. $(get_msg "fix")"
        echo "9. $(get_msg "clean")"
        echo "10. $(get_msg "autoremove")"
        echo "0. $(get_msg "back")"
        echo

        read -p "$(get_msg "enter_choice") " choice

        case $choice in
            1)
                echo
                read -p "$(get_msg "enter_package") " package
                install_package "$package"
                pause
                ;;
            2)
                echo
                read -p "$(get_msg "enter_package") " package
                remove_package "$package"
                pause
                ;;
            3)
                echo
                read -p "$(get_msg "enter_package") " package
                search_package "$package"
                pause
                ;;
            4|5)
                echo
                update_packages
                pause
                ;;
            6)
                echo
                list_packages
                pause
                ;;
            7)
                echo
                read -p "$(get_msg "enter_package") " package
                package_info "$package"
                pause
                ;;
            8)
                echo
                fix_packages
                pause
                ;;
            9|10)
                echo
                clean_cache
                pause
                ;;
            0)
                break
                ;;
            *)
                echo -e "${RED}$(get_msg "invalid_option")${NC}"
                pause
                ;;
        esac
    done
}

flatpak_menu() {
    check_flatpak

    while true; do
        show_header "$(get_msg "flatpak_manager")"

        echo "1. $(get_msg "install_flatpak")"
        echo "2. $(get_msg "remove_flatpak")"
        echo "3. $(get_msg "search_flatpak")"
        echo "4. $(get_msg "update_flatpak")"
        echo "5. $(get_msg "list_flatpak")"
        echo "6. $(get_msg "add_flatpak_repo")"
        echo "0. $(get_msg "back")"
        echo

        read -p "$(get_msg "enter_choice") " choice

        case $choice in
            1)
                echo
                read -p "$(get_msg "enter_package") " package
                if [[ -n "$package" ]]; then
                    flatpak install -y flathub "$package"
                fi
                pause
                ;;
            2)
                echo
                read -p "$(get_msg "enter_package") " package
                if [[ -n "$package" ]]; then
                    flatpak uninstall -y "$package"
                fi
                pause
                ;;
            3)
                echo
                read -p "$(get_msg "enter_package") " package
                if [[ -n "$package" ]]; then
                    flatpak search "$package"
                fi
                pause
                ;;
            4)
                echo
                flatpak update -y
                pause
                ;;
            5)
                echo
                flatpak list
                pause
                ;;
            6)
                echo
                read -p "$(get_msg "enter_repo") " repo
                if [[ -n "$repo" ]]; then
                    flatpak remote-add --if-not-exists custom "$repo"
                fi
                pause
                ;;
            0)
                break
                ;;
            *)
                echo -e "${RED}$(get_msg "invalid_option")${NC}"
                pause
                ;;
        esac
    done
}

snap_menu() {
    check_snap

    while true; do
        show_header "$(get_msg "snap_manager")"

        echo "1. $(get_msg "install_snap")"
        echo "2. $(get_msg "remove_snap")"
        echo "3. $(get_msg "search_snap")"
        echo "4. $(get_msg "update_snap")"
        echo "5. $(get_msg "list_snap")"
        echo "6. $(get_msg "enable_snap")"
        echo "0. $(get_msg "back")"
        echo

        read -p "$(get_msg "enter_choice") " choice

        case $choice in
            1)
                echo
                read -p "$(get_msg "enter_package") " package
                if [[ -n "$package" ]]; then
                    sudo snap install "$package"
                fi
                pause
                ;;
            2)
                echo
                read -p "$(get_msg "enter_package") " package
                if [[ -n "$package" ]]; then
                    sudo snap remove "$package"
                fi
                pause
                ;;
            3)
                echo
                read -p "$(get_msg "enter_package") " package
                if [[ -n "$package" ]]; then
                    snap find "$package"
                fi
                pause
                ;;
            4)
                echo
                sudo snap refresh
                pause
                ;;
            5)
                echo
                snap list
                pause
                ;;
            6)
                echo
                sudo systemctl enable --now snapd.socket
                echo -e "${GREEN}$(get_msg "success") Snap service enabled${NC}"
                pause
                ;;
            0)
                break
                ;;
            *)
                echo -e "${RED}$(get_msg "invalid_option")${NC}"
                pause
                ;;
        esac
    done
}

system_tools_menu() {
    while true; do
        show_header "$(get_msg "system_tools")"

        echo "1. $(get_msg "backup_packages")"
        echo "2. $(get_msg "restore_packages")"
        echo "3. $(get_msg "system_info")"
        echo "4. $(get_msg "disk_usage")"
        echo "0. $(get_msg "back")"
        echo

        read -p "$(get_msg "enter_choice") " choice

        case $choice in
            1)
                echo
                backup_packages
                pause
                ;;
            2)
                echo
                restore_packages
                pause
                ;;
            3)
                echo
                show_system_info
                pause
                ;;
            4)
                echo
                show_disk_usage
                pause
                ;;
            0)
                break
                ;;
            *)
                echo -e "${RED}$(get_msg "invalid_option")${NC}"
                pause
                ;;
        esac
    done
}

settings_menu() {
    while true; do
        show_header "$(get_msg "settings")"

        echo "1. $(get_msg "change_lang")"
        echo "2. $(get_msg "about")"
        echo "0. $(get_msg "back")"
        echo

        read -p "$(get_msg "enter_choice") " choice

        case $choice in
            1)
                echo
                change_language
                pause
                ;;
            2)
                echo
                show_about
                pause
                ;;
            0)
                break
                ;;
            *)
                echo -e "${RED}$(get_msg "invalid_option")${NC}"
                pause
                ;;
        esac
    done
}

main_menu() {
    while true; do
        show_header "$(get_msg "main_menu")"

        echo "1. $(get_msg "package_manager")"
        echo "2. $(get_msg "flatpak_manager")"
        echo "3. $(get_msg "snap_manager")"
        echo "4. $(get_msg "system_tools")"
        echo "5. $(get_msg "settings")"
        echo "0. $(get_msg "exit")"
        echo

        read -p "$(get_msg "enter_choice") " choice

        case $choice in
            1)
                package_manager_menu
                ;;
            2)
                flatpak_menu
                ;;
            3)
                snap_menu
                ;;
            4)
                system_tools_menu
                ;;
            5)
                settings_menu
                ;;
            0)
                clear
                echo -e "${GREEN}$(get_msg "exiting")${NC}"
                exit 0
                ;;
            *)
                echo -e "${RED}$(get_msg "invalid_option")${NC}"
                pause
                ;;
        esac
    done
}

# Main execution
main() {
    # Check if terminal supports UTF-8
    if [[ "$LANG" != *"UTF-8"* ]]; then
        export LANG="en_US.UTF-8"
    fi

    # Start main menu
    main_menu
}

# Run the program
main "$@"
