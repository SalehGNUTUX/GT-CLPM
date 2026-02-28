#!/bin/bash

# GT-CLPM - GNUTUX Command Line Package Manager
# Version: 1.2
# License: GPLv2
# Developer: GNUTUX
# Description: Universal package manager for GNU/Linux systems

# ─── Color codes ──────────────────────────────────────────────────────────────
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
BOLD='\033[1m'
NC='\033[0m'

# ─── Language settings ────────────────────────────────────────────────────────
LANG_FILE="$HOME/.gt-clpm-lang"

if [[ -f "$LANG_FILE" ]]; then
    CURRENT_LANG=$(cat "$LANG_FILE")
else
    if [[ $LANG == *"ar"* ]] || [[ $LANGUAGE == *"ar"* ]] || \
       [[ $LC_ALL == *"ar"* ]] || [[ $LC_CTYPE == *"ar"* ]]; then
        CURRENT_LANG="ar"
    else
        CURRENT_LANG="en"
    fi
    echo "$CURRENT_LANG" > "$LANG_FILE"
fi

# ─── Messages ─────────────────────────────────────────────────────────────────
declare -A MESSAGES_EN=(
    ["title"]="GT-CLPM - GNUTUX Command Line Package Manager"
    ["version"]="Version 1.2.2 - GPLv2 License - Developed by GNUTUX"
    ["main_menu"]="🏠 Main Menu"
    ["package_manager"]="📦 Package Manager Operations"
    ["flatpak_manager"]="📱 Flatpak Manager"
    ["snap_manager"]="🔧 Snap Manager"
    ["other_installers"]="🛠️ Other Installation Methods"
    ["system_tools"]="⚙️ System Tools"
    ["settings"]="🛠️ Settings"
    ["exit"]="🚪 Exit"
    ["install"]="📥 Install package"
    ["remove"]="🗑️ Remove package"
    ["smart_remove"]="🧠 Smart Remove"
    ["search"]="🔍 Search for package"
    ["update"]="🔄 Update system packages"
    ["upgrade"]="⬆️ Upgrade system packages"
    ["list"]="📋 List installed packages"
    ["info"]="ℹ️ Package information"
    ["fix"]="🔧 Fix broken packages"
    ["clean"]="🧹 Clean package cache"
    ["autoremove"]="🗑️ Remove orphaned packages"
    ["install_flatpak"]="📥 Install Flatpak package"
    ["remove_flatpak"]="🗑️ Remove Flatpak package"
    ["smart_remove_flatpak"]="🧠 Smart Remove Flatpak"
    ["search_flatpak"]="🔍 Search Flatpak packages"
    ["update_flatpak"]="🔄 Update Flatpak packages"
    ["list_flatpak"]="📋 List Flatpak packages"
    ["add_flatpak_repo"]="➕ Add Flatpak repository"
    ["install_snap"]="📥 Install Snap package"
    ["remove_snap"]="🗑️ Remove Snap package"
    ["smart_remove_snap"]="🧠 Smart Remove Snap"
    ["search_snap"]="🔍 Search Snap packages"
    ["update_snap"]="🔄 Update Snap packages"
    ["list_snap"]="📋 List Snap packages"
    ["enable_snap"]="🔧 Enable Snap service"
    ["python_tools"]="🐍 Python (pip/pipx)"
    ["nodejs_tools"]="📦 Node.js (npm/yarn/pnpm)"
    ["ruby_tools"]="💎 Ruby (gem/bundler)"
    ["rust_tools"]="🦀 Rust (cargo)"
    ["go_tools"]="🐹 Go (go install)"
    ["haskell_tools"]="🧊 Haskell (cabal/stack)"
    ["java_tools"]="☕ Java (maven/gradle)"
    ["php_tools"]="🐘 PHP (composer)"
    ["scientific_tools"]="🔬 Scientific Tools (Spack)"
    ["backup_packages"]="💾 Backup package list"
    ["restore_packages"]="📦 Restore packages from backup"
    ["system_info"]="💻 Show system information"
    ["disk_usage"]="💽 Show disk usage"
    ["change_lang"]="🌐 Change language"
    ["about"]="ℹ️ About GT-CLPM"
    ["back"]="⬅️ Back to main menu"
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
    ["warning"]="⚠️ Warning:"
    ["info_msg"]="ℹ️ Info:"
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
    ["browse_packages"]="📂 Browse installed packages"
    ["manual_entry"]="⌨️ Manual entry"
    ["select_package"]="Select package to remove:"
    ["confirm_remove"]="Are you sure you want to remove"
    ["removal_cancelled"]="Removal cancelled"
    ["package_removed"]="Package removed successfully"
    ["install_from_search"]="🔢 Install from search results"
    ["search_results"]="Search Results"
    ["enter_number"]="Enter package number to install"
    ["install_package_num"]="Install package number"
    ["return_to_menu"]="Return to menu"
    ["search_first"]="Search first"
    ["refresh_flathub"]="🔄 Refresh Flathub Repository"
    ["installed"]="[installed]"
    ["search_programs"]="🔍 Search for programs"
    ["search_packages"]="📦 Search for packages"
    ["applications"]="💻 Applications"
    ["libraries"]="📚 Libraries and dependencies"
    ["add_repo"]="➕ Add repository/PPA"
    ["not_installed_auto"]="Not installed. Install automatically? (y/N)"
    ["dependency_ok"]="Dependencies OK"
    ["no_results"]="No results found"
    ["try_wider"]="Showing wider search results..."
    ["page"]="Page"
    ["next_page"]="Next page"
    ["prev_page"]="Previous page"
)

declare -A MESSAGES_AR=(
    ["title"]="GT-CLPM - مدير حزم سطر الأوامر من جنوتكس"
    ["version"]="الإصدار 1.2 - رخصة GPLv2 - من تطوير GNUTUX"
    ["main_menu"]="🏠 القائمة الرئيسية"
    ["package_manager"]="📦 عمليات مدير الحزم"
    ["flatpak_manager"]="📱 مدير فلاتباك"
    ["snap_manager"]="🔧 مدير سناب"
    ["other_installers"]="🛠️ طرق تثبيت أخرى"
    ["system_tools"]="⚙️ أدوات النظام"
    ["settings"]="🛠️ الإعدادات"
    ["exit"]="🚪 خروج"
    ["install"]="📥 تثبيت حزمة"
    ["remove"]="🗑️ إزالة حزمة"
    ["smart_remove"]="🧠 إزالة ذكية"
    ["search"]="🔍 البحث عن حزمة"
    ["update"]="🔄 تحديث حزم النظام"
    ["upgrade"]="⬆️ ترقية حزم النظام"
    ["list"]="📋 عرض الحزم المثبتة"
    ["info"]="ℹ️ معلومات الحزمة"
    ["fix"]="🔧 إصلاح الحزم المعطلة"
    ["clean"]="🧹 تنظيف ذاكرة التخزين المؤقت"
    ["autoremove"]="🗑️ إزالة الحزم اليتيمة"
    ["install_flatpak"]="📥 تثبيت حزمة فلاتباك"
    ["remove_flatpak"]="🗑️ إزالة حزمة فلاتباك"
    ["smart_remove_flatpak"]="🧠 إزالة ذكية لفلاتباك"
    ["search_flatpak"]="🔍 البحث في حزم فلاتباك"
    ["update_flatpak"]="🔄 تحديث حزم فلاتباك"
    ["list_flatpak"]="📋 عرض حزم فلاتباك"
    ["add_flatpak_repo"]="➕ إضافة مستودع فلاتباك"
    ["install_snap"]="📥 تثبيت حزمة سناب"
    ["remove_snap"]="🗑️ إزالة حزمة سناب"
    ["smart_remove_snap"]="🧠 إزالة ذكية لسناب"
    ["search_snap"]="🔍 البحث في حزم سناب"
    ["update_snap"]="🔄 تحديث حزم سناب"
    ["list_snap"]="📋 عرض حزم سناب"
    ["enable_snap"]="🔧 تفعيل خدمة سناب"
    ["python_tools"]="🐍 بايثون (pip/pipx)"
    ["nodejs_tools"]="📦 نود.js (npm/yarn/pnpm)"
    ["ruby_tools"]="💎 روبي (gem/bundler)"
    ["rust_tools"]="🦀 رست (cargo)"
    ["go_tools"]="🐹 جو (go install)"
    ["haskell_tools"]="🧊 هاسكل (cabal/stack)"
    ["java_tools"]="☕ جافا (maven/gradle)"
    ["php_tools"]="🐘 PHP (composer)"
    ["scientific_tools"]="🔬 أدوات علمية (Spack)"
    ["backup_packages"]="💾 نسخ احتياطي لقائمة الحزم"
    ["restore_packages"]="📦 استعادة الحزم من النسخ الاحتياطي"
    ["system_info"]="💻 عرض معلومات النظام"
    ["disk_usage"]="💽 عرض استخدام القرص"
    ["change_lang"]="🌐 تغيير اللغة"
    ["about"]="ℹ️ حول GT-CLPM"
    ["back"]="⬅️ العودة للقائمة الرئيسية"
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
    ["warning"]="⚠️ تحذير:"
    ["info_msg"]="ℹ️ معلومة:"
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
    ["browse_packages"]="📂 تصفح الحزم المثبتة"
    ["manual_entry"]="⌨️ إدخال يدوي"
    ["select_package"]="اختر الحزمة المراد إزالتها:"
    ["confirm_remove"]="هل أنت متأكد أنك تريد إزالة"
    ["removal_cancelled"]="تم إلغاء الإزالة"
    ["package_removed"]="تم إزالة الحزمة بنجاح"
    ["install_from_search"]="🔢 التثبيت من نتائج البحث"
    ["search_results"]="نتائج البحث"
    ["enter_number"]="أدخل رقم الحزمة للتثبيت"
    ["install_package_num"]="تثبيت الحزمة رقم"
    ["return_to_menu"]="العودة للقائمة"
    ["search_first"]="البحث أولاً"
    ["refresh_flathub"]="🔄 إنعاش مستودع فلاتهاب"
    ["installed"]="[مثبت]"
    ["search_programs"]="🔍 البحث عن البرامج"
    ["search_packages"]="📦 البحث عن الحزم"
    ["applications"]="💻 التطبيقات"
    ["libraries"]="📚 المكتبات والإعتماديات"
    ["add_repo"]="➕ إضافة مستودع/PPA"
    ["not_installed_auto"]="غير مثبت. هل تريد تثبيته تلقائياً؟ (y/N)"
    ["dependency_ok"]="الاعتماديات متوفرة"
    ["no_results"]="لا توجد نتائج"
    ["try_wider"]="عرض نتائج بحث أوسع..."
    ["page"]="صفحة"
    ["next_page"]="الصفحة التالية"
    ["prev_page"]="الصفحة السابقة"
)

get_msg() {
    local key="$1"
    if [[ "$CURRENT_LANG" == "ar" ]]; then
        echo "${MESSAGES_AR[$key]}"
    else
        echo "${MESSAGES_EN[$key]}"
    fi
}

# ─── Package Manager Detection ───────────────────────────────────────────────
detect_package_manager() {
    # Check for most specific first to avoid conflicts
    if command -v apt-get &>/dev/null && [[ -f /etc/debian_version ]]; then
        echo "apt"
    elif command -v dnf &>/dev/null; then
        echo "dnf"
    elif command -v yum &>/dev/null; then
        echo "yum"
    elif command -v pacman &>/dev/null; then
        echo "pacman"
    elif command -v zypper &>/dev/null; then
        echo "zypper"
    elif command -v eopkg &>/dev/null; then
        echo "eopkg"
    elif command -v xbps-install &>/dev/null; then
        echo "xbps"
    elif command -v emerge &>/dev/null; then
        echo "emerge"
    elif command -v apk &>/dev/null && [[ -f /etc/alpine-release ]]; then
        echo "apk"
    elif command -v nix-env &>/dev/null; then
        echo "nix"
    elif command -v brew &>/dev/null; then
        echo "brew"
    elif command -v pkg &>/dev/null; then
        echo "pkg"
    else
        echo "unknown"
    fi
}

# ─── Header ───────────────────────────────────────────────────────────────────
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

pause() {
    echo
    echo -e "${CYAN}$(get_msg "press_enter")${NC}"
    read -r
}

# ─── Flathub / Flatpak helpers ───────────────────────────────────────────────
add_flathub_repository() {
    if ! flatpak remote-list 2>/dev/null | grep -q "flathub"; then
        echo -e "${YELLOW}Adding Flathub repository...${NC}"
        flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
        echo -e "${GREEN}Flathub repository added successfully${NC}"
    fi
}

check_flatpak() {
    if ! command -v flatpak &>/dev/null; then
        echo -e "${YELLOW}$(get_msg "flatpak_not_installed")${NC}"
        install_flatpak_system
    fi
    add_flathub_repository
}

check_snap() {
    if ! command -v snap &>/dev/null; then
        echo -e "${YELLOW}$(get_msg "snap_not_installed")${NC}"
        install_snap_system
    fi
}

