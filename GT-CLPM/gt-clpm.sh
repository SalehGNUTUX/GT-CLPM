#!/bin/bash

# GT-CLPM - GNUTUX Command Line Package Manager
# Version: 1.1
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

# Detect system language and set default
if [[ -f "$LANG_FILE" ]]; then
    CURRENT_LANG=$(cat "$LANG_FILE")
else
    # Auto-detect system language
    if [[ $LANG == *"ar"* ]] || [[ $LANGUAGE == *"ar"* ]] || [[ $LC_ALL == *"ar"* ]] || [[ $LC_CTYPE == *"ar"* ]]; then
        CURRENT_LANG="ar"
    else
        CURRENT_LANG="en"
    fi
    echo "$CURRENT_LANG" > "$LANG_FILE"
fi

# Language arrays
declare -A MESSAGES_EN=(
    ["title"]="GT-CLPM - GNUTUX Command Line Package Manager"
    ["version"]="Version 1.1 - GPLv2 License - Developed by GNUTUX"
    ["main_menu"]="Main Menu"
    ["package_manager"]="Package Manager Operations"
    ["flatpak_manager"]="Flatpak Manager"
    ["snap_manager"]="Snap Manager"
    ["other_installers"]="Other Installation Methods"
    ["system_tools"]="System Tools"
    ["settings"]="Settings"
    ["exit"]="Exit"
    ["install"]="Install package"
    ["remove"]="Remove package"
    ["smart_remove"]="Smart Remove"
    ["search"]="Search for package"
    ["update"]="Update system packages"
    ["upgrade"]="Upgrade system packages"
    ["list"]="List installed packages"
    ["info"]="Package information"
    ["fix"]="Fix broken packages"
    ["clean"]="Clean package cache"
    ["autoremove"]="Remove orphaned packages"
    ["install_flatpak"]="Install Flatpak package"
    ["remove_flatpak"]="Remove Flatpak package"
    ["smart_remove_flatpak"]="Smart Remove Flatpak"
    ["search_flatpak"]="Search Flatpak packages"
    ["update_flatpak"]="Update Flatpak packages"
    ["list_flatpak"]="List Flatpak packages"
    ["add_flatpak_repo"]="Add Flatpak repository"
    ["install_snap"]="Install Snap package"
    ["remove_snap"]="Remove Snap package"
    ["smart_remove_snap"]="Smart Remove Snap"
    ["search_snap"]="Search Snap packages"
    ["update_snap"]="Update Snap packages"
    ["list_snap"]="List Snap packages"
    ["enable_snap"]="Enable Snap service"
    ["python_tools"]="Python (pip)"
    ["nodejs_tools"]="Node.js (npm/yarn/pnpm)"
    ["ruby_tools"]="Ruby (gem)"
    ["rust_tools"]="Rust (cargo)"
    ["go_tools"]="Go (go install)"
    ["haskell_tools"]="Haskell (cabal/stack)"
    ["java_tools"]="Java (maven/gradle)"
    ["php_tools"]="PHP (composer)"
    ["scientific_tools"]="Scientific Tools (Spack)"
    ["backup_packages"]="Backup package list"
    ["restore_packages"]="Restore packages from backup"
    ["system_info"]="Show system information"
    ["disk_usage"]="Show disk usage"
    ["change_lang"]="Change language"
    ["about"]="About GT-CLPM"
    ["back"]="Back to main menu"
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
    ["error"]="Error:"
    ["success"]="Success:"
    ["warning"]="Warning:"
    ["info_msg"]="Info:"
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
    ["browse_packages"]="Browse installed packages"
    ["manual_entry"]="Manual entry"
    ["select_package"]="Select package to remove:"
    ["confirm_remove"]="Are you sure you want to remove"
    ["removal_cancelled"]="Removal cancelled"
    ["package_removed"]="Package removed successfully"
    ["install_from_search"]="Install from search results"
    ["search_results"]="Search Results"
    ["enter_number"]="Enter package number to install"
    ["install_package_num"]="Install package number"
    ["return_to_menu"]="Return to menu"
)