install_flatpak_system() {
    local pm=$(detect_package_manager)
    case $pm in
        apt)    sudo apt update && sudo apt install -y flatpak ;;
        dnf|yum) sudo $pm install -y flatpak ;;
        pacman) sudo pacman -S --noconfirm flatpak ;;
        zypper) sudo zypper install -y flatpak ;;
        eopkg)  sudo eopkg install flatpak ;;
        apk)    sudo apk add flatpak ;;
        brew)   brew install --cask flatpak ;;
        *)
            echo -e "${RED}$(get_msg "error") Flatpak installation not supported for this package manager${NC}"
            return 1 ;;
    esac
}

install_snap_system() {
    local pm=$(detect_package_manager)
    case $pm in
        apt)
            sudo apt update && sudo apt install -y snapd
            sudo systemctl enable --now snapd.socket 2>/dev/null || true
            ;;
        dnf|yum)
            sudo $pm install -y snapd
            sudo systemctl enable --now snapd.socket
            ;;
        pacman)
            echo -e "${YELLOW}Installing snapd from AUR...${NC}"
            if command -v yay &>/dev/null; then
                yay -S --noconfirm snapd
            elif command -v paru &>/dev/null; then
                paru -S --noconfirm snapd
            else
                echo -e "${RED}$(get_msg "error") AUR helper (yay/paru) needed. Install one first.${NC}"
                return 1
            fi
            sudo systemctl enable --now snapd.socket
            ;;
        zypper)
            sudo zypper addrepo --refresh https://download.opensuse.org/repositories/system:/snappy/$(. /etc/os-release; echo $VERSION_ID)/system:snappy.repo
            sudo zypper --gpg-auto-import-keys refresh
            sudo zypper install -y snapd
            sudo systemctl enable --now snapd.socket
            ;;
        *)
            echo -e "${RED}$(get_msg "error") Snap installation not supported for this package manager${NC}"
            return 1 ;;
    esac
}

# ─── Repository / PPA Management ─────────────────────────────────────────────
add_repository() {
    local pm=$(detect_package_manager)
    echo -e "${CYAN}$(get_msg "add_repo")${NC}"

    case $pm in
        apt)
            echo "1. Add PPA (Ubuntu/Mint)"
            echo "2. Add custom repository (sources.list.d)"
            echo "3. Add GPG key + repository"
            echo "0. Back"
            read -p "$(get_msg "enter_choice") " choice
            case $choice in
                1)
                    read -p "Enter PPA (e.g. ppa:user/repo): " ppa
                    if [[ -n "$ppa" ]]; then
                        sudo add-apt-repository -y "$ppa" && sudo apt update
                    fi ;;
                2)
                    read -p "Enter repository line (deb ...): " repo_line
                    read -p "Enter file name (e.g. myrepo): " repo_name
                    if [[ -n "$repo_line" && -n "$repo_name" ]]; then
                        echo "$repo_line" | sudo tee /etc/apt/sources.list.d/${repo_name}.list
                        sudo apt update
                    fi ;;
                3)
                    read -p "Enter GPG key URL: " key_url
                    read -p "Enter repository line (deb ...): " repo_line
                    read -p "Enter file name (e.g. myrepo): " repo_name
                    if [[ -n "$key_url" && -n "$repo_line" && -n "$repo_name" ]]; then
                        curl -fsSL "$key_url" | sudo gpg --dearmor -o /etc/apt/keyrings/${repo_name}.gpg
                        echo "$repo_line" | sudo tee /etc/apt/sources.list.d/${repo_name}.list
                        sudo apt update
                    fi ;;
            esac ;;
        dnf)
            echo "1. Add COPR repository"
            echo "2. Add RPM repository URL"
            echo "3. Install RPM fusion"
            echo "0. Back"
            read -p "$(get_msg "enter_choice") " choice
            case $choice in
                1)
                    read -p "Enter COPR (e.g. user/repo): " copr
                    [[ -n "$copr" ]] && sudo dnf copr enable -y "$copr" && sudo dnf update ;;
                2)
                    read -p "Enter repo URL (.repo file): " repo_url
                    [[ -n "$repo_url" ]] && sudo dnf config-manager --add-repo "$repo_url" ;;
                3)
                    sudo dnf install -y https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
                        https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
                    echo -e "${GREEN}RPM Fusion installed${NC}" ;;
            esac ;;
        pacman)
            echo "1. Enable multilib"
            echo "2. Add custom repository to pacman.conf"
            echo "3. Install AUR helper (yay)"
            echo "0. Back"
            read -p "$(get_msg "enter_choice") " choice
            case $choice in
                1)
                    sudo sed -i '/^#\[multilib\]/,/^#Include/ s/^#//' /etc/pacman.conf
                    sudo pacman -Sy
                    echo -e "${GREEN}multilib enabled${NC}" ;;
                2)
                    read -p "Enter repo name: " rname
                    read -p "Enter repo URL: " rurl
                    if [[ -n "$rname" && -n "$rurl" ]]; then
                        echo -e "\n[$rname]\nServer = $rurl" | sudo tee -a /etc/pacman.conf
                        sudo pacman -Sy
                    fi ;;
                3)
                    if ! command -v yay &>/dev/null; then
                        sudo pacman -S --noconfirm git base-devel
                        cd /tmp && git clone https://aur.archlinux.org/yay.git
                        cd yay && makepkg -si --noconfirm
                        cd / && rm -rf /tmp/yay
                        echo -e "${GREEN}yay installed${NC}"
                    else
                        echo -e "${YELLOW}yay is already installed${NC}"
                    fi ;;
            esac ;;
        zypper)
            echo "1. Add repository by URL"
            echo "2. Add Packman repository"
            echo "0. Back"
            read -p "$(get_msg "enter_choice") " choice
            case $choice in
                1)
                    read -p "Enter repo URL: " rurl
                    read -p "Enter repo alias: " ralias
                    [[ -n "$rurl" ]] && sudo zypper addrepo -f "$rurl" "${ralias:-custom}" ;;
                2)
                    VER=$(. /etc/os-release; echo "$VERSION_ID")
                    sudo zypper addrepo -cfp 90 "https://ftp.gwdg.de/pub/linux/misc/packman/suse/openSUSE_Leap_${VER}/" packman
                    sudo zypper --gpg-auto-import-keys refresh ;;
            esac ;;
        *)
            echo -e "${YELLOW}Repository management not implemented for $(detect_package_manager)${NC}" ;;
    esac
}

# ─── Core Package Operations ──────────────────────────────────────────────────
install_package() {
    local package="$1"
    local pm=$(detect_package_manager)

    if [[ -z "$package" ]]; then
        echo -e "${CYAN}$(get_msg "install") - $(get_msg "search_first")${NC}"
        echo "1. $(get_msg "manual_entry")"
        echo "2. $(get_msg "search_programs")"
        echo "3. $(get_msg "search_packages")"
        echo "0. $(get_msg "back")"
        echo
        read -p "$(get_msg "enter_choice") " choice
        case $choice in
            1)
                read -p "$(get_msg "enter_package") " package
                [[ -z "$package" ]] && return ;;
            2)
                read -p "$(get_msg "enter_package") " search_term
                [[ -n "$search_term" ]] && search_programs "$search_term"
                return ;;
            3)
                read -p "$(get_msg "enter_package") " search_term
                [[ -n "$search_term" ]] && search_package "$search_term"
                return ;;
            0) return ;;
            *) echo -e "${RED}$(get_msg "invalid_option")${NC}"; return 1 ;;
        esac
    fi

    [[ -z "$package" ]] && { echo -e "${RED}$(get_msg "error") $(get_msg "no_package")${NC}"; return 1; }

    echo -e "${GREEN}$(get_msg "installing") $package...${NC}"
    case $pm in
        apt)    sudo apt update && sudo apt install -y "$package" ;;
        dnf)    sudo dnf install -y "$package" ;;
        yum)    sudo yum install -y "$package" ;;
        pacman)
            if sudo pacman -S --noconfirm "$package" 2>/dev/null; then
                true
            elif command -v yay &>/dev/null; then
                yay -S --noconfirm "$package"
            elif command -v paru &>/dev/null; then
                paru -S --noconfirm "$package"
            else
                echo -e "${YELLOW}Package not found in official repos. Install AUR helper for AUR packages.${NC}"
            fi ;;
        zypper) sudo zypper install -y "$package" ;;
        eopkg)  sudo eopkg install "$package" ;;
        xbps)   sudo xbps-install -S "$package" ;;
        emerge) sudo emerge "$package" ;;
        apk)    sudo apk add "$package" ;;
        nix)    nix-env -i "$package" ;;
        brew)   brew install "$package" ;;
        pkg)    sudo pkg install -y "$package" ;;
        *)      echo -e "${RED}$(get_msg "error") $(get_msg "not_found")${NC}"; return 1 ;;
    esac
}

remove_package() {
    local package="$1"
    local pm=$(detect_package_manager)
    [[ -z "$package" ]] && { echo -e "${RED}$(get_msg "error") $(get_msg "no_package")${NC}"; return 1; }

    echo -e "${YELLOW}$(get_msg "removing") $package...${NC}"
    case $pm in
        apt)    sudo apt remove -y "$package" ;;
        dnf)    sudo dnf remove -y "$package" ;;
        yum)    sudo yum remove -y "$package" ;;
        pacman) sudo pacman -R --noconfirm "$package" ;;
        zypper) sudo zypper remove -y "$package" ;;
        eopkg)  sudo eopkg remove "$package" ;;
        xbps)   sudo xbps-remove "$package" ;;
        emerge) sudo emerge --unmerge "$package" ;;
        apk)    sudo apk del "$package" ;;
        nix)    nix-env -e "$package" ;;
        brew)   brew uninstall "$package" ;;
        pkg)    sudo pkg delete -y "$package" ;;
        *)      echo -e "${RED}$(get_msg "error") $(get_msg "not_found")${NC}"; return 1 ;;
    esac
}

update_packages() {
    local pm=$(detect_package_manager)
    echo -e "${BLUE}$(get_msg "updating")${NC}"
    case $pm in
        apt)    sudo apt update && sudo apt upgrade -y ;;
        dnf)    sudo dnf update -y ;;
        yum)    sudo yum update -y ;;
        pacman) sudo pacman -Syu --noconfirm ;;
        zypper) sudo zypper update -y ;;
        eopkg)  sudo eopkg upgrade ;;
        xbps)   sudo xbps-install -Su ;;
        emerge) sudo emerge --sync && sudo emerge -uDN @world ;;
        apk)    sudo apk update && sudo apk upgrade ;;
        nix)    nix-channel --update && nix-env -u ;;
        brew)   brew update && brew upgrade ;;
        pkg)    sudo pkg update && sudo pkg upgrade -y ;;
        *)      echo -e "${RED}$(get_msg "error") $(get_msg "not_found")${NC}"; return 1 ;;
    esac
}

fix_packages() {
    local pm=$(detect_package_manager)
    echo -e "${PURPLE}$(get_msg "fixing")${NC}"
    case $pm in
        apt)    sudo apt update && sudo apt --fix-broken install -y && sudo dpkg --configure -a ;;
        dnf)    sudo dnf check && sudo dnf autoremove -y ;;
        yum)    sudo yum check && sudo yum autoremove -y ;;
        pacman) sudo pacman -Dk && sudo pacman -Sc --noconfirm ;;
        zypper) sudo zypper verify && sudo zypper clean -a ;;
        eopkg)  sudo eopkg check ;;
        xbps)   sudo xbps-pkgdb -a && sudo xbps-remove -Oo ;;
        emerge) sudo emerge --depclean && sudo revdep-rebuild ;;
        apk)    sudo apk fix && sudo apk cache clean ;;
        nix)    nix-collect-garbage -d ;;
        brew)   brew doctor ;;
        pkg)    sudo pkg check -d && sudo pkg autoremove ;;
        *)      echo -e "${RED}$(get_msg "error") $(get_msg "not_found")${NC}"; return 1 ;;
    esac
}

list_packages() {
    local pm=$(detect_package_manager)
    echo -e "${WHITE}$(get_msg "listing")${NC}"
    case $pm in
        apt)    dpkg -l | grep ^ii ;;
        dnf|yum) $pm list installed ;;
        pacman) pacman -Q ;;
        zypper) zypper search -i ;;
        eopkg)  eopkg list-installed ;;
        xbps)   xbps-query -l ;;
        emerge) qlist -I ;;
        apk)    apk info ;;
        nix)    nix-env -q ;;
        brew)   brew list ;;
        pkg)    pkg info ;;
        *)      echo -e "${RED}$(get_msg "error") $(get_msg "not_found")${NC}"; return 1 ;;
    esac
}

package_info() {
    local package="$1"
    local pm=$(detect_package_manager)
    [[ -z "$package" ]] && { echo -e "${RED}$(get_msg "error") $(get_msg "no_package")${NC}"; return 1; }
    case $pm in
        apt)    apt show "$package" ;;
        dnf|yum) $pm info "$package" ;;
        pacman) pacman -Si "$package" ;;
        zypper) zypper info "$package" ;;
        eopkg)  eopkg info "$package" ;;
        xbps)   xbps-query -R "$package" ;;
        emerge) emerge --info "$package" ;;
        apk)    apk info -a "$package" ;;
        nix)    nix-env -qa --description | grep "$package" ;;
        brew)   brew info "$package" ;;
        pkg)    pkg info "$package" ;;
        *)      echo -e "${RED}$(get_msg "error") $(get_msg "not_found")${NC}"; return 1 ;;
    esac
}