declare -A MESSAGES_AR=(
    ["title"]="GT-CLPM - مدير حزم سطر الأوامر من جنوتكس"
    ["version"]="الإصدار 1.1 - رخصة GPLv2 - من تطوير GNUTUX"
    ["main_menu"]="القائمة الرئيسية"
    ["package_manager"]="عمليات مدير الحزم"
    ["flatpak_manager"]="مدير فلاتباك"
    ["snap_manager"]="مدير سناب"
    ["other_installers"]="طرق تثبيت أخرى"
    ["system_tools"]="أدوات النظام"
    ["settings"]="الإعدادات"
    ["exit"]="خروج"
    ["install"]="تثبيت حزمة"
    ["remove"]="إزالة حزمة"
    ["smart_remove"]="إزالة ذكية"
    ["search"]="البحث عن حزمة"
    ["update"]="تحديث حزم النظام"
    ["upgrade"]="ترقية حزم النظام"
    ["list"]="عرض الحزم المثبتة"
    ["info"]="معلومات الحزمة"
    ["fix"]="إصلاح الحزم المعطلة"
    ["clean"]="تنظيف ذاكرة التخزين المؤقت"
    ["autoremove"]="إزالة الحزم اليتيمة"
    ["install_flatpak"]="تثبيت حزمة فلاتباك"
    ["remove_flatpak"]="إزالة حزمة فلاتباك"
    ["smart_remove_flatpak"]="إزالة ذكية لفلاتباك"
    ["search_flatpak"]="البحث في حزم فلاتباك"
    ["update_flatpak"]="تحديث حزم فلاتباك"
    ["list_flatpak"]="عرض حزم فلاتباك"
    ["add_flatpak_repo"]="إضافة مستودع فلاتباك"
    ["install_snap"]="تثبيت حزمة سناب"
    ["remove_snap"]="إزالة حزمة سناب"
    ["smart_remove_snap"]="إزالة ذكية لسناب"
    ["search_snap"]="البحث في حزم سناب"
    ["update_snap"]="تحديث حزم سناب"
    ["list_snap"]="عرض حزم سناب"
    ["enable_snap"]="تفعيل خدمة سناب"
    ["python_tools"]="بايثون (pip)"
    ["nodejs_tools"]="نود.js (npm/yarn/pnpm)"
    ["ruby_tools"]="روبي (gem)"
    ["rust_tools"]="رست (cargo)"
    ["go_tools"]="جو (go install)"
    ["haskell_tools"]="هاسكل (cabal/stack)"
    ["java_tools"]="جافا (maven/gradle)"
    ["php_tools"]="بي إتش بي (composer)"
    ["scientific_tools"]="أدوات علمية (Spack)"
    ["backup_packages"]="نسخ احتياطي لقائمة الحزم"
    ["restore_packages"]="استعادة الحزم من النسخ الاحتياطي"
    ["system_info"]="عرض معلومات النظام"
    ["disk_usage"]="عرض استخدام القرص"
    ["change_lang"]="تغيير اللغة"
    ["about"]="حول GT-CLPM"
    ["back"]="العودة للقائمة الرئيسية"
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
    ["error"]="خطأ:"
    ["success"]="نجح:"
    ["warning"]="تحذير:"
    ["info_msg"]="معلومة:"
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
    ["browse_packages"]="تصفح الحزم المثبتة"
    ["manual_entry"]="إدخال يدوي"
    ["select_package"]="اختر الحزمة المراد إزالتها:"
    ["confirm_remove"]="هل أنت متأكد أنك تريد إزالة"
    ["removal_cancelled"]="تم إلغاء الإزالة"
    ["package_removed"]="تم إزالة الحزمة بنجاح"
    ["install_from_search"]="التثبيت من نتائج البحث"
    ["search_results"]="نتائج البحث"
    ["enter_number"]="أدخل رقم الحزمة للتثبيت"
    ["install_package_num"]="تثبيت الحزمة رقم"
    ["return_to_menu"]="العودة للقائمة"
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

# Function to add Flathub repository
add_flathub_repository() {
    if ! flatpak remote-list | grep -q "flathub"; then
        echo -e "${YELLOW}Adding Flathub repository...${NC}"
        flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
        echo -e "${GREEN}Flathub repository added successfully${NC}"
    else
        echo -e "${GREEN}Flathub repository already exists${NC}"
    fi
}

# Function to check if flatpak is installed
check_flatpak() {
    if ! command -v flatpak &> /dev/null; then
        echo -e "${YELLOW}$(get_msg "flatpak_not_installed")${NC}"
        install_flatpak_system
        # Add Flathub repository after installation
        add_flathub_repository
    else
        # Ensure Flathub repository exists even if Flatpak was pre-installed
        add_flathub_repository
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

# Enhanced search function with interactive installation
search_package() {
    local package="$1"
    local pm=$(detect_package_manager)

    if [[ -z "$package" ]]; then
        echo -e "${RED}$(get_msg "error") $(get_msg "no_package")${NC}"
        return 1
    fi

    echo -e "${CYAN}$(get_msg "searching") $package...${NC}"

    # Create temporary file for search results
    local temp_file=$(mktemp)

    case $pm in
        "apt")
            apt search "$package" 2>/dev/null | head -30 > "$temp_file"
            ;;
        "dnf")
            dnf search "$package" 2>/dev/null | head -30 > "$temp_file"
            ;;
        "yum")
            yum search "$package" 2>/dev/null | head -30 > "$temp_file"
            ;;
        "pacman")
            pacman -Ss "$package" 2>/dev/null | head -30 > "$temp_file"
            ;;
        "zypper")
            zypper search "$package" 2>/dev/null | head -30 > "$temp_file"
            ;;
        "eopkg")
            eopkg search "$package" 2>/dev/null | head -30 > "$temp_file"
            ;;
        "xbps")
            xbps-query -Rs "$package" 2>/dev/null | head -30 > "$temp_file"
            ;;
        "emerge")
            emerge --search "$package" 2>/dev/null | head -30 > "$temp_file"
            ;;
        "pkg")
            pkg search "$package" 2>/dev/null | head -30 > "$temp_file"
            ;;
        "apk")
            apk search "$package" 2>/dev/null | head -30 > "$temp_file"
            ;;
        "nix")
            nix-env -qa "$package" 2>/dev/null | head -30 > "$temp_file"
            ;;
        *)
            echo -e "${RED}$(get_msg "error") $(get_msg "not_found")${NC}"
            return 1
            ;;
    esac

    # Check if search returned results
    if [[ ! -s "$temp_file" ]]; then
        echo -e "${YELLOW}No packages found for: $package${NC}"
        rm -f "$temp_file"
        return 1
    fi

    # Display search results with numbers
    echo -e "${GREEN}$(get_msg "search_results"):${NC}"
    echo "===================="

    # Extract package names and store in array
    local packages=()
    local i=1

    case $pm in
        "apt")
            while IFS= read -r line; do
                if [[ $line =~ ^([^/]+)/ ]]; then
                    pkg_name="${BASH_REMATCH[1]}"
                    echo "$i. $line"
                    packages[i]="$pkg_name"
                    ((i++))
                fi
            done < "$temp_file"
            ;;
        "dnf"|"yum")
            while IFS= read -r line; do
                if [[ $line =~ ^([^.]+)\. ]]; then
                    pkg_name="${BASH_REMATCH[1]}"
                    echo "$i. $line"
                    packages[i]="$pkg_name"
                    ((i++))
                fi
            done < "$temp_file"
            ;;
        "pacman")
            while IFS= read -r line; do
                if [[ $line =~ ^([^/]+)/ ]]; then
                    pkg_name="${BASH_REMATCH[1]}"
                    echo "$i. $line"
                    packages[i]="$pkg_name"
                    ((i++))
                fi
            done < "$temp_file"
            ;;
        *)
            # Generic fallback - show first 20 lines with numbers
            i=1
            while IFS= read -r line && [[ $i -le 20 ]]; do
                echo "$i. $line"
                packages[i]="$line"
                ((i++))
            done < "$temp_file"
            ;;
    esac

    echo "0. $(get_msg "return_to_menu")"
    echo

    # Ask user if they want to install from results
    read -p "$(get_msg "enter_number") (0 to $(($i-1))): " package_choice

    if [[ $package_choice -eq 0 ]]; then
        rm -f "$temp_file"
        return
    fi

    # Install selected package
    if [[ -n "${packages[$package_choice]}" ]]; then
        selected_package="${packages[$package_choice]}"
        echo -e "${YELLOW}$(get_msg "install_package_num") $package_choice: $selected_package? (y/N)${NC}"
        read -p "" confirm
        if [[ $confirm =~ ^[Yy]$ ]]; then
            install_package "$selected_package"
        else
            echo -e "${YELLOW}Installation cancelled${NC}"
        fi
    else
        echo -e "${RED}$(get_msg "invalid_option")${NC}"
    fi

    rm -f "$temp_file"
}