clean_cache() {
    local pm=$(detect_package_manager)
    echo -e "${CYAN}$(get_msg "cleaning")${NC}"
    case $pm in
        apt)    sudo apt autoclean && sudo apt autoremove -y ;;
        dnf)    sudo dnf clean all && sudo dnf autoremove -y ;;
        yum)    sudo yum clean all && sudo yum autoremove -y ;;
        pacman)
            sudo pacman -Sc --noconfirm
            orphans=$(pacman -Qtdq 2>/dev/null)
            [[ -n "$orphans" ]] && sudo pacman -Rns $orphans --noconfirm || true
            ;;
        zypper) sudo zypper clean -a ;;
        eopkg)  sudo eopkg delete-cache ;;
        xbps)   sudo xbps-remove -Oo ;;
        emerge) sudo emerge --depclean && sudo eclean distfiles ;;
        apk)    sudo apk cache clean ;;
        nix)    nix-collect-garbage -d ;;
        brew)   brew cleanup ;;
        pkg)    sudo pkg clean && sudo pkg autoremove ;;
        *)      echo -e "${RED}$(get_msg "error") $(get_msg "not_found")${NC}"; return 1 ;;
    esac
}

# ─── SEARCH: Interactive with numbered selection ──────────────────────────────
# Helper: display results and prompt for install choice
# Global variable to hold the selected package (avoids subshell stdout pollution)
SELECTED_PKG=""

# Display numbered results WITH PAGINATION and prompt user to select one.
# Sets SELECTED_PKG on success, returns 0; returns 1 on cancel.
# Usage: _display_and_select pkg_names_array disp_lines_array [page_size]
_display_and_select() {
    local pkgs_ref="$1"
    local lines_ref="$2"
    local page_size="${3:-10}"
    SELECTED_PKG=""

    local -n _pkgs="$pkgs_ref"
    local -n _lines="$lines_ref"
    local total=${#_pkgs[@]}

    if [[ $total -eq 0 ]]; then
        echo -e "${YELLOW}$(get_msg "no_results")${NC}"
        return 1
    fi

    local page=0
    local total_pages=$(( (total + page_size - 1) / page_size ))

    while true; do
        local start=$(( page * page_size ))
        local end=$(( start + page_size ))
        [[ $end -gt $total ]] && end=$total

        echo -e "${GREEN}$(get_msg "search_results") ($total) — $(get_msg "page") $((page+1))/$total_pages:${NC}"
        echo "════════════════════════════════════════"
        for ((idx=start; idx<end; idx++)); do
            echo -e "$((idx+1)). ${_lines[$idx]}"
            echo
        done

        echo -e "${YELLOW}──────────────────────────────────────────${NC}"
        [[ $((page+1)) -lt $total_pages ]] && \
            echo -e "  ${CYAN}n${NC} → $(get_msg "next_page") (results $((end+1))-$(( total < end+page_size ? total : end+page_size )))"
        [[ $page -gt 0 ]] && \
            echo -e "  ${CYAN}p${NC} → $(get_msg "prev_page")"
        echo -e "  ${CYAN}0${NC} → $(get_msg "return_to_menu")"
        echo

        local pkg_choice
        read -p "$(get_msg "enter_number") (1-$total, n/p/0): " pkg_choice

        case "$pkg_choice" in
            n|N)
                if [[ $((page+1)) -lt $total_pages ]]; then ((page++))
                else echo -e "${YELLOW}Already on last page${NC}"; fi ;;
            p|P)
                if [[ $page -gt 0 ]]; then ((page--))
                else echo -e "${YELLOW}Already on first page${NC}"; fi ;;
            0) return 1 ;;
            *)
                if [[ "$pkg_choice" =~ ^[0-9]+$ ]] && \
                   [[ "$pkg_choice" -ge 1 ]]        && \
                   [[ "$pkg_choice" -le "$total" ]]; then
                    SELECTED_PKG="${_pkgs[$((pkg_choice-1))]}"
                    return 0
                else
                    echo -e "${RED}$(get_msg "invalid_option")${NC}"
                fi ;;
        esac
    done
}