# Enhanced Flatpak search function with interactive installation
search_flatpak() {
    local package="$1"

    if [[ -z "$package" ]]; then
        echo -e "${RED}$(get_msg "error") $(get_msg "no_package")${NC}"
        return 1
    fi

    echo -e "${CYAN}$(get_msg "searching") $package...${NC}"

    # Create temporary file for search results
    local temp_file=$(mktemp)
    flatpak search "$package" 2>/dev/null | head -30 > "$temp_file"

    # Check if search returned results
    if [[ ! -s "$temp_file" ]]; then
        echo -e "${YELLOW}No Flatpak packages found for: $package${NC}"
        rm -f "$temp_file"
        return 1
    fi

    # Display search results with numbers
    echo -e "${GREEN}$(get_msg "search_results"):${NC}"
    echo "===================="

    # Extract package names and store in array
    local packages=()
    local i=1

    while IFS= read -r line; do
        if [[ $line =~ ^([^/]+)/ ]]; then
            pkg_name="${BASH_REMATCH[1]}"
            echo "$i. $line"
            packages[i]="$pkg_name"
            ((i++))
        fi
    done < "$temp_file"

    echo "0. $(get_msg "return_to_menu")"
    echo

    # Ask user if they want to install from results
    read -p "$(get_msg "enter_number") (0 to $(($i-1))): " package_choice

    if [[ $package_choice -eq 0 ]]; then
        rm -f "$temp_file"
        return
    fi

    # Install selected package
    if [[ -n "${packages[$package_choice]}" ]]; then
        selected_package="${packages[$package_choice]}"
        echo -e "${YELLOW}$(get_msg "install_package_num") $package_choice: $selected_package? (y/N)${NC}"
        read -p "" confirm
        if [[ $confirm =~ ^[Yy]$ ]]; then
            flatpak install -y flathub "$selected_package"
        else
            echo -e "${YELLOW}Installation cancelled${NC}"
        fi
    else
        echo -e "${RED}$(get_msg "invalid_option")${NC}"
    fi

    rm -f "$temp_file"
}