# Search for user-facing applications (APT/DNF/Pacman/Zypper/etc)
search_programs() {
    local query="$1"
    local pm=$(detect_package_manager)
    [[ -z "$query" ]] && { echo -e "${RED}$(get_msg "error") $(get_msg "no_package")${NC}"; return 1; }

    echo -e "${CYAN}$(get_msg "searching") \"$query\" ($(get_msg "applications"))...${NC}"

    local -a pkg_names=()
    local -a disp_lines=()

    _is_app_pkg() {
        local n="$1" d="$2"
        [[ $n =~ -dev$|-dbg$|-doc$|-data$|-common$|-l10n$ ]] && return 1
        [[ $n =~ ^lib[0-9]|^python3?-[0-9]|^gir1\.2-|^fonts-|^golang-|^erlang- ]] && return 1
        [[ $n =~ -plugin$|-extension$|\.so ]] && return 1
        [[ $d =~ [Dd]evelopment[[:space:]][Ff]iles|[Ss]hared[[:space:]][Ll]ibrar ]] && return 1
        return 0
    }

    case $pm in
        apt)
            while IFS= read -r line; do
                # apt-cache search format: "name - description"
                if [[ $line =~ ^([^[:space:]]+)[[:space:]]+-[[:space:]]+(.*)$ ]]; then
                    local n="${BASH_REMATCH[1]}" d="${BASH_REMATCH[2]}"
                    _is_app_pkg "$n" "$d" || continue
                    [[ " ${pkg_names[*]} " == *" $n "* ]] && continue
                    local mark=""
                    dpkg-query -W "$n" &>/dev/null && mark=" $(get_msg "installed")"
                    local ver
                    ver=$(apt-cache policy "$n" 2>/dev/null | awk '/Candidate:/{print $2}')
                    [[ "$ver" == "(none)" ]] && ver=""
                    disp_lines+=("${CYAN}$n${NC}${ver:+ ($ver)}${mark}\n  ${d}")
                    pkg_names+=("$n")
                    [[ ${#pkg_names[@]} -ge 50 ]] && break
                fi
            done < <(apt-cache search "$query" 2>/dev/null | sort)
            ;;
        dnf|yum)
            while IFS= read -r line; do
                # dnf search format: "name.arch : description"
                if [[ $line =~ ^([^.]+)\.[^[:space:]]+[[:space:]]+:[[:space:]]+(.*)$ ]]; then
                    local n="${BASH_REMATCH[1]}" d="${BASH_REMATCH[2]}"
                    _is_app_pkg "$n" "$d" || continue
                    [[ " ${pkg_names[*]} " == *" $n "* ]] && continue
                    local mark=""
                    $pm list installed "$n" &>/dev/null && mark=" $(get_msg "installed")"
                    disp_lines+=("${CYAN}$n${NC}${mark}\n  ${d}")
                    pkg_names+=("$n")
                    [[ ${#pkg_names[@]} -ge 50 ]] && break
                fi
            done < <($pm search "$query" 2>/dev/null | grep -v "^=\|^$\|^Last metadata\|^N/A\|^===")
            ;;
        pacman)
            local current_pkg="" current_desc=""
            while IFS= read -r line; do
                if [[ $line =~ ^([^/]+)/([^[:space:]]+)[[:space:]] ]]; then
                    [[ -n "$current_pkg" ]] && {
                        _is_app_pkg "$current_pkg" "$current_desc" && {
                            local mark=""
                            pacman -Q "$current_pkg" &>/dev/null && mark=" $(get_msg "installed")"
                            disp_lines+=("${CYAN}$current_pkg${NC}${mark}\n  ${current_desc}")
                            pkg_names+=("$current_pkg")
                        }
                    }
                    current_pkg="${BASH_REMATCH[2]}"
                    current_desc=""
                elif [[ $line =~ ^[[:space:]]+(.*) ]]; then
                    current_desc="${BASH_REMATCH[1]}"
                fi
                [[ ${#pkg_names[@]} -ge 50 ]] && break
            done < <(pacman -Ss "$query" 2>/dev/null)
            [[ -n "$current_pkg" && ${#pkg_names[@]} -lt 20 ]] && {
                _is_app_pkg "$current_pkg" "$current_desc" && {
                    local mark=""
                    pacman -Q "$current_pkg" &>/dev/null && mark=" $(get_msg "installed")"
                    disp_lines+=("${CYAN}$current_pkg${NC}${mark}\n  ${current_desc}")
                    pkg_names+=("$current_pkg")
                }
            }
            ;;
        zypper)
            while IFS= read -r line; do
                if [[ $line =~ ^\|[[:space:]]+([^|]+)[[:space:]]+\|[[:space:]]+([^|]+)[[:space:]]+\|[[:space:]]+([^|]+)[[:space:]]+\| ]]; then
                    local n="${BASH_REMATCH[1]// /}" d="${BASH_REMATCH[2]// /}"
                    [[ "$n" == "Name" ]] && continue
                    _is_app_pkg "$n" "$d" || continue
                    [[ " ${pkg_names[*]} " == *" $n "* ]] && continue
                    local mark=""
                    zypper search -i --match-exact "$n" &>/dev/null && mark=" $(get_msg "installed")"
                    disp_lines+=("${CYAN}$n${NC}${mark}\n  ${d}")
                    pkg_names+=("$n")
                    [[ ${#pkg_names[@]} -ge 50 ]] && break
                fi
            done < <(zypper search "$query" 2>/dev/null)
            ;;
        eopkg)
            while IFS= read -r line; do
                if [[ $line =~ ^([^[:space:]]+)[[:space:]]+-[[:space:]]+(.*)$ ]]; then
                    local n="${BASH_REMATCH[1]}" d="${BASH_REMATCH[2]}"
                    _is_app_pkg "$n" "$d" || continue
                    [[ " ${pkg_names[*]} " == *" $n "* ]] && continue
                    local mark=""
                    eopkg info "$n" 2>/dev/null | grep -q "Installed" && mark=" $(get_msg "installed")"
                    disp_lines+=("${CYAN}$n${NC}${mark}\n  ${d}")
                    pkg_names+=("$n")
                    [[ ${#pkg_names[@]} -ge 50 ]] && break
                fi
            done < <(eopkg search "$query" 2>/dev/null)
            ;;
        xbps)
            while IFS= read -r line; do
                if [[ $line =~ ^([^[:space:]]+)[[:space:]]+(.*)$ ]]; then
                    local n="${BASH_REMATCH[1]}" d="${BASH_REMATCH[2]}"
                    _is_app_pkg "$n" "$d" || continue
                    [[ " ${pkg_names[*]} " == *" $n "* ]] && continue
                    local mark=""
                    xbps-query "$n" &>/dev/null && mark=" $(get_msg "installed")"
                    disp_lines+=("${CYAN}$n${NC}${mark}\n  ${d}")
                    pkg_names+=("$n")
                    [[ ${#pkg_names[@]} -ge 50 ]] && break
                fi
            done < <(xbps-query -Rs "$query" 2>/dev/null)
            ;;
        apk)
            while IFS= read -r line; do
                if [[ $line =~ ^([^[:space:]]+)[[:space:]]+(.*)$ ]]; then
                    local n="${BASH_REMATCH[1]}" d="${BASH_REMATCH[2]}"
                    _is_app_pkg "$n" "$d" || continue
                    [[ " ${pkg_names[*]} " == *" $n "* ]] && continue
                    local mark=""
                    apk info "$n" &>/dev/null && mark=" $(get_msg "installed")"
                    disp_lines+=("${CYAN}$n${NC}${mark}\n  ${d}")
                    pkg_names+=("$n")
                    [[ ${#pkg_names[@]} -ge 50 ]] && break
                fi
            done < <(apk search "$query" 2>/dev/null | sort)
            ;;
        nix)
            while IFS= read -r line; do
                if [[ $line =~ ^nixpkgs\.([^[:space:]]+)[[:space:]]*(.*)$ ]]; then
                    local n="${BASH_REMATCH[1]}" d="${BASH_REMATCH[2]}"
                    [[ " ${pkg_names[*]} " == *" $n "* ]] && continue
                    local mark=""
                    nix-env -q "$n" &>/dev/null && mark=" $(get_msg "installed")"
                    disp_lines+=("${CYAN}$n${NC}${mark}\n  ${d}")
                    pkg_names+=("$n")
                    [[ ${#pkg_names[@]} -ge 50 ]] && break
                fi
            done < <(nix-env -qa --description "*${query}*" 2>/dev/null)
            ;;
        brew)
            while IFS= read -r n; do
                [[ -z "$n" ]] && continue
                local mark=""
                brew list "$n" &>/dev/null && mark=" $(get_msg "installed")"
                local d
                d=$(brew desc "$n" 2>/dev/null | awk -F': ' '{print $2}')
                disp_lines+=("${CYAN}$n${NC}${mark}\n  ${d:-No description}")
                pkg_names+=("$n")
                [[ ${#pkg_names[@]} -ge 50 ]] && break
            done < <(brew search "$query" 2>/dev/null | grep -v "^==>")
            ;;
        pkg)
            while IFS= read -r line; do
                if [[ $line =~ ^([^[:space:]]+)-[0-9][^[:space:]]*[[:space:]]+(.*)$ ]]; then
                    local n="${BASH_REMATCH[1]}" d="${BASH_REMATCH[2]}"
                    [[ " ${pkg_names[*]} " == *" $n "* ]] && continue
                    local mark=""
                    pkg info "$n" &>/dev/null && mark=" $(get_msg "installed")"
                    disp_lines+=("${CYAN}$n${NC}${mark}\n  ${d}")
                    pkg_names+=("$n")
                    [[ ${#pkg_names[@]} -ge 50 ]] && break
                fi
            done < <(pkg search "$query" 2>/dev/null)
            ;;
        *)
            echo -e "${YELLOW}Search not implemented for this package manager${NC}"
            return 1 ;;
    esac

    if [[ ${#pkg_names[@]} -eq 0 ]]; then
        echo -e "${YELLOW}$(get_msg "no_results") for: $query${NC}"
        return 1
    fi

    _display_and_select pkg_names disp_lines
    if [[ $? -eq 0 && -n "$SELECTED_PKG" ]]; then
        echo -e "${YELLOW}$(get_msg "install_package_num"): ${GREEN}${SELECTED_PKG}${NC} (y/N)? "
        read -r confirm
        [[ $confirm =~ ^[Yy]$ ]] && install_package "$SELECTED_PKG" || \
            echo -e "${YELLOW}Installation cancelled${NC}"
    fi
}

# Search ALL packages (including libraries)
search_package() {
    local query="$1"
    local pm=$(detect_package_manager)
    [[ -z "$query" ]] && { echo -e "${RED}$(get_msg "error") $(get_msg "no_package")${NC}"; return 1; }

    echo -e "${CYAN}$(get_msg "searching") \"$query\" ($(get_msg "libraries"))...${NC}"

    local -a pkg_names=()
    local -a disp_lines=()

    case $pm in
        apt)
            while IFS= read -r line; do
                if [[ $line =~ ^([^/]+)/([^[:space:]]+)[[:space:]]+([^[:space:]]+)[[:space:]]+([^[:space:]]+) ]]; then
                    local n="${BASH_REMATCH[1]}" repo="${BASH_REMATCH[2]}" ver="${BASH_REMATCH[3]}"
                    [[ " ${pkg_names[*]} " == *" $n "* ]] && continue
                    local mark=""
                    dpkg-query -W "$n" &>/dev/null && mark=" $(get_msg "installed")"
                    disp_lines+=("${CYAN}$n${NC} [${repo}] ${ver}${mark}")
                    pkg_names+=("$n")
                    [[ ${#pkg_names[@]} -ge 50 ]] && break
                fi
            done < <(apt-cache search "$query" 2>/dev/null | awk -v q="$query" '{if ($1 ~ q) print}' | head -40)
            ;;
        dnf|yum)
            while IFS= read -r line; do
                if [[ $line =~ ^([^.]+)\.[^[:space:]]+[[:space:]]+([^[:space:]]+)[[:space:]]+([^[:space:]]+) ]]; then
                    local n="${BASH_REMATCH[1]}" ver="${BASH_REMATCH[2]}" repo="${BASH_REMATCH[3]}"
                    [[ " ${pkg_names[*]} " == *" $n "* ]] && continue
                    local mark=""
                    $pm list installed "$n" &>/dev/null && mark=" $(get_msg "installed")"
                    disp_lines+=("${CYAN}$n${NC} [${repo}] ${ver}${mark}")
                    pkg_names+=("$n")
                    [[ ${#pkg_names[@]} -ge 50 ]] && break
                fi
            done < <($pm list "$query*" 2>/dev/null | grep -v "^Available\|^Installed\|^$")
            ;;
        pacman)
            while IFS= read -r line; do
                if [[ $line =~ ^([^/]+)/([^[:space:]]+)[[:space:]]+([^[:space:]]+) ]]; then
                    local n="${BASH_REMATCH[2]}" repo="${BASH_REMATCH[1]}" ver="${BASH_REMATCH[3]}"
                    [[ " ${pkg_names[*]} " == *" $n "* ]] && continue
                    local mark=""
                    pacman -Q "$n" &>/dev/null && mark=" $(get_msg "installed")"
                    disp_lines+=("${CYAN}$n${NC} [${repo}] ${ver}${mark}")
                    pkg_names+=("$n")
                    [[ ${#pkg_names[@]} -ge 50 ]] && break
                fi
            done < <(pacman -Ss "$query" 2>/dev/null | grep "^[a-z]")
            ;;
        *)
            search_programs "$query"
            return ;;
    esac

    if [[ ${#pkg_names[@]} -eq 0 ]]; then
        echo -e "${YELLOW}$(get_msg "no_results") for: $query${NC}"
        return 1
    fi

    local selected
    _display_and_select pkg_names disp_lines
    if [[ $? -eq 0 && -n "$SELECTED_PKG" ]]; then
        echo -e "${YELLOW}$(get_msg "install_package_num"): ${GREEN}${SELECTED_PKG}${NC} (y/N)? "
        read -r confirm
        [[ $confirm =~ ^[Yy]$ ]] && install_package "$SELECTED_PKG" || \
            echo -e "${YELLOW}Installation cancelled${NC}"
    fi
}

# ─── FLATPAK Search & Install ─────────────────────────────────────────────────
# Fixed: use column-based parsing with --columns flag (available in modern flatpak)
search_flatpak() {
    local query="$1"
    [[ -z "$query" ]] && { echo -e "${RED}$(get_msg "error") $(get_msg "no_package")${NC}"; return 1; }

    echo -e "${CYAN}$(get_msg "searching") \"$query\" (Flatpak)...${NC}"

    local -a app_ids=()
    local -a disp_lines=()

    # Helper: validate an Application ID (must contain dots, no spaces, no ANSI codes)
    _valid_flatpak_id() {
        local id="$1"
        # Strip any accidental ANSI/whitespace
        id=$(echo "$id" | sed 's/\x1b\[[0-9;]*m//g; s/[[:space:]]//g')
        # Must match reverse-DNS pattern: at least two dot-separated segments, no spaces
        [[ "$id" =~ ^[A-Za-z][A-Za-z0-9_-]*(\.[A-Za-z][A-Za-z0-9_-]*){1,}$ ]] || return 1
        echo "$id"   # return cleaned value
    }

    # Primary method: flatpak search --columns (flatpak >= 1.2)
    while IFS=$'\t' read -r name desc app_id version branch remotes; do
        # Trim whitespace from all fields
        name=$(echo "$name" | sed 's/^[[:space:]]*//; s/[[:space:]]*$//')
        app_id=$(echo "$app_id" | sed 's/^[[:space:]]*//; s/[[:space:]]*$//')
        desc=$(echo "$desc" | sed 's/^[[:space:]]*//; s/[[:space:]]*$//')
        branch=$(echo "$branch" | sed 's/^[[:space:]]*//; s/[[:space:]]*$//')
        remotes=$(echo "$remotes" | sed 's/^[[:space:]]*//; s/[[:space:]]*$//')

        # Skip header line
        [[ "$app_id" == "Application" || "$app_id" == "Application ID" || "$name" == "Name" ]] && continue
        [[ -z "$app_id" ]] && continue

        # Validate the Application ID
        local clean_id
        clean_id=$(_valid_flatpak_id "$app_id") || continue

        # Skip only explicit runtimes/SDKs/base-apps (NOT .desktop or other valid suffixes)
        [[ $clean_id =~ \.Sdk$|\.Sdk\.[0-9]|\.Platform$|\.Platform\.[0-9]|^org\.freedesktop\.Platform|^org\.gnome\.Platform|^org\.kde\.Platform|BaseApp|\.Locale$|\.Debug$|Sources$ ]] && continue

        local mark=""
        flatpak list --app --columns=application 2>/dev/null | \
            grep -qx "$clean_id" && mark=" $(get_msg "installed")"

        local remote_disp="${remotes:-flathub}"
        disp_lines+=("${CYAN}${name}${NC}${mark} [${remote_disp}/${branch:-stable}]\n  ${desc}\n  ${BLUE}ID: ${clean_id}${NC}")
        app_ids+=("$clean_id")
        [[ ${#app_ids[@]} -ge 50 ]] && break
    done < <(flatpak search --columns=name,description,application,version,branch,remotes \
             "$query" 2>/dev/null | tail -n +2)

    # Fallback: classic tab-separated output (older flatpak versions)
    if [[ ${#app_ids[@]} -eq 0 ]]; then
        while IFS=$'\t' read -r name desc app_id version branch remotes; do
            name=$(echo "$name" | sed 's/^[[:space:]]*//; s/[[:space:]]*$//')
            app_id=$(echo "$app_id" | sed 's/^[[:space:]]*//; s/[[:space:]]*$//')
            desc=$(echo "$desc" | sed 's/^[[:space:]]*//; s/[[:space:]]*$//')

            [[ "$app_id" == "Application ID" || "$name" == "Name" ]] && continue
            [[ -z "$app_id" ]] && continue

            local clean_id
            clean_id=$(_valid_flatpak_id "$app_id") || continue
            [[ $clean_id =~ \.Sdk$|\.Sdk\.[0-9]|\.Platform$|\.Platform\.[0-9]|^org\.freedesktop\.Platform|^org\.gnome\.Platform|BaseApp|\.Locale$|\.Debug$|Sources$ ]] && continue

            local mark=""
            flatpak list --app 2>/dev/null | grep -q "^$clean_id" && \
                mark=" $(get_msg "installed")"

            disp_lines+=("${CYAN}${name}${NC}${mark} [${remotes:-flathub}/${branch:-stable}]\n  ${desc}\n  ${BLUE}ID: ${clean_id}${NC}")
            app_ids+=("$clean_id")
            [[ ${#app_ids[@]} -ge 50 ]] && break
        done < <(flatpak search "$query" 2>/dev/null | grep -v "^No matches\|^$\|^Name")
    fi

    if [[ ${#app_ids[@]} -eq 0 ]]; then
        echo -e "${YELLOW}No Flatpak packages found for: $query${NC}"
        echo -e "${BLUE}Tip: flatpak install flathub <Application.ID>${NC}"
        return 1
    fi

    _display_and_select app_ids disp_lines
    if [[ $? -eq 0 && -n "$SELECTED_PKG" ]]; then
        # Trim any whitespace/color codes that might have slipped in
        local clean_id
        clean_id=$(echo "$SELECTED_PKG" | sed 's/[[:space:]]//g' | \
                   sed 's/\x1b\[[0-9;]*m//g')
        echo -e "${YELLOW}$(get_msg "install_package_num"): ${GREEN}${clean_id}${NC} (y/N)? "
        read -r confirm
        if [[ $confirm =~ ^[Yy]$ ]]; then
            echo -e "${GREEN}Installing ${clean_id} from flathub...${NC}"
            flatpak install -y flathub "$clean_id"
        else
            echo -e "${YELLOW}Installation cancelled${NC}"
        fi
    fi
}

install_flatpak_package() {
    local package="$1"

    if [[ -z "$package" ]]; then
        echo -e "${CYAN}$(get_msg "install_flatpak")${NC}"
        echo "1. $(get_msg "search_flatpak")"
        echo "2. $(get_msg "manual_entry") (Application ID)"
        echo "0. $(get_msg "back")"
        echo
        read -p "$(get_msg "enter_choice") " choice
        case $choice in
            1)
                read -p "$(get_msg "enter_package") " search_term
                [[ -n "$search_term" ]] && search_flatpak "$search_term"
                return ;;
            2)
                read -p "Enter Application ID (e.g. org.videolan.VLC): " package
                [[ -z "$package" ]] && return ;;
            0) return ;;
            *) echo -e "${RED}$(get_msg "invalid_option")${NC}"; return 1 ;;
        esac
    fi

    [[ -z "$package" ]] && { echo -e "${RED}$(get_msg "error") $(get_msg "no_package")${NC}"; return 1; }

    echo -e "${GREEN}$(get_msg "installing") $package...${NC}"
    if ! flatpak install -y flathub "$package" 2>/dev/null; then
        echo -e "${YELLOW}Not found in flathub, trying all remotes...${NC}"
        if ! flatpak install -y "$package" 2>/dev/null; then
            echo -e "${RED}Failed to install $package${NC}"
            echo -e "${YELLOW}Use search to find the correct Application ID${NC}"
        fi
    fi
}

# ─── SNAP Search & Install ────────────────────────────────────────────────────
search_snap() {
    local query="$1"
    [[ -z "$query" ]] && { echo -e "${RED}$(get_msg "error") $(get_msg "no_package")${NC}"; return 1; }

    echo -e "${CYAN}$(get_msg "searching") \"$query\" (Snap)...${NC}"

    local -a pkg_names=()
    local -a disp_lines=()

    # snap find output: Name  Version  Publisher  Notes  Summary
    while IFS= read -r line; do
        read -ra fields <<< "$line"
        [[ ${#fields[@]} -lt 2 ]] && continue
        local n="${fields[0]}" ver="${fields[1]}" pub="${fields[2]}" summary="${fields[*]:4}"
        [[ "$n" == "Name" ]] && continue
        [[ -z "$n" ]] && continue

        local mark=""
        snap list 2>/dev/null | grep -q "^$n " && mark=" $(get_msg "installed")"

        disp_lines+=("${CYAN}$n${NC}${mark} v${ver} by ${pub}\n  ${summary}")
        pkg_names+=("$n")
        [[ ${#pkg_names[@]} -ge 50 ]] && break
    done < <(snap find "$query" 2>/dev/null | tail -n +2)

    if [[ ${#pkg_names[@]} -eq 0 ]]; then
        echo -e "${YELLOW}No Snap packages found for: $query${NC}"
        return 1
    fi

    _display_and_select pkg_names disp_lines
    if [[ $? -eq 0 && -n "$SELECTED_PKG" ]]; then
        echo -e "${YELLOW}$(get_msg "install_package_num"): ${GREEN}${SELECTED_PKG}${NC} (y/N)? "
        read -r confirm
        if [[ $confirm =~ ^[Yy]$ ]]; then
            echo -e "${CYAN}Install mode: (1) Normal  (2) Classic  (3) Devmode [1]: ${NC}"
            read -r mode_choice
            case $mode_choice in
                2) sudo snap install "$SELECTED_PKG" --classic ;;
                3) sudo snap install "$SELECTED_PKG" --devmode ;;
                *) sudo snap install "$SELECTED_PKG" ;;
            esac
        else
            echo -e "${YELLOW}Installation cancelled${NC}"
        fi
    fi
}

install_snap_package() {
    local package="$1"

    if [[ -z "$package" ]]; then
        echo -e "${CYAN}$(get_msg "install_snap")${NC}"
        echo "1. $(get_msg "search_snap")"
        echo "2. $(get_msg "manual_entry")"
        echo "0. $(get_msg "back")"
        echo
        read -p "$(get_msg "enter_choice") " choice
        case $choice in
            1)
                read -p "$(get_msg "enter_package") " search_term
                [[ -n "$search_term" ]] && search_snap "$search_term"
                return ;;
            2)
                read -p "$(get_msg "enter_package") " package
                [[ -z "$package" ]] && return ;;
            0) return ;;
            *) echo -e "${RED}$(get_msg "invalid_option")${NC}"; return 1 ;;
        esac
    fi

    [[ -z "$package" ]] && { echo -e "${RED}$(get_msg "error") $(get_msg "no_package")${NC}"; return 1; }
    echo -e "${GREEN}$(get_msg "installing") $package...${NC}"
    sudo snap install "$package"
}

# ─── Smart Remove ─────────────────────────────────────────────────────────────
_smart_remove_generic() {
    local title="$1" list_cmd="$2" remove_cmd="$3"
    echo -e "${CYAN}${title}${NC}"
    echo "1. $(get_msg "manual_entry")"
    echo "2. $(get_msg "browse_packages")"
    echo "0. $(get_msg "back")"
    echo
    read -p "$(get_msg "enter_choice") " choice

    case $choice in
        1)
            read -p "$(get_msg "enter_package") " pkg
            if [[ -n "$pkg" ]]; then
                echo -e "${YELLOW}$(get_msg "confirm_remove") $pkg? (y/N)${NC}"
                read -r confirm
                [[ $confirm =~ ^[Yy]$ ]] && eval "$remove_cmd \"$pkg\"" && \
                    echo -e "${GREEN}$(get_msg "package_removed")${NC}" || \
                    echo -e "${YELLOW}$(get_msg "removal_cancelled")${NC}"
            fi
            pause ;;
        2)
            echo -e "${CYAN}$(get_msg "listing")${NC}"
            local pkgs
            pkgs=$(eval "$list_cmd" 2>/dev/null | grep -v "^$")
            if [[ -z "$pkgs" ]]; then
                echo -e "${YELLOW}No packages found${NC}"
                pause; return
            fi

            # Display with numbers
            local -a pkg_arr=()
            local idx=1
            while IFS= read -r p; do
                [[ -z "$p" ]] && continue
                echo "$idx. $p"
                pkg_arr+=("$p")
                ((idx++))
            done <<< "$pkgs"
            echo "0. $(get_msg "back")"
            echo

            read -p "$(get_msg "enter_choice") " sel
            [[ "$sel" == "0" ]] && return
            if [[ "$sel" =~ ^[0-9]+$ ]] && [[ "$sel" -ge 1 ]] && [[ "$sel" -le "${#pkg_arr[@]}" ]]; then
                local chosen="${pkg_arr[$((sel-1))]}"
                echo -e "${YELLOW}$(get_msg "confirm_remove") $chosen? (y/N)${NC}"
                read -r confirm
                if [[ $confirm =~ ^[Yy]$ ]]; then
                    eval "$remove_cmd \"$chosen\"" && echo -e "${GREEN}$(get_msg "package_removed")${NC}"
                else
                    echo -e "${YELLOW}$(get_msg "removal_cancelled")${NC}"
                fi
            else
                echo -e "${RED}$(get_msg "invalid_option")${NC}"
            fi
            pause ;;
        0) return ;;
        *) echo -e "${RED}$(get_msg "invalid_option")${NC}"; pause ;;
    esac
}

smart_remove_system() {
    local pm=$(detect_package_manager)
    local list_cmd remove_cmd
    case $pm in
        apt)    list_cmd="dpkg-query -f '\${Package}\n' -W | sort"
                remove_cmd="sudo apt remove -y" ;;
        dnf)    list_cmd="dnf list installed | awk 'NR>1{print \$1}' | cut -d. -f1 | sort"
                remove_cmd="sudo dnf remove -y" ;;
        yum)    list_cmd="yum list installed | awk 'NR>1{print \$1}' | cut -d. -f1 | sort"
                remove_cmd="sudo yum remove -y" ;;
        pacman) list_cmd="pacman -Q | awk '{print \$1}' | sort"
                remove_cmd="sudo pacman -R --noconfirm" ;;
        zypper) list_cmd="zypper search -i | grep '^i' | awk '{print \$3}' | sort"
                remove_cmd="sudo zypper remove -y" ;;
        eopkg)  list_cmd="eopkg list-installed | awk '{print \$1}' | sort"
                remove_cmd="sudo eopkg remove" ;;
        xbps)   list_cmd="xbps-query -l | awk '{print \$2}' | sed 's/-[0-9].*//' | sort"
                remove_cmd="sudo xbps-remove" ;;
        apk)    list_cmd="apk info | sort"
                remove_cmd="sudo apk del" ;;
        nix)    list_cmd="nix-env -q | sort"
                remove_cmd="nix-env -e" ;;
        brew)   list_cmd="brew list | sort"
                remove_cmd="brew uninstall" ;;
        pkg)    list_cmd="pkg info | awk '{print \$1}' | sort"
                remove_cmd="sudo pkg delete -y" ;;
        *)      echo -e "${RED}$(get_msg "error") $(get_msg "not_found")${NC}"; return 1 ;;
    esac
    _smart_remove_generic "$(get_msg "smart_remove")" "$list_cmd" "$remove_cmd"
}

smart_remove_flatpak() {
    _smart_remove_generic \
        "$(get_msg "smart_remove_flatpak")" \
        "flatpak list --app --columns=application | tail -n +1 | sort" \
        "flatpak uninstall -y"
}

smart_remove_snap() {
    _smart_remove_generic \
        "$(get_msg "smart_remove_snap")" \
        "snap list | awk 'NR>1{print \$1}' | sort" \
        "sudo snap remove"
}

# ─── Other Installers ─────────────────────────────────────────────────────────
_check_and_offer_install() {
    local cmd="$1" pkg="$2" label="$3"
    if ! command -v "$cmd" &>/dev/null; then
        echo -e "${YELLOW}$label $(get_msg "not_installed_auto")${NC}"
        read -r ans
        if [[ $ans =~ ^[Yy]$ ]]; then
            install_package "$pkg"
        else
            return 1
        fi
    fi
    return 0
}

python_tools_menu() {
    while true; do
        show_header "$(get_msg "python_tools")"
        # Dependency check
        if ! command -v python3 &>/dev/null && ! command -v python &>/dev/null; then
            echo -e "${YELLOW}Python not found. Install? (y/N)${NC}"
            read -r ans
            [[ $ans =~ ^[Yy]$ ]] && install_package "python3 python3-pip python3-venv" || { pause; return; }
        fi
        local py_cmd="python3"; command -v python3 &>/dev/null || py_cmd="python"
        local pip_cmd="pip3"; command -v pip3 &>/dev/null || pip_cmd="pip"
        local has_pipx=0; command -v pipx &>/dev/null && has_pipx=1
        echo -e "${GREEN}$(get_msg "dependency_ok") [$py_cmd] [${pip_cmd}]${has_pipx:+ [pipx]}${NC}"
        echo
        echo "1. Install with pipx (recommended - isolated)"
        echo "2. Install in virtual environment"
        echo "3. Install with pip --user (no sudo)"
        echo "4. Install with pip --break-system-packages (last resort)"
        echo "5. Remove Python package"
        echo "6. List installed packages"
        echo "7. Create virtual environment"
        echo "8. Activate virtual environment"
        echo "9. Search PyPI (online)"
        echo "0. $(get_msg "back")"
        echo
        read -p "$(get_msg "enter_choice") " choice

        case $choice in
            1)
                _check_and_offer_install pipx pipx pipx || { pause; continue; }
                read -p "Package name: " pkg
                [[ -n "$pkg" ]] && pipx install "$pkg" && pipx ensurepath
                pause ;;
            2)
                read -p "Package name: " pkg
                read -p "Virtual env name [default: $pkg]: " vname
                vname="${vname:-$pkg}"
                if [[ -n "$pkg" ]]; then
                    $py_cmd -m venv "$HOME/venv_${vname}"
                    "$HOME/venv_${vname}/bin/pip" install "$pkg"
                    echo -e "${GREEN}Installed. Activate with: source $HOME/venv_${vname}/bin/activate${NC}"
                fi
                pause ;;
            3)
                read -p "Package name: " pkg
                [[ -n "$pkg" ]] && $pip_cmd install --user "$pkg"
                pause ;;
            4)
                read -p "Package name: " pkg
                if [[ -n "$pkg" ]]; then
                    echo -e "${YELLOW}Warning: may affect system packages. Continue? (y/N)${NC}"
                    read -r conf
                    [[ $conf =~ ^[Yy]$ ]] && $pip_cmd install "$pkg" --break-system-packages
                fi
                pause ;;
            5)
                echo "1. Remove pipx package"
                echo "2. Remove pip --user package"
                echo "3. Remove from venv"
                read -p "$(get_msg "enter_choice") " sc
                case $sc in
                    1)
                        command -v pipx &>/dev/null && pipx list --short && \
                            read -p "Package: " pkg && [[ -n "$pkg" ]] && pipx uninstall "$pkg"
                        ;;
                    2)
                        $pip_cmd list --user 2>/dev/null
                        read -p "Package: " pkg
                        [[ -n "$pkg" ]] && $pip_cmd uninstall "$pkg" ;;
                    3)
                        echo "Virtual envs in \$HOME:"
                        ls -d "$HOME"/venv_* 2>/dev/null | sed "s|$HOME/||"
                        read -p "Venv name (without venv_ prefix): " vname
                        read -p "Package to remove: " pkg
                        if [[ -n "$vname" && -n "$pkg" && -d "$HOME/venv_${vname}" ]]; then
                            "$HOME/venv_${vname}/bin/pip" uninstall "$pkg"
                        fi ;;
                esac
                pause ;;
            6)
                echo "=== pipx ==="
                command -v pipx &>/dev/null && pipx list --short
                echo "=== pip user ==="
                $pip_cmd list --user 2>/dev/null
                pause ;;
            7)
                read -p "Venv name: " vname
                if [[ -n "$vname" ]]; then
                    $py_cmd -m venv "$HOME/venv_${vname}"
                    echo -e "${GREEN}Created: $HOME/venv_${vname}${NC}"
                    echo -e "${CYAN}Activate: source $HOME/venv_${vname}/bin/activate${NC}"
                fi
                pause ;;
            8)
                echo "Available venvs:"
                ls -d "$HOME"/venv_* 2>/dev/null | sed "s|$HOME/venv_||"
                read -p "Venv name: " vname
                if [[ -n "$vname" && -d "$HOME/venv_${vname}" ]]; then
                    echo -e "${CYAN}Run: source $HOME/venv_${vname}/bin/activate${NC}"
                    echo -e "${YELLOW}(Cannot activate in subprocess; copy the command above)${NC}"
                fi
                pause ;;
            9)
                read -p "Search PyPI for: " q
                if [[ -n "$q" ]]; then
                    if command -v pip3 &>/dev/null; then
                        pip3 index versions "$q" 2>/dev/null | head -5 || \
                            echo -e "${BLUE}Visit: https://pypi.org/search/?q=$q${NC}"
                    else
                        echo -e "${BLUE}Visit: https://pypi.org/search/?q=$q${NC}"
                    fi
                fi
                pause ;;
            0) break ;;
            *) echo -e "${RED}$(get_msg "invalid_option")${NC}"; pause ;;
        esac
    done
}

nodejs_tools_menu() {
    while true; do
        show_header "$(get_msg "nodejs_tools")"
        if ! command -v node &>/dev/null; then
            echo -e "${YELLOW}Node.js not found. Install? (y/N)${NC}"
            read -r ans
            [[ $ans =~ ^[Yy]$ ]] && install_package "nodejs npm" || { pause; return; }
        fi
        local node_ver; node_ver=$(node --version 2>/dev/null)
        local npm_ver; npm_ver=$(npm --version 2>/dev/null)
        echo -e "${GREEN}$(get_msg "dependency_ok") [node ${node_ver}] [npm ${npm_ver}]${NC}"
        command -v yarn &>/dev/null && echo -e "${GREEN}[yarn $(yarn --version 2>/dev/null)]${NC}"
        command -v pnpm &>/dev/null && echo -e "${GREEN}[pnpm $(pnpm --version 2>/dev/null)]${NC}"
        echo
        echo "1. Install package globally (npm)"
        echo "2. Install package locally (npm)"
        echo "3. Run package with npx"
        echo "4. Remove package"
        echo "5. List installed packages"
        echo "6. Install with yarn"
        echo "7. Install with pnpm"
        echo "8. Install yarn (if missing)"
        echo "9. Install pnpm (if missing)"
        echo "0. $(get_msg "back")"
        echo
        read -p "$(get_msg "enter_choice") " choice

        case $choice in
            1)
                read -p "Package name: " pkg
                [[ -n "$pkg" ]] && sudo npm install -g "$pkg"
                pause ;;
            2)
                read -p "Package name: " pkg
                [[ -n "$pkg" ]] && npm install "$pkg"
                pause ;;
            3)
                read -p "Package (with args) to run via npx: " pkg
                [[ -n "$pkg" ]] && npx $pkg
                pause ;;
            4)
                echo "1. Global  2. Local  3. yarn  4. pnpm"
                read -p "$(get_msg "enter_choice") " sc
                read -p "Package name: " pkg
                [[ -z "$pkg" ]] && { pause; continue; }
                case $sc in
                    1) sudo npm uninstall -g "$pkg" ;;
                    2) npm uninstall "$pkg" ;;
                    3) command -v yarn &>/dev/null && yarn remove "$pkg" || echo "yarn not found" ;;
                    4) command -v pnpm &>/dev/null && pnpm remove "$pkg" || echo "pnpm not found" ;;
                esac
                pause ;;
            5)
                echo "=== Global ==="
                npm list -g --depth=0 2>/dev/null
                echo "=== Local (current dir) ==="
                npm list --depth=0 2>/dev/null
                pause ;;
            6)
                _check_and_offer_install yarn "npm install -g yarn" yarn || { pause; continue; }
                read -p "Package name: " pkg
                [[ -n "$pkg" ]] && yarn add "$pkg"
                pause ;;
            7)
                _check_and_offer_install pnpm "npm install -g pnpm" pnpm || { pause; continue; }
                read -p "Package name: " pkg
                [[ -n "$pkg" ]] && pnpm add "$pkg"
                pause ;;
            8)
                sudo npm install -g yarn && echo -e "${GREEN}yarn installed${NC}"
                pause ;;
            9)
                sudo npm install -g pnpm && echo -e "${GREEN}pnpm installed${NC}"
                pause ;;
            0) break ;;
            *) echo -e "${RED}$(get_msg "invalid_option")${NC}"; pause ;;
        esac
    done
}