# Enhanced Snap search function with interactive installation
search_snap() {
    local package="$1"

    if [[ -z "$package" ]]; then
        echo -e "${RED}$(get_msg "error") $(get_msg "no_package")${NC}"
        return 1
    fi

    echo -e "${CYAN}$(get_msg "searching") $package...${NC}"

    # Create temporary file for search results
    local temp_file=$(mktemp)
    snap find "$package" 2>/dev/null | head -30 > "$temp_file"

    # Check if search returned results
    if [[ ! -s "$temp_file" ]]; then
        echo -e "${YELLOW}No Snap packages found for: $package${NC}"
        rm -f "$temp_file"
        return 1
    fi

    # Display search results with numbers
    echo -e "${GREEN}$(get_msg "search_results"):${NC}"
    echo "===================="

    # Extract package names and store in array
    local packages=()
    local i=1

    # Skip header line and process results
    while IFS= read -r line; do
        if [[ $i -eq 1 ]]; then
            # Skip header
            ((i++))
            continue
        fi
        if [[ $line =~ ^([^[:space:]]+) ]]; then
            pkg_name="${BASH_REMATCH[1]}"
            echo "$i. $line"
            packages[i]="$pkg_name"
            ((i++))
        fi
    done < "$temp_file"

    echo "0. $(get_msg "return_to_menu")"
    echo

    # Ask user if they want to install from results
    read -p "$(get_msg "enter_number") (0 to $(($i-1))): " package_choice

    if [[ $package_choice -eq 0 ]]; then
        rm -f "$temp_file"
        return
    fi

    # Install selected package
    if [[ -n "${packages[$package_choice]}" ]]; then
        selected_package="${packages[$package_choice]}"
        echo -e "${YELLOW}$(get_msg "install_package_num") $package_choice: $selected_package? (y/N)${NC}"
        read -p "" confirm
        if [[ $confirm =~ ^[Yy]$ ]]; then
            sudo snap install "$selected_package"
        else
            echo -e "${YELLOW}Installation cancelled${NC}"
        fi
    else
        echo -e "${RED}$(get_msg "invalid_option")${NC}"
    fi

    rm -f "$temp_file"
}

# Smart removal functions
smart_remove_system() {
    local pm=$(detect_package_manager)

    echo -e "${CYAN}$(get_msg "browse_packages")${NC}"
    echo "1. $(get_msg "manual_entry")"
    echo "2. $(get_msg "list")"
    echo "0. $(get_msg "back")"
    echo

    read -p "$(get_msg "enter_choice") " choice

    case $choice in
        1)
            echo
            read -p "$(get_msg "enter_package") " package
            if [[ -n "$package" ]]; then
                echo -e "${YELLOW}$(get_msg "confirm_remove") $package? (y/N)${NC}"
                read -p "" confirm
                if [[ $confirm =~ ^[Yy]$ ]]; then
                    remove_package "$package"
                else
                    echo -e "${YELLOW}$(get_msg "removal_cancelled")${NC}"
                fi
            fi
            ;;
        2)
            echo
            echo -e "${CYAN}$(get_msg "listing")${NC}"
            case $pm in
                "apt")
                    packages=$(dpkg-query -f '${Package}\n' -W | sort)
                    ;;
                "dnf"|"yum")
                    packages=$($pm list installed | awk '{print $1}' | sort)
                    ;;
                "pacman")
                    packages=$(pacman -Q | awk '{print $1}' | sort)
                    ;;
                "zypper")
                    packages=$(zypper search -i | grep -E "^i" | awk '{print $3}' | sort)
                    ;;
                "eopkg")
                    packages=$(eopkg list-installed | awk '{print $1}' | sort)
                    ;;
                "xbps")
                    packages=$(xbps-query -l | awk '{print $2}' | cut -d- -f1 | sort)
                    ;;
                "emerge")
                    packages=$(qlist -I | sort)
                    ;;
                "pkg")
                    packages=$(pkg info | awk '{print $1}' | sort)
                    ;;
                "apk")
                    packages=$(apk info | sort)
                    ;;
                "nix")
                    packages=$(nix-env -q | sort)
                    ;;
                *)
                    echo -e "${RED}$(get_msg "error") $(get_msg "not_found")${NC}"
                    return 1
                    ;;
            esac

            if [[ -z "$packages" ]]; then
                echo -e "${YELLOW}No packages found${NC}"
                pause
                return
            fi

            # Display packages with numbers
            echo -e "${WHITE}$(get_msg "select_package")${NC}"
            echo "===================="
            i=1
            while IFS= read -r package; do
                if [[ -n "$package" ]]; then
                    echo "$i. $package"
                    ((i++))
                fi
            done <<< "$packages"
            echo "0. $(get_msg "back")"
            echo

            read -p "$(get_msg "enter_choice") " package_choice

            if [[ $package_choice -eq 0 ]]; then
                return
            fi

            # Get selected package
            selected_package=$(echo "$packages" | sed -n "${package_choice}p")

            if [[ -n "$selected_package" ]]; then
                echo -e "${YELLOW}$(get_msg "confirm_remove") $selected_package? (y/N)${NC}"
                read -p "" confirm
                if [[ $confirm =~ ^[Yy]$ ]]; then
                    remove_package "$selected_package"
                    echo -e "${GREEN}$(get_msg "package_removed")${NC}"
                else
                    echo -e "${YELLOW}$(get_msg "removal_cancelled")${NC}"
                fi
            else
                echo -e "${RED}$(get_msg "invalid_option")${NC}"
            fi
            ;;
        0)
            return
            ;;
        *)
            echo -e "${RED}$(get_msg "invalid_option")${NC}"
            ;;
    esac
    pause
}

smart_remove_flatpak() {
    echo -e "${CYAN}$(get_msg "browse_packages")${NC}"
    echo "1. $(get_msg "manual_entry")"
    echo "2. $(get_msg "list_flatpak")"
    echo "0. $(get_msg "back")"
    echo

    read -p "$(get_msg "enter_choice") " choice

    case $choice in
        1)
            echo
            read -p "$(get_msg "enter_package") " package
            if [[ -n "$package" ]]; then
                echo -e "${YELLOW}$(get_msg "confirm_remove") $package? (y/N)${NC}"
                read -p "" confirm
                if [[ $confirm =~ ^[Yy]$ ]]; then
                    flatpak uninstall -y "$package"
                    echo -e "${GREEN}$(get_msg "package_removed")${NC}"
                else
                    echo -e "${YELLOW}$(get_msg "removal_cancelled")${NC}"
                fi
            fi
            ;;
        2)
            echo
            echo -e "${CYAN}$(get_msg "listing")${NC}"
            packages=$(flatpak list --app --columns=application | sort)

            if [[ -z "$packages" ]]; then
                echo -e "${YELLOW}No Flatpak packages found${NC}"
                pause
                return
            fi

            echo -e "${WHITE}$(get_msg "select_package")${NC}"
            echo "===================="
            i=1
            while IFS= read -r package; do
                if [[ -n "$package" ]]; then
                    echo "$i. $package"
                    ((i++))
                fi
            done <<< "$packages"
            echo "0. $(get_msg "back")"
            echo

            read -p "$(get_msg "enter_choice") " package_choice

            if [[ $package_choice -eq 0 ]]; then
                return
            fi

            selected_package=$(echo "$packages" | sed -n "${package_choice}p")

            if [[ -n "$selected_package" ]]; then
                echo -e "${YELLOW}$(get_msg "confirm_remove") $selected_package? (y/N)${NC}"
                read -p "" confirm
                if [[ $confirm =~ ^[Yy]$ ]]; then
                    flatpak uninstall -y "$selected_package"
                    echo -e "${GREEN}$(get_msg "package_removed")${NC}"
                else
                    echo -e "${YELLOW}$(get_msg "removal_cancelled")${NC}"
                fi
            else
                echo -e "${RED}$(get_msg "invalid_option")${NC}"
            fi
            ;;
        0)
            return
            ;;
        *)
            echo -e "${RED}$(get_msg "invalid_option")${NC}"
            ;;
    esac
    pause
}

smart_remove_snap() {
    echo -e "${CYAN}$(get_msg "browse_packages")${NC}"
    echo "1. $(get_msg "manual_entry")"
    echo "2. $(get_msg "list_snap")"
    echo "0. $(get_msg "back")"
    echo

    read -p "$(get_msg "enter_choice") " choice

    case $choice in
        1)
            echo
            read -p "$(get_msg "enter_package") " package
            if [[ -n "$package" ]]; then
                echo -e "${YELLOW}$(get_msg "confirm_remove") $package? (y/N)${NC}"
                read -p "" confirm
                if [[ $confirm =~ ^[Yy]$ ]]; then
                    sudo snap remove "$package"
                    echo -e "${GREEN}$(get_msg "package_removed")${NC}"
                else
                    echo -e "${YELLOW}$(get_msg "removal_cancelled")${NC}"
                fi
            fi
            ;;
        2)
            echo
            echo -e "${CYAN}$(get_msg "listing")${NC}"
            packages=$(snap list | awk 'NR>1 {print $1}' | sort)

            if [[ -z "$packages" ]]; then
                echo -e "${YELLOW}No Snap packages found${NC}"
                pause
                return
            fi

            echo -e "${WHITE}$(get_msg "select_package")${NC}"
            echo "===================="
            i=1
            while IFS= read -r package; do
                if [[ -n "$package" ]]; then
                    echo "$i. $package"
                    ((i++))
                fi
            done <<< "$packages"
            echo "0. $(get_msg "back")"
            echo

            read -p "$(get_msg "enter_choice") " package_choice

            if [[ $package_choice -eq 0 ]]; then
                return
            fi

            selected_package=$(echo "$packages" | sed -n "${package_choice}p")

            if [[ -n "$selected_package" ]]; then
                echo -e "${YELLOW}$(get_msg "confirm_remove") $selected_package? (y/N)${NC}"
                read -p "" confirm
                if [[ $confirm =~ ^[Yy]$ ]]; then
                    sudo snap remove "$selected_package"
                    echo -e "${GREEN}$(get_msg "package_removed")${NC}"
                else
                    echo -e "${YELLOW}$(get_msg "removal_cancelled")${NC}"
                fi
            else
                echo -e "${RED}$(get_msg "invalid_option")${NC}"
            fi
            ;;
        0)
            return
            ;;
        *)
            echo -e "${RED}$(get_msg "invalid_option")${NC}"
            ;;
    esac
    pause
}