ruby_tools_menu() {
    while true; do
        show_header "$(get_msg "ruby_tools")"
        if ! command -v ruby &>/dev/null; then
            echo -e "${YELLOW}Ruby not found. Install? (y/N)${NC}"
            read -r ans
            [[ $ans =~ ^[Yy]$ ]] && install_package "ruby ruby-dev" || { pause; return; }
        fi
        echo -e "${GREEN}$(get_msg "dependency_ok") [ruby $(ruby --version 2>/dev/null | awk '{print $2}')]${NC}"
        echo
        echo "1. Install gem"
        echo "2. Install gem (user install)"
        echo "3. Remove gem"
        echo "4. List installed gems"
        echo "5. Update all gems"
        echo "6. Install bundler"
        echo "7. Bundle install (Gemfile)"
        echo "0. $(get_msg "back")"
        echo
        read -p "$(get_msg "enter_choice") " choice

        case $choice in
            1)
                read -p "Gem name: " pkg
                [[ -n "$pkg" ]] && sudo gem install "$pkg"
                pause ;;
            2)
                read -p "Gem name: " pkg
                [[ -n "$pkg" ]] && gem install --user-install "$pkg"
                pause ;;
            3)
                gem list 2>/dev/null | head -30
                read -p "Gem name: " pkg
                if [[ -n "$pkg" ]]; then
                    echo -e "${YELLOW}$(get_msg "confirm_remove") $pkg? (y/N)${NC}"
                    read -r conf
                    [[ $conf =~ ^[Yy]$ ]] && sudo gem uninstall "$pkg"
                fi
                pause ;;
            4)
                gem list 2>/dev/null
                pause ;;
            5)
                sudo gem update
                pause ;;
            6)
                sudo gem install bundler && echo -e "${GREEN}bundler installed${NC}"
                pause ;;
            7)
                if [[ -f "Gemfile" ]]; then
                    bundle install
                else
                    echo -e "${RED}No Gemfile found in current directory${NC}"
                fi
                pause ;;
            0) break ;;
            *) echo -e "${RED}$(get_msg "invalid_option")${NC}"; pause ;;
        esac
    done
}