# Smart removal for Python packages
smart_remove_python() {
    echo -e "${CYAN}Python Package Removal${NC}"
    echo "1. Remove pipx package"
    echo "2. Remove pip package"
    echo "3. Remove virtual environment"
    echo "0. Back"
    echo

    read -p "$(get_msg "enter_choice") " choice

    case $choice in
        1)
            if command -v pipx &> /dev/null; then
                echo
                echo -e "${CYAN}Installed pipx packages:${NC}"
                pipx list --short
                echo
                read -p "Enter package name to remove: " package
                if [[ -n "$package" ]]; then
                    echo -e "${YELLOW}Are you sure you want to remove $package? (y/N)${NC}"
                    read -p "" confirm
                    if [[ $confirm =~ ^[Yy]$ ]]; then
                        pipx uninstall "$package"
                        echo -e "${GREEN}Package removed successfully${NC}"
                    else
                        echo -e "${YELLOW}Removal cancelled${NC}"
                    fi
                fi
            else
                echo -e "${RED}pipx is not available${NC}"
            fi
            pause
            ;;
        2)
            echo
            if command -v pip3 &> /dev/null; then
                echo -e "${CYAN}Installed pip3 packages:${NC}"
                pip3 list --format=columns
            elif command -v pip &> /dev/null; then
                echo -e "${CYAN}Installed pip packages:${NC}"
                pip list --format=columns
            fi
            echo
            read -p "Enter package name to remove: " package
            if [[ -n "$package" ]]; then
                echo -e "${YELLOW}Are you sure you want to remove $package? (y/N)${NC}"
                read -p "" confirm
                if [[ $confirm =~ ^[Yy]$ ]]; then
                    if command -v pip3 &> /dev/null; then
                        pip3 uninstall "$package" --break-system-packages
                    elif command -v pip &> /dev/null; then
                        pip uninstall "$package" --break-system-packages
                    fi
                    echo -e "${GREEN}Package removed successfully${NC}"
                else
                    echo -e "${YELLOW}Removal cancelled${NC}"
                fi
            fi
            pause
            ;;
        3)
            echo
            echo -e "${CYAN}Virtual environments in ~/:${NC}"
            ls -d ~/venv_* 2>/dev/null | sed 's|.*/venv_||'
            echo
            read -p "Enter virtual environment name (without 'venv_' prefix): " venv_name
            if [[ -n "$venv_name" ]]; then
                if [[ -d "~/venv_$venv_name" ]]; then
                    echo -e "${YELLOW}Are you sure you want to remove virtual environment venv_$venv_name? (y/N)${NC}"
                    read -p "" confirm
                    if [[ $confirm =~ ^[Yy]$ ]]; then
                        rm -rf ~/venv_$venv_name
                        echo -e "${GREEN}Virtual environment removed successfully${NC}"
                    else
                        echo -e "${YELLOW}Removal cancelled${NC}"
                    fi
                else
                    echo -e "${RED}Virtual environment not found${NC}"
                fi
            fi
            pause
            ;;
        0)
            return
            ;;
        *)
            echo -e "${RED}$(get_msg "invalid_option")${NC}"
            pause
            ;;
    esac
}

# Smart removal for Node.js packages
smart_remove_nodejs() {
    echo -e "${CYAN}Node.js Package Removal${NC}"
    echo "1. Remove global package"
    echo "2. Remove local package"
    echo "0. Back"
    echo

    read -p "$(get_msg "enter_choice") " choice

    case $choice in
        1)
            echo
            echo -e "${CYAN}Installed global packages:${NC}"
            npm list -g --depth=0
            echo
            read -p "Enter package name to remove: " package
            if [[ -n "$package" ]]; then
                echo -e "${YELLOW}Are you sure you want to remove $package? (y/N)${NC}"
                read -p "" confirm
                if [[ $confirm =~ ^[Yy]$ ]]; then
                    sudo npm uninstall -g "$package"
                    echo -e "${GREEN}Package removed successfully${NC}"
                else
                    echo -e "${YELLOW}Removal cancelled${NC}"
                fi
            fi
            pause
            ;;
        2)
            echo
            echo -e "${CYAN}Installed local packages:${NC}"
            npm list --depth=0
            echo
            read -p "Enter package name to remove: " package
            if [[ -n "$package" ]]; then
                echo -e "${YELLOW}Are you sure you want to remove $package? (y/N)${NC}"
                read -p "" confirm
                if [[ $confirm =~ ^[Yy]$ ]]; then
                    npm uninstall "$package"
                    echo -e "${GREEN}Package removed successfully${NC}"
                else
                    echo -e "${YELLOW}Removal cancelled${NC}"
                fi
            fi
            pause
            ;;
        0)
            return
            ;;
        *)
            echo -e "${RED}$(get_msg "invalid_option")${NC}"
            pause
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
    echo -e "${CYAN}System Information:${NC}"
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
    echo -e "${CYAN}Disk Usage:${NC}"
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
        echo -e "${GREEN}$(get_msg "lang_changed")${NC}"
    else
        CURRENT_LANG="en"
        echo "en" > "$LANG_FILE"
        echo -e "${GREEN}$(get_msg "lang_changed")${NC}"
    fi
}