rust_tools_menu() {
    while true; do
        show_header "$(get_msg "rust_tools")"
        if ! command -v cargo &>/dev/null; then
            echo -e "${YELLOW}Rust/cargo not found.${NC}"
            echo "1. Install via rustup (recommended)"
            echo "2. Install via system package manager"
            echo "0. Back"
            read -p "$(get_msg "enter_choice") " sc
            case $sc in
                1)
                    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
                    # shellcheck source=/dev/null
                    source "$HOME/.cargo/env" 2>/dev/null || export PATH="$HOME/.cargo/bin:$PATH"
                    ;;
                2) install_package "rust cargo" ;;
            esac
            pause; continue
        fi
        echo -e "${GREEN}$(get_msg "dependency_ok") [rustc $(rustc --version 2>/dev/null | awk '{print $2}')] [cargo $(cargo --version 2>/dev/null | awk '{print $2}')]${NC}"
        echo
        echo "1. Install crate (cargo install)"
        echo "2. Remove crate"
        echo "3. List installed crates"
        echo "4. Update all crates"
        echo "5. Update Rust toolchain (rustup)"
        echo "6. Add Rust component (e.g. clippy, rustfmt)"
        echo "0. $(get_msg "back")"
        echo
        read -p "$(get_msg "enter_choice") " choice

        source "$HOME/.cargo/env" 2>/dev/null || export PATH="$HOME/.cargo/bin:$PATH"
        case $choice in
            1)
                read -p "Crate name: " pkg
                [[ -n "$pkg" ]] && cargo install "$pkg"
                pause ;;
            2)
                cargo install --list 2>/dev/null | grep '^[a-z]' | awk '{print $1}'
                read -p "Crate name: " pkg
                if [[ -n "$pkg" ]]; then
                    echo -e "${YELLOW}$(get_msg "confirm_remove") $pkg? (y/N)${NC}"
                    read -r conf
                    [[ $conf =~ ^[Yy]$ ]] && cargo uninstall "$pkg"
                fi
                pause ;;
            3)
                cargo install --list 2>/dev/null
                pause ;;
            4)
                cargo install-update -a 2>/dev/null || \
                    echo -e "${YELLOW}Install cargo-update first: cargo install cargo-update${NC}"
                pause ;;
            5)
                command -v rustup &>/dev/null && rustup update || echo -e "${YELLOW}rustup not found${NC}"
                pause ;;
            6)
                read -p "Component name (e.g. clippy, rustfmt): " comp
                [[ -n "$comp" ]] && rustup component add "$comp"
                pause ;;
            0) break ;;
            *) echo -e "${RED}$(get_msg "invalid_option")${NC}"; pause ;;
        esac
    done
}

go_tools_menu() {
    while true; do
        show_header "$(get_msg "go_tools")"
        if ! command -v go &>/dev/null; then
            echo -e "${YELLOW}Go not found. Install? (y/N)${NC}"
            read -r ans
            if [[ $ans =~ ^[Yy]$ ]]; then
                # Try system package manager first
                if ! install_package "golang"; then
                    echo -e "${YELLOW}Trying official Go installer...${NC}"
                    local arch
                    arch=$(uname -m)
                    [[ "$arch" == "x86_64" ]] && arch="amd64"
                    [[ "$arch" == "aarch64" ]] && arch="arm64"
                    local GO_VER="1.22.0"
                    curl -fsSL "https://go.dev/dl/go${GO_VER}.linux-${arch}.tar.gz" -o /tmp/go.tar.gz
                    sudo rm -rf /usr/local/go
                    sudo tar -C /usr/local -xzf /tmp/go.tar.gz
                    echo 'export PATH=$PATH:/usr/local/go/bin' >> "$HOME/.bashrc"
                    export PATH=$PATH:/usr/local/go/bin
                    echo -e "${GREEN}Go installed. Restart terminal or run: source ~/.bashrc${NC}"
                fi
            fi
            pause; continue
        fi
        echo -e "${GREEN}$(get_msg "dependency_ok") [$(go version 2>/dev/null)]${NC}"
        echo
        echo "1. Install package (go install)"
        echo "2. Install specific version"
        echo "3. List installed binaries"
        echo "4. Remove installed binary"
        echo "5. Update Go version"
        echo "6. go get (add dependency to project)"
        echo "0. $(get_msg "back")"
        echo
        read -p "$(get_msg "enter_choice") " choice

        export PATH=$PATH:/usr/local/go/bin:"$HOME/go/bin"
        case $choice in
            1)
                read -p "Package path (e.g. github.com/user/tool@latest): " pkg
                [[ -n "$pkg" ]] && go install "$pkg"
                pause ;;
            2)
                read -p "Package path with version (e.g. tool@v1.2.3): " pkg
                [[ -n "$pkg" ]] && go install "$pkg"
                pause ;;
            3)
                echo "Binaries in \$GOPATH/bin:"
                ls "${GOPATH:-$HOME/go}/bin" 2>/dev/null
                pause ;;
            4)
                ls "${GOPATH:-$HOME/go}/bin" 2>/dev/null
                read -p "Binary name to remove: " bin
                if [[ -n "$bin" ]]; then
                    rm -f "${GOPATH:-$HOME/go}/bin/$bin" && \
                        echo -e "${GREEN}$bin removed${NC}" || echo -e "${RED}Not found${NC}"
                fi
                pause ;;
            5)
                echo -e "${BLUE}Visit https://go.dev/dl/ for latest version${NC}"
                pause ;;
            6)
                read -p "Package path: " pkg
                [[ -n "$pkg" ]] && go get "$pkg"
                pause ;;
            0) break ;;
            *) echo -e "${RED}$(get_msg "invalid_option")${NC}"; pause ;;
        esac
    done
}

haskell_tools_menu() {
    while true; do
        show_header "$(get_msg "haskell_tools")"
        local has_cabal=0 has_stack=0 has_ghcup=0
        command -v cabal &>/dev/null && has_cabal=1
        command -v stack &>/dev/null && has_stack=1
        command -v ghcup &>/dev/null && has_ghcup=1

        if [[ $has_cabal -eq 0 && $has_stack -eq 0 ]]; then
            echo -e "${YELLOW}No Haskell tools found.${NC}"
            echo "1. Install via GHCup (recommended)"
            echo "2. Install cabal via system PM"
            echo "3. Install stack via system PM"
            echo "0. Back"
            read -p "$(get_msg "enter_choice") " sc
            case $sc in
                1)
                    curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | sh
                    ;;
                2) install_package "cabal-install" ;;
                3) install_package "haskell-stack" ;;
            esac
            pause; continue
        fi

        echo -e "${GREEN}$(get_msg "dependency_ok")${has_cabal:+ [cabal]}${has_stack:+ [stack]}${has_ghcup:+ [ghcup]}${NC}"
        echo
        echo "1. Install package with cabal"
        echo "2. Install package with stack"
        echo "3. List cabal packages"
        echo "4. Update cabal package list"
        echo "5. Update GHC via ghcup"
        echo "6. Build project (cabal build)"
        echo "7. Build project (stack build)"
        echo "0. $(get_msg "back")"
        echo
        read -p "$(get_msg "enter_choice") " choice

        case $choice in
            1)
                [[ $has_cabal -eq 0 ]] && { echo -e "${RED}cabal not found${NC}"; pause; continue; }
                read -p "Package name: " pkg
                [[ -n "$pkg" ]] && cabal install "$pkg"
                pause ;;
            2)
                [[ $has_stack -eq 0 ]] && { echo -e "${RED}stack not found${NC}"; pause; continue; }
                read -p "Package name: " pkg
                [[ -n "$pkg" ]] && stack install "$pkg"
                pause ;;
            3)
                [[ $has_cabal -eq 1 ]] && ghc-pkg list 2>/dev/null || echo "cabal not available"
                pause ;;
            4)
                [[ $has_cabal -eq 1 ]] && cabal update || echo "cabal not available"
                pause ;;
            5)
                [[ $has_ghcup -eq 1 ]] && ghcup upgrade || echo "ghcup not available"
                pause ;;
            6)
                cabal build 2>/dev/null || echo -e "${RED}No cabal project in current directory${NC}"
                pause ;;
            7)
                stack build 2>/dev/null || echo -e "${RED}No stack project in current directory${NC}"
                pause ;;
            0) break ;;
            *) echo -e "${RED}$(get_msg "invalid_option")${NC}"; pause ;;
        esac
    done
}