# About function
show_about() {
    echo -e "${CYAN}About GT-CLPM${NC}"
    echo "================"
    echo -e "${WHITE}GT-CLPM - GNUTUX Command Line Package Manager${NC}"
    echo -e "${YELLOW}Version:${NC} 1.1"
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

# Other installation methods functions
python_tools_menu() {
    while true; do
        show_header "$(get_msg "python_tools")"

        echo -e "${CYAN}Checking dependencies...${NC}"

        # Check for Python
        if ! command -v python3 &> /dev/null && ! command -v python &> /dev/null; then
            echo -e "${YELLOW}Python is not installed. Install it first? (y/N)${NC}"
            read -p "" confirm
            if [[ $confirm =~ ^[Yy]$ ]]; then
                install_package "python3 python3-pip python3-venv"
            else
                echo -e "${YELLOW}Python installation cancelled${NC}"
                pause
                return
            fi
        fi

        # Check for pipx (recommended for modern systems)
        if ! command -v pipx &> /dev/null; then
            echo -e "${YELLOW}pipx is not installed (recommended for Ubuntu 24.04+). Install it? (y/N)${NC}"
            read -p "" confirm
            if [[ $confirm =~ ^[Yy]$ ]]; then
                install_package "pipx"
                pipx ensurepath
            fi
        fi

        echo -e "${GREEN}Dependencies met${NC}"
        echo

        echo "1. Install with pipx (recommended)"
        echo "2. Install in virtual environment"
        echo "3. Install with --break-system-packages (not recommended)"
        echo "4. Remove Python package"
        echo "5. List installed packages"
        echo "6. Browse PyPI"
        echo "0. $(get_msg "back")"
        echo

        read -p "$(get_msg "enter_choice") " choice

        case $choice in
            1)
                if command -v pipx &> /dev/null; then
                    echo
                    read -p "Enter package name for pipx: " package
                    if [[ -n "$package" ]]; then
                        pipx install "$package"
                    fi
                else
                    echo -e "${RED}pipx is not available. Please install it first.${NC}"
                fi
                pause
                ;;
            2)
                echo
                read -p "Enter package name for virtual environment: " package
                if [[ -n "$package" ]]; then
                    echo -e "${YELLOW}Creating virtual environment...${NC}"
                    python3 -m venv ~/venv_$package
                    source ~/venv_$package/bin/activate
                    pip install "$package"
                    echo -e "${GREEN}Package installed in virtual environment. Activate with: source ~/venv_$package/bin/activate${NC}"
                    deactivate
                fi
                pause
                ;;
            3)
                echo
                read -p "Enter package name (with --break-system-packages): " package
                if [[ -n "$package" ]]; then
                    echo -e "${YELLOW}Warning: This may break your system!${NC}"
                    read -p "Are you sure? (y/N): " confirm
                    if [[ $confirm =~ ^[Yy]$ ]]; then
                        if command -v pip3 &> /dev/null; then
                            pip3 install "$package" --break-system-packages
                        elif command -v pip &> /dev/null; then
                            pip install "$package" --break-system-packages
                        fi
                    fi
                fi
                pause
                ;;
            4)
                smart_remove_python
                ;;
            5)
                echo
                echo -e "${CYAN}Installed Python packages:${NC}"
                echo "===================="
                if command -v pipx &> /dev/null; then
                    echo -e "${YELLOW}pipx packages:${NC}"
                    pipx list
                fi
                if command -v pip3 &> /dev/null; then
                    echo -e "${YELLOW}pip3 packages:${NC}"
                    pip3 list
                elif command -v pip &> /dev/null; then
                    echo -e "${YELLOW}pip packages:${NC}"
                    pip list
                fi
                pause
                ;;
            6)
                echo
                echo -e "${YELLOW}Opening PyPI in browser...${NC}"
                if command -v xdg-open &> /dev/null; then
                    xdg-open "https://pypi.org"
                elif command -v gnome-open &> /dev/null; then
                    gnome-open "https://pypi.org"
                else
                    echo -e "${BLUE}Visit: https://pypi.org${NC}"
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

nodejs_tools_menu() {
    while true; do
        show_header "$(get_msg "nodejs_tools")"

        echo -e "${CYAN}Checking dependencies...${NC}"

        if ! command -v node &> /dev/null; then
            echo -e "${YELLOW}Node.js is not installed. Install it first? (y/N)${NC}"
            read -p "" confirm
            if [[ $confirm =~ ^[Yy]$ ]]; then
                install_package "nodejs npm"
            else
                echo -e "${YELLOW}Node.js installation cancelled${NC}"
                pause
                return
            fi
        fi

        echo -e "${GREEN}Dependencies met${NC}"
        echo

        echo "1. Install package globally"
        echo "2. Install package locally"
        echo "3. Run package with npx"
        echo "4. Remove Node.js package"
        echo "5. List installed packages"
        echo "6. Use yarn (if available)"
        echo "7. Use pnpm (if available)"
        echo "8. Browse npm registry"
        echo "0. $(get_msg "back")"
        echo

        read -p "$(get_msg "enter_choice") " choice

        case $choice in
            1)
                echo
                read -p "Enter package name for global installation: " package
                if [[ -n "$package" ]]; then
                    sudo npm install -g "$package"
                fi
                pause
                ;;
            2)
                echo
                read -p "Enter package name for local installation: " package
                if [[ -n "$package" ]]; then
                    npm install "$package"
                fi
                pause
                ;;
            3)
                echo
                read -p "Enter package name to run with npx: " package
                if [[ -n "$package" ]]; then
                    npx "$package"
                fi
                pause
                ;;
            4)
                smart_remove_nodejs
                ;;
            5)
                echo
                echo -e "${CYAN}Installed Node.js packages:${NC}"
                echo "===================="
                echo -e "${YELLOW}Global packages:${NC}"
                npm list -g --depth=0
                echo -e "${YELLOW}Local packages (current directory):${NC}"
                npm list --depth=0
                pause
                ;;
            6)
                if command -v yarn &> /dev/null; then
                    echo
                    read -p "Enter yarn command: " command
                    if [[ -n "$command" ]]; then
                        yarn add "$command"
                    fi
                else
                    echo -e "${YELLOW}Yarn is not installed. Install with: npm install -g yarn${NC}"
                fi
                pause
                ;;
            7)
                if command -v pnpm &> /dev/null; then
                    echo
                    read -p "Enter pnpm command: " command
                    if [[ -n "$command" ]]; then
                        pnpm add "$command"
                    fi
                else
                    echo -e "${YELLOW}pnpm is not installed. Install with: npm install -g pnpm${NC}"
                fi
                pause
                ;;
            8)
                echo
                echo -e "${YELLOW}Opening npm registry in browser...${NC}"
                if command -v xdg-open &> /dev/null; then
                    xdg-open "https://www.npmjs.com"
                elif command -v gnome-open &> /dev/null; then
                    gnome-open "https://www.npmjs.com"
                else
                    echo -e "${BLUE}Visit: https://www.npmjs.com${NC}"
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