java_tools_menu() {
    while true; do
        show_header "$(get_msg "java_tools")"
        local has_java=0 has_mvn=0 has_gradle=0 has_sdk=0
        command -v java &>/dev/null && has_java=1
        command -v mvn &>/dev/null && has_mvn=1
        command -v gradle &>/dev/null && has_gradle=1
        command -v sdk &>/dev/null && has_sdk=1

        if [[ $has_java -eq 0 ]]; then
            echo -e "${YELLOW}Java not found. Install? (y/N)${NC}"
            read -r ans
            if [[ $ans =~ ^[Yy]$ ]]; then
                local pm=$(detect_package_manager)
                case $pm in
                    apt)    sudo apt install -y default-jdk ;;
                    dnf)    sudo dnf install -y java-latest-openjdk ;;
                    pacman) sudo pacman -S --noconfirm jdk-openjdk ;;
                    zypper) sudo zypper install -y java-21-openjdk ;;
                    *)      install_package "openjdk" ;;
                esac
            fi
            pause; continue
        fi

        echo -e "${GREEN}$(get_msg "dependency_ok") [java $(java -version 2>&1 | head -1)]${has_mvn:+ [mvn]}${has_gradle:+ [gradle]}${has_sdk:+ [sdkman]}${NC}"
        echo
        echo "1. Install Maven"
        echo "2. Install Gradle"
        echo "3. Run Maven command"
        echo "4. Run Gradle command"
        echo "5. Install SDKMAN"
        echo "6. Manage JDK via SDKMAN"
        echo "7. Show Java version info"
        echo "8. Switch Java version (update-alternatives)"
        echo "0. $(get_msg "back")"
        echo
        read -p "$(get_msg "enter_choice") " choice

        case $choice in
            1)
                [[ $has_mvn -eq 1 ]] && { echo -e "${YELLOW}Maven already installed${NC}"; pause; continue; }
                install_package "maven"
                pause ;;
            2)
                [[ $has_gradle -eq 1 ]] && { echo -e "${YELLOW}Gradle already installed${NC}"; pause; continue; }
                install_package "gradle"
                pause ;;
            3)
                [[ $has_mvn -eq 0 ]] && { echo -e "${RED}Maven not installed${NC}"; pause; continue; }
                read -p "Maven command (e.g. clean install -DskipTests): " cmd
                [[ -n "$cmd" ]] && mvn $cmd
                pause ;;
            4)
                [[ $has_gradle -eq 0 ]] && { echo -e "${RED}Gradle not installed${NC}"; pause; continue; }
                read -p "Gradle task (e.g. build): " cmd
                [[ -n "$cmd" ]] && gradle $cmd
                pause ;;
            5)
                [[ $has_sdk -eq 1 ]] && { echo -e "${YELLOW}SDKMAN already installed${NC}"; pause; continue; }
                curl -s "https://get.sdkman.io" | bash
                echo -e "${GREEN}SDKMAN installed. Run: source ~/.sdkman/bin/sdkman-init.sh${NC}"
                pause ;;
            6)
                if [[ $has_sdk -eq 1 ]]; then
                    # shellcheck source=/dev/null
                    source "$HOME/.sdkman/bin/sdkman-init.sh" 2>/dev/null
                    echo "1. List Java versions  2. Install Java version  3. Use Java version"
                    read -p "$(get_msg "enter_choice") " sc
                    case $sc in
                        1) sdk list java ;;
                        2) read -p "Version (e.g. 21.0.2-tem): " v; sdk install java "$v" ;;
                        3) read -p "Version: " v; sdk use java "$v" ;;
                    esac
                else
                    echo -e "${RED}SDKMAN not installed${NC}"
                fi
                pause ;;
            7)
                java -version 2>&1
                javac -version 2>/dev/null
                pause ;;
            8)
                if command -v update-alternatives &>/dev/null; then
                    sudo update-alternatives --config java
                else
                    echo -e "${YELLOW}update-alternatives not available${NC}"
                fi
                pause ;;
            0) break ;;
            *) echo -e "${RED}$(get_msg "invalid_option")${NC}"; pause ;;
        esac
    done
}

php_tools_menu() {
    while true; do
        show_header "$(get_msg "php_tools")"
        if ! command -v php &>/dev/null; then
            echo -e "${YELLOW}PHP not found. Install? (y/N)${NC}"
            read -r ans
            if [[ $ans =~ ^[Yy]$ ]]; then
                local pm=$(detect_package_manager)
                case $pm in
                    apt)    sudo apt install -y php php-cli php-common ;;
                    dnf)    sudo dnf install -y php php-cli ;;
                    pacman) sudo pacman -S --noconfirm php ;;
                    zypper) sudo zypper install -y php8 ;;
                    *)      install_package "php" ;;
                esac
            fi
            pause; continue
        fi
        local has_composer=0
        command -v composer &>/dev/null && has_composer=1

        echo -e "${GREEN}$(get_msg "dependency_ok") [php $(php --version 2>/dev/null | head -1 | awk '{print $2}')]${has_composer:+ [composer]}${NC}"
        echo
        echo "1. Install Composer"
        echo "2. Install package (composer require)"
        echo "3. Install package globally (composer global require)"
        echo "4. Remove package"
        echo "5. Update packages (composer update)"
        echo "6. Install project dependencies (composer install)"
        echo "7. List installed packages"
        echo "8. Install PHP extensions"
        echo "0. $(get_msg "back")"
        echo
        read -p "$(get_msg "enter_choice") " choice

        case $choice in
            1)
                [[ $has_composer -eq 1 ]] && { echo -e "${YELLOW}Composer already installed${NC}"; pause; continue; }
                curl -sS https://getcomposer.org/installer | php
                sudo mv composer.phar /usr/local/bin/composer
                sudo chmod +x /usr/local/bin/composer
                echo -e "${GREEN}Composer installed${NC}"
                has_composer=1
                pause ;;
            2)
                [[ $has_composer -eq 0 ]] && { echo -e "${RED}Composer not installed${NC}"; pause; continue; }
                read -p "Package (e.g. vendor/package): " pkg
                [[ -n "$pkg" ]] && composer require "$pkg"
                pause ;;
            3)
                [[ $has_composer -eq 0 ]] && { echo -e "${RED}Composer not installed${NC}"; pause; continue; }
                read -p "Package: " pkg
                [[ -n "$pkg" ]] && composer global require "$pkg"
                pause ;;
            4)
                [[ $has_composer -eq 0 ]] && { echo -e "${RED}Composer not installed${NC}"; pause; continue; }
                read -p "Package: " pkg
                [[ -n "$pkg" ]] && composer remove "$pkg"
                pause ;;
            5)
                [[ $has_composer -eq 0 ]] && { echo -e "${RED}Composer not installed${NC}"; pause; continue; }
                composer update
                pause ;;
            6)
                [[ $has_composer -eq 0 ]] && { echo -e "${RED}Composer not installed${NC}"; pause; continue; }
                composer install
                pause ;;
            7)
                [[ $has_composer -eq 0 ]] && { echo -e "${RED}Composer not installed${NC}"; pause; continue; }
                composer show 2>/dev/null
                pause ;;
            8)
                echo "Common PHP extensions:"
                echo "mbstring, curl, gd, mysql, sqlite3, xml, zip, intl, pgsql"
                read -p "Extension name(s) (space separated): " exts
                if [[ -n "$exts" ]]; then
                    local pm=$(detect_package_manager)
                    for ext in $exts; do
                        case $pm in
                            apt)    sudo apt install -y "php-${ext}" 2>/dev/null || \
                                    sudo apt install -y "php$(php -r 'echo PHP_MAJOR_VERSION.".".PHP_MINOR_VERSION;')-${ext}" ;;
                            dnf)    sudo dnf install -y "php-${ext}" ;;
                            pacman) sudo pacman -S --noconfirm "php-${ext}" ;;
                            *)      install_package "php-${ext}" ;;
                        esac
                    done
                fi
                pause ;;
            0) break ;;
            *) echo -e "${RED}$(get_msg "invalid_option")${NC}"; pause ;;
        esac
    done
}

scientific_tools_menu() {
    while true; do
        show_header "$(get_msg "scientific_tools")"
        local has_spack=0 has_conda=0 has_mamba=0
        command -v spack &>/dev/null && has_spack=1
        command -v conda &>/dev/null && has_conda=1
        command -v mamba &>/dev/null && has_mamba=1

        echo -e "${CYAN}Available scientific package managers:${NC}"
        [[ $has_spack -eq 1 ]] && echo -e "  ${GREEN}✓ Spack${NC}" || echo -e "  ${RED}✗ Spack${NC}"
        [[ $has_conda -eq 1 ]] && echo -e "  ${GREEN}✓ Conda${NC}" || echo -e "  ${RED}✗ Conda${NC}"
        [[ $has_mamba -eq 1 ]] && echo -e "  ${GREEN}✓ Mamba${NC}" || echo -e "  ${RED}✗ Mamba${NC}"
        echo
        echo "1. Install Spack"
        echo "2. Install with Spack"
        echo "3. Install Miniconda (conda)"
        echo "4. Install with conda"
        echo "5. Install Mamba (faster conda)"
        echo "6. Install with mamba"
        echo "7. Create conda environment"
        echo "8. List conda environments"
        echo "0. $(get_msg "back")"
        echo
        read -p "$(get_msg "enter_choice") " choice

        case $choice in
            1)
                [[ $has_spack -eq 1 ]] && { echo -e "${YELLOW}Spack already installed${NC}"; pause; continue; }
                git clone -c feature.manyFiles=true https://github.com/spack/spack.git "$HOME/spack"
                echo 'source $HOME/spack/share/spack/setup-env.sh' >> "$HOME/.bashrc"
                # shellcheck source=/dev/null
                source "$HOME/spack/share/spack/setup-env.sh" 2>/dev/null
                echo -e "${GREEN}Spack installed. Restart terminal or: source ~/.bashrc${NC}"
                pause ;;
            2)
                [[ $has_spack -eq 0 ]] && { echo -e "${RED}Spack not installed${NC}"; pause; continue; }
                source "$HOME/spack/share/spack/setup-env.sh" 2>/dev/null
                read -p "Package name: " pkg
                [[ -n "$pkg" ]] && spack install "$pkg"
                pause ;;
            3)
                [[ $has_conda -eq 1 ]] && { echo -e "${YELLOW}Conda already installed${NC}"; pause; continue; }
                local arch; arch=$(uname -m)
                curl -fsSL "https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-${arch}.sh" -o /tmp/miniconda.sh
                bash /tmp/miniconda.sh -b -p "$HOME/miniconda3"
                "$HOME/miniconda3/bin/conda" init bash 2>/dev/null
                echo -e "${GREEN}Miniconda installed. Restart terminal.${NC}"
                pause ;;
            4)
                [[ $has_conda -eq 0 ]] && { echo -e "${RED}Conda not installed${NC}"; pause; continue; }
                read -p "Package name: " pkg
                [[ -n "$pkg" ]] && conda install -y "$pkg"
                pause ;;
            5)
                if [[ $has_conda -eq 0 ]]; then
                    echo -e "${RED}Conda required first${NC}"; pause; continue
                fi
                conda install -y -c conda-forge mamba
                echo -e "${GREEN}Mamba installed${NC}"
                pause ;;
            6)
                [[ $has_mamba -eq 0 ]] && { echo -e "${RED}Mamba not installed${NC}"; pause; continue; }
                read -p "Package name: " pkg
                [[ -n "$pkg" ]] && mamba install -y "$pkg"
                pause ;;
            7)
                [[ $has_conda -eq 0 ]] && { echo -e "${RED}Conda not installed${NC}"; pause; continue; }
                read -p "Environment name: " ename
                read -p "Python version (e.g. 3.11, leave blank for default): " pyver
                if [[ -n "$ename" ]]; then
                    if [[ -n "$pyver" ]]; then
                        conda create -y -n "$ename" python="$pyver"
                    else
                        conda create -y -n "$ename"
                    fi
                    echo -e "${GREEN}Activate with: conda activate $ename${NC}"
                fi
                pause ;;
            8)
                [[ $has_conda -eq 0 ]] && { echo -e "${RED}Conda not installed${NC}"; pause; continue; }
                conda env list
                pause ;;
            0) break ;;
            *) echo -e "${RED}$(get_msg "invalid_option")${NC}"; pause ;;
        esac
    done
}

# ─── System Tools ─────────────────────────────────────────────────────────────
show_system_info() {
    echo -e "${CYAN}System Information:${NC}"
    echo "═══════════════════════════════════════"
    local os_name
    os_name=$(cat /etc/os-release 2>/dev/null | grep "PRETTY_NAME" | cut -d'"' -f2)
    [[ -z "$os_name" ]] && os_name=$(lsb_release -d 2>/dev/null | cut -f2)
    [[ -z "$os_name" ]] && os_name="Unknown"
    echo -e "${YELLOW}OS:${NC}            $os_name"
    echo -e "${YELLOW}Kernel:${NC}        $(uname -r)"
    echo -e "${YELLOW}Architecture:${NC}  $(uname -m)"
    echo -e "${YELLOW}Hostname:${NC}      $(hostname)"
    echo -e "${YELLOW}Package Mgr:${NC}   $(detect_package_manager)"
    echo -e "${YELLOW}Uptime:${NC}        $(uptime -p 2>/dev/null || uptime)"
    echo -e "${YELLOW}Memory:${NC}        $(free -h 2>/dev/null | awk '/Mem:/{print $3"/"$2}' || echo 'N/A')"
    echo -e "${YELLOW}CPU:${NC}           $(grep "model name" /proc/cpuinfo 2>/dev/null | head -1 | cut -d':' -f2 | sed 's/^ *//' || echo 'N/A')"
    echo -e "${YELLOW}Shell:${NC}         $SHELL ($BASH_VERSION)"
    # Show installed toolchains
    echo
    echo -e "${CYAN}Installed Language Runtimes:${NC}"
    command -v python3 &>/dev/null && echo -e "  ${GREEN}Python3:${NC} $(python3 --version 2>&1)"
    command -v node &>/dev/null && echo -e "  ${GREEN}Node.js:${NC} $(node --version 2>/dev/null)"
    command -v ruby &>/dev/null && echo -e "  ${GREEN}Ruby:${NC}    $(ruby --version 2>/dev/null)"
    command -v go &>/dev/null && echo -e "  ${GREEN}Go:${NC}      $(go version 2>/dev/null)"
    command -v rustc &>/dev/null && echo -e "  ${GREEN}Rust:${NC}   $(rustc --version 2>/dev/null)"
    command -v php &>/dev/null && echo -e "  ${GREEN}PHP:${NC}    $(php --version 2>/dev/null | head -1)"
    command -v java &>/dev/null && echo -e "  ${GREEN}Java:${NC}   $(java -version 2>&1 | head -1)"
}

show_disk_usage() {
    echo -e "${CYAN}Disk Usage:${NC}"
    echo "═══════════════════════════════════════"
    df -h | grep -v "tmpfs\|udev\|loop"
}

backup_packages() {
    local pm=$(detect_package_manager)
    local backup_file="$HOME/gt-clpm-backup-$(date +%Y%m%d_%H%M%S).txt"
    echo -e "${BLUE}Creating package backup...${NC}"
    case $pm in
        apt)    dpkg --get-selections > "$backup_file" ;;
        dnf|yum) $pm list installed > "$backup_file" ;;
        pacman) pacman -Q > "$backup_file" ;;
        zypper) zypper search -i > "$backup_file" ;;
        eopkg)  eopkg list-installed > "$backup_file" ;;
        brew)   brew list > "$backup_file" ;;
        pkg)    pkg info > "$backup_file" ;;
        *)
            echo -e "${YELLOW}$(get_msg "warning") Backup not implemented for this package manager${NC}"
            return 1 ;;
    esac
    echo -e "${GREEN}$(get_msg "backup_created"): $backup_file${NC}"
}

restore_packages() {
    local pm=$(detect_package_manager)
    echo -e "${CYAN}Available backup files:${NC}"
    local files
    files=$(ls "$HOME"/gt-clpm-backup-*.txt 2>/dev/null)
    if [[ -z "$files" ]]; then
        echo -e "${YELLOW}No backup files found in $HOME${NC}"
        return
    fi

    local idx=1
    local -a file_arr=()
    while IFS= read -r f; do
        echo "$idx. $f"
        file_arr+=("$f")
        ((idx++))
    done <<< "$files"
    echo "0. Cancel"
    read -p "Select backup file: " sel
    [[ "$sel" == "0" ]] && return
    [[ -z "${file_arr[$((sel-1))]}" ]] && { echo -e "${RED}$(get_msg "invalid_option")${NC}"; return; }
    local chosen="${file_arr[$((sel-1))]}"

    echo -e "${YELLOW}Warning: This will reinstall packages from backup. Continue? (y/N)${NC}"
    read -r conf
    [[ ! $conf =~ ^[Yy]$ ]] && return

    case $pm in
        apt)    sudo dpkg --set-selections < "$chosen" && sudo apt-get dselect-upgrade -y ;;
        pacman) awk '{print $1}' "$chosen" | sudo pacman -S --noconfirm - ;;
        *)      echo -e "${YELLOW}Restore not automated for $(detect_package_manager). See: $chosen${NC}" ;;
    esac
}

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

show_about() {
    echo -e "${CYAN}About GT-CLPM${NC}"
    echo "═══════════════════════════════════════"
    echo -e "${WHITE}GT-CLPM - GNUTUX Command Line Package Manager${NC}"
    echo -e "${YELLOW}Version:${NC}     1.2"
    echo -e "${YELLOW}License:${NC}     GPLv2"
    echo -e "${YELLOW}Developer:${NC}   GNUTUX"
    echo -e "${YELLOW}Repository:${NC}  https://github.com/SalehGNUTUX/GT-CLPM"
    echo
    echo -e "${GREEN}Supported System Package Managers:${NC}"
    for pm in APT DNF/YUM Pacman Zypper Eopkg XBPS Emerge APK Nix Homebrew PKG; do
        echo "  • $pm"
    done
    echo
    echo -e "${GREEN}Supported Language Package Managers:${NC}"
    echo "  • Python (pip, pipx, venv)  • Node.js (npm, yarn, pnpm)"
    echo "  • Ruby (gem, bundler)       • Rust (cargo, rustup)"
    echo "  • Go (go install)           • Haskell (cabal, stack, ghcup)"
    echo "  • Java (maven, gradle)      • PHP (composer)"
    echo "  • Scientific (Spack, Conda, Mamba)"
    echo
    echo -e "${GREEN}Universal Package Systems:${NC}"
    echo "  • Flatpak (Flathub)         • Snap (Snapcraft)"
    echo
    echo -e "${YELLOW}v1.2 Changes:${NC}"
    echo "  • Fixed Flatpak search (--columns parsing)"
    echo "  • Unified search/select engine for all PMs"
    echo "  • Fully implemented all language tool menus"
    echo "  • Added repository/PPA management"
    echo "  • Auto-detect and offer to install missing tools"
    echo "  • Added Spack, Conda, Mamba support"
    echo "  • Added Homebrew support"
    echo "  • Fixed venv path bug (~/ → \$HOME/)"
}

# ─── Menus ────────────────────────────────────────────────────────────────────
package_manager_menu() {
    while true; do
        show_header "$(get_msg "package_manager")"
        echo "1.  $(get_msg "install")"
        echo "2.  $(get_msg "remove")"
        echo "3.  $(get_msg "smart_remove")"
        echo "4.  $(get_msg "search_programs")"
        echo "5.  $(get_msg "search_packages")"
        echo "6.  $(get_msg "update")"
        echo "7.  $(get_msg "upgrade")"
        echo "8.  $(get_msg "list")"
        echo "9.  $(get_msg "info")"
        echo "10. $(get_msg "fix")"
        echo "11. $(get_msg "clean")"
        echo "12. $(get_msg "add_repo")"
        echo "0.  $(get_msg "back")"
        echo
        read -p "$(get_msg "enter_choice") " choice

        case $choice in
            1)  install_package; pause ;;
            2)  read -p "$(get_msg "enter_package") " pkg; remove_package "$pkg"; pause ;;
            3)  smart_remove_system ;;
            4)  read -p "$(get_msg "enter_package") " pkg; search_programs "$pkg"; pause ;;
            5)  read -p "$(get_msg "enter_package") " pkg; search_package "$pkg"; pause ;;
            6|7) update_packages; pause ;;
            8)  list_packages; pause ;;
            9)  read -p "$(get_msg "enter_package") " pkg; package_info "$pkg"; pause ;;
            10) fix_packages; pause ;;
            11) clean_cache; pause ;;
            12) add_repository; pause ;;
            0)  break ;;
            *)  echo -e "${RED}$(get_msg "invalid_option")${NC}"; pause ;;
        esac
    done
}

flatpak_menu() {
    check_flatpak
    while true; do
        show_header "$(get_msg "flatpak_manager")"
        echo "1. $(get_msg "install_flatpak")"
        echo "2. $(get_msg "remove_flatpak")"
        echo "3. $(get_msg "smart_remove_flatpak")"
        echo "4. $(get_msg "search_flatpak")"
        echo "5. $(get_msg "update_flatpak")"
        echo "6. $(get_msg "list_flatpak")"
        echo "7. $(get_msg "add_flatpak_repo")"
        echo "8. $(get_msg "refresh_flathub")"
        echo "0. $(get_msg "back")"
        echo
        read -p "$(get_msg "enter_choice") " choice

        case $choice in
            1)  install_flatpak_package; pause ;;
            2)
                read -p "$(get_msg "enter_package") " pkg
                [[ -n "$pkg" ]] && flatpak uninstall -y "$pkg"
                pause ;;
            3)  smart_remove_flatpak ;;
            4)
                read -p "$(get_msg "enter_package") " pkg
                [[ -n "$pkg" ]] && search_flatpak "$pkg"
                pause ;;
            5)  flatpak update -y; pause ;;
            6)  flatpak list; pause ;;
            7)
                read -p "$(get_msg "enter_repo") (e.g. https://flathub.org/repo/flathub.flatpakrepo): " repo
                read -p "Remote name: " rname
                [[ -n "$repo" ]] && flatpak remote-add --if-not-exists "${rname:-custom}" "$repo"
                pause ;;
            8)  add_flathub_repository; pause ;;
            0)  break ;;
            *)  echo -e "${RED}$(get_msg "invalid_option")${NC}"; pause ;;
        esac
    done
}

snap_menu() {
    check_snap
    while true; do
        show_header "$(get_msg "snap_manager")"
        echo "1. $(get_msg "install_snap")"
        echo "2. $(get_msg "remove_snap")"
        echo "3. $(get_msg "smart_remove_snap")"
        echo "4. $(get_msg "search_snap")"
        echo "5. $(get_msg "update_snap")"
        echo "6. $(get_msg "list_snap")"
        echo "7. $(get_msg "enable_snap")"
        echo "0. $(get_msg "back")"
        echo
        read -p "$(get_msg "enter_choice") " choice

        case $choice in
            1)  install_snap_package; pause ;;
            2)
                read -p "$(get_msg "enter_package") " pkg
                [[ -n "$pkg" ]] && sudo snap remove "$pkg"
                pause ;;
            3)  smart_remove_snap ;;
            4)
                read -p "$(get_msg "enter_package") " pkg
                [[ -n "$pkg" ]] && search_snap "$pkg"
                pause ;;
            5)  sudo snap refresh; pause ;;
            6)  snap list; pause ;;
            7)
                sudo systemctl enable --now snapd.socket 2>/dev/null || \
                    sudo service snapd start 2>/dev/null || \
                    echo -e "${YELLOW}Could not enable snapd. Try: sudo systemctl start snapd${NC}"
                pause ;;
            0)  break ;;
            *)  echo -e "${RED}$(get_msg "invalid_option")${NC}"; pause ;;
        esac
    done
}

other_installers_menu() {
    while true; do
        show_header "$(get_msg "other_installers")"
        echo "1. $(get_msg "python_tools")"
        echo "2. $(get_msg "nodejs_tools")"
        echo "3. $(get_msg "ruby_tools")"
        echo "4. $(get_msg "rust_tools")"
        echo "5. $(get_msg "go_tools")"
        echo "6. $(get_msg "java_tools")"
        echo "7. $(get_msg "php_tools")"
        echo "8. $(get_msg "haskell_tools")"
        echo "9. $(get_msg "scientific_tools")"
        echo "0. $(get_msg "back")"
        echo
        read -p "$(get_msg "enter_choice") " choice

        case $choice in
            1)  python_tools_menu ;;
            2)  nodejs_tools_menu ;;
            3)  ruby_tools_menu ;;
            4)  rust_tools_menu ;;
            5)  go_tools_menu ;;
            6)  java_tools_menu ;;
            7)  php_tools_menu ;;
            8)  haskell_tools_menu ;;
            9)  scientific_tools_menu ;;
            0)  break ;;
            *)  echo -e "${RED}$(get_msg "invalid_option")${NC}"; pause ;;
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
            1)  backup_packages; pause ;;
            2)  restore_packages; pause ;;
            3)  show_system_info; pause ;;
            4)  show_disk_usage; pause ;;
            0)  break ;;
            *)  echo -e "${RED}$(get_msg "invalid_option")${NC}"; pause ;;
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
            1)  change_language; pause ;;
            2)  show_about; pause ;;
            0)  break ;;
            *)  echo -e "${RED}$(get_msg "invalid_option")${NC}"; pause ;;
        esac
    done
}

main_menu() {
    while true; do
        show_header "$(get_msg "main_menu")"
        echo "1. $(get_msg "package_manager")"
        echo "2. $(get_msg "flatpak_manager")"
        echo "3. $(get_msg "snap_manager")"
        echo "4. $(get_msg "other_installers")"
        echo "5. $(get_msg "system_tools")"
        echo "6. $(get_msg "settings")"
        echo "0. $(get_msg "exit")"
        echo
        read -p "$(get_msg "enter_choice") " choice

        case $choice in
            1)  package_manager_menu ;;
            2)  flatpak_menu ;;
            3)  snap_menu ;;
            4)  other_installers_menu ;;
            5)  system_tools_menu ;;
            6)  settings_menu ;;
            0)
                clear
                echo -e "${GREEN}$(get_msg "exiting")${NC}"
                exit 0 ;;
            *)  echo -e "${RED}$(get_msg "invalid_option")${NC}"; pause ;;
        esac
    done
}

# ─── Entry point ──────────────────────────────────────────────────────────────
main() {
    # Ensure UTF-8 for proper emoji/Arabic display
    [[ "$LANG" != *"UTF-8"* ]] && export LANG="en_US.UTF-8"
    main_menu
}

main "$@"