# Other installation methods menu
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
            1)
                python_tools_menu
                ;;
            2)
                nodejs_tools_menu
                ;;
            3)
                echo -e "${YELLOW}Ruby tools menu - Coming soon${NC}"
                pause
                ;;
            4)
                echo -e "${YELLOW}Rust tools menu - Coming soon${NC}"
                pause
                ;;
            5)
                echo -e "${YELLOW}Go tools menu - Coming soon${NC}"
                pause
                ;;
            6)
                echo -e "${YELLOW}Java tools menu - Coming soon${NC}"
                pause
                ;;
            7)
                echo -e "${YELLOW}PHP tools menu - Coming soon${NC}"
                pause
                ;;
            8)
                echo -e "${YELLOW}Haskell tools menu - Coming soon${NC}"
                pause
                ;;
            9)
                echo -e "${YELLOW}Scientific tools menu - Coming soon${NC}"
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

# Menu functions
package_manager_menu() {
    while true; do
        show_header "$(get_msg "package_manager")"

        echo "1. $(get_msg "install")"
        echo "2. $(get_msg "remove")"
        echo "3. $(get_msg "smart_remove")"
        echo "4. $(get_msg "search")"
        echo "5. $(get_msg "update")"
        echo "6. $(get_msg "upgrade")"
        echo "7. $(get_msg "list")"
        echo "8. $(get_msg "info")"
        echo "9. $(get_msg "fix")"
        echo "10. $(get_msg "clean")"
        echo "11. $(get_msg "autoremove")"
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
                smart_remove_system
                ;;
            4)
                echo
                read -p "$(get_msg "enter_package") " package
                search_package "$package"
                pause
                ;;
            5|6)
                echo
                update_packages
                pause
                ;;
            7)
                echo
                list_packages
                pause
                ;;
            8)
                echo
                read -p "$(get_msg "enter_package") " package
                package_info "$package"
                pause
                ;;
            9)
                echo
                fix_packages
                pause
                ;;
            10|11)
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
        echo "3. $(get_msg "smart_remove_flatpak")"
        echo "4. $(get_msg "search_flatpak")"
        echo "5. $(get_msg "update_flatpak")"
        echo "6. $(get_msg "list_flatpak")"
        echo "7. $(get_msg "add_flatpak_repo")"
        echo "8. Refresh Flathub Repository"
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
                smart_remove_flatpak
                ;;
            4)
                echo
                read -p "$(get_msg "enter_package") " package
                if [[ -n "$package" ]]; then
                    search_flatpak "$package"
                fi
                pause
                ;;
            5)
                echo
                flatpak update -y
                pause
                ;;
            6)
                echo
                flatpak list
                pause
                ;;
            7)
                echo
                read -p "$(get_msg "enter_repo") " repo
                if [[ -n "$repo" ]]; then
                    flatpak remote-add --if-not-exists custom "$repo"
                fi
                pause
                ;;
            8)
                echo
                add_flathub_repository
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
        echo "3. $(get_msg "smart_remove_snap")"
        echo "4. $(get_msg "search_snap")"
        echo "5. $(get_msg "update_snap")"
        echo "6. $(get_msg "list_snap")"
        echo "7. $(get_msg "enable_snap")"
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
                smart_remove_snap
                ;;
            4)
                echo
                read -p "$(get_msg "enter_package") " package
                if [[ -n "$package" ]]; then
                    search_snap "$package"
                fi
                pause
                ;;
            5)
                echo
                sudo snap refresh
                pause
                ;;
            6)
                echo
                snap list
                pause
                ;;
            7)
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
        echo "4. $(get_msg "other_installers")"
        echo "5. $(get_msg "system_tools")"
        echo "6. $(get_msg "settings")"
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
                other_installers_menu
                ;;
            5)
                system_tools_menu
                ;;
            6)
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
