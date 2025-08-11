#!/bin/bash

# GT-CLPM - GNUTUX Command Line Package Manager (YAD GUI, Terminal Embedded, Stable Menus)
# Version: 1.2
# License: GPLv2
# Developer: GNUTUX

# ====== فحص وتثبيت yad ======
if ! command -v yad &> /dev/null; then
    zen_txt="yad is required for graphical interface. Installing..."
    if command -v apt &> /dev/null; then
        x-terminal-emulator -e "sudo apt update && sudo apt install -y yad"
    elif command -v dnf &> /dev/null; then
        x-terminal-emulator -e "sudo dnf install -y yad"
    elif command -v pacman &> /dev/null; then
        x-terminal-emulator -e "sudo pacman -S --noconfirm yad"
    elif command -v zypper &> /dev/null; then
        x-terminal-emulator -e "sudo zypper install -y yad"
    elif command -v eopkg &> /dev/null; then
        x-terminal-emulator -e "sudo eopkg install yad"
    else
        echo "$zen_txt"
        exit 1
    fi
    sleep 5
fi

# ====== فحص صلاحيات root وإعادة التشغيل التلقائي ======
if [[ "$EUID" -ne 0 ]]; then
    yad --center --width=400 --height=150 --title="GT-CLPM" \
        --text="يجب تشغيل البرنامج بصلاحيات المدير (root).\nهل ترغب في تشغيله الآن؟" \
        --button="نعم":0 --button="لا":1
    if [[ $? -eq 0 ]]; then
        exec pkexec env DISPLAY=$DISPLAY XAUTHORITY=$XAUTHORITY bash "$(readlink -f "$0")" "$@"
    else
        yad --center --width=400 --height=100 --title="GT-CLPM" --text="البرنامج يحتاج لصلاحيات المدير (root) لتنفيذ العمليات." --button="موافق":0
        exit 1
    fi
fi

# ====== إعدادات اللغة ======
LANG_FILE="$HOME/.gt-clpm-lang"
if [[ -f "$LANG_FILE" ]]; then
    CURRENT_LANG=$(cat "$LANG_FILE")
else
    CURRENT_LANG="ar"
fi

# ====== إعدادات الوضع الداكن ======
MODE_FILE="$HOME/.gt-clpm-mode"
detect_system_dark() {
    GTK_SETTINGS="$HOME/.config/gtk-3.0/settings.ini"
    GTK4_SETTINGS="$HOME/.config/gtk-4.0/settings.ini"
    if grep -q "gtk-application-prefer-dark-theme=1" "$GTK_SETTINGS" 2>/dev/null ||
       grep -q "gtk-application-prefer-dark-theme=1" "$GTK4_SETTINGS" 2>/dev/null ||
       grep -q "color-scheme=prefer-dark" "$GTK_SETTINGS" 2>/dev/null ||
       grep -q "color-scheme=prefer-dark" "$GTK4_SETTINGS" 2>/dev/null; then
        echo "dark"
    else
        echo "light"
    fi
}
if [[ -f "$MODE_FILE" ]]; then
    CURRENT_MODE=$(cat "$MODE_FILE")
else
    CURRENT_MODE=$(detect_system_dark)
fi

set_yad_theme() {
    if [[ "$CURRENT_MODE" == "dark" ]]; then
        export GTK_THEME="Adwaita:dark"
    else
        export GTK_THEME="Adwaita:light"
    fi
}
set_yad_theme

# ====== مصفوفات اللغة: القيم IDs ثابتة، والنص يتغير حسب اللغة ======
declare -A MSG_AR=(
    ["main_menu"]="القائمة الرئيسية"
    ["package_manager"]="إدارة الحزم"
    ["flatpak_manager"]="مدير فلاتباك"
    ["snap_manager"]="مدير سناب"
    ["system_tools"]="أدوات النظام"
    ["settings"]="الإعدادات"
    ["exit"]="خروج"
    ["install"]="تثبيت حزمة"
    ["remove"]="إزالة حزمة"
    ["search"]="بحث حزمة"
    ["update"]="تحديث الحزم"
    ["upgrade"]="ترقية الحزم"
    ["list"]="عرض المثبتة"
    ["info"]="معلومات الحزمة"
    ["fix"]="إصلاح الحزم"
    ["clean"]="تنظيف"
    ["autoremove"]="إزالة يتيمة"
    ["back"]="رجوع"
    ["install_flatpak"]="تثبيت فلاتباك"
    ["remove_flatpak"]="إزالة فلاتباك"
    ["search_flatpak"]="بحث فلاتباك"
    ["update_flatpak"]="تحديث فلاتباك"
    ["list_flatpak"]="عرض فلاتباك"
    ["add_flatpak_repo"]="إضافة مستودع فلاتباك"
    ["install_snap"]="تثبيت سناب"
    ["remove_snap"]="إزالة سناب"
    ["search_snap"]="بحث سناب"
    ["update_snap"]="تحديث سناب"
    ["list_snap"]="عرض سناب"
    ["enable_snap"]="تفعيل سناب"
    ["backup_packages"]="نسخ احتياطي"
    ["restore_packages"]="استعادة الحزم"
    ["system_info"]="معلومات النظام"
    ["disk_usage"]="استخدام القرص"
    ["change_lang"]="تغيير اللغة"
    ["change_theme"]="تغيير النمط"
    ["about"]="حول البرنامج"
    ["not_found"]="مدير الحزم غير موجود"
    ["no_package"]="أدخل اسم الحزمة"
    ["enter_package"]="أدخل اسم الحزمة:"
    ["enter_repo"]="أدخل رابط المستودع:"
    ["exiting"]="جاري الخروج من البرنامج... وداعاً!"
    ["terminal_output"]="مخرجات الطرفية (سجل حي)"
)

declare -A MSG_EN=(
    ["main_menu"]="Main Menu"
    ["package_manager"]="Package Manager"
    ["flatpak_manager"]="Flatpak Manager"
    ["snap_manager"]="Snap Manager"
    ["system_tools"]="System Tools"
    ["settings"]="Settings"
    ["exit"]="Exit"
    ["install"]="Install Package"
    ["remove"]="Remove Package"
    ["search"]="Search Package"
    ["update"]="Update Packages"
    ["upgrade"]="Upgrade Packages"
    ["list"]="List Installed"
    ["info"]="Package Info"
    ["fix"]="Fix Packages"
    ["clean"]="Clean"
    ["autoremove"]="Remove Orphaned"
    ["back"]="Back"
    ["install_flatpak"]="Install Flatpak"
    ["remove_flatpak"]="Remove Flatpak"
    ["search_flatpak"]="Search Flatpak"
    ["update_flatpak"]="Update Flatpak"
    ["list_flatpak"]="List Flatpak"
    ["add_flatpak_repo"]="Add Flatpak Repo"
    ["install_snap"]="Install Snap"
    ["remove_snap"]="Remove Snap"
    ["search_snap"]="Search Snap"
    ["update_snap"]="Update Snap"
    ["list_snap"]="List Snap"
    ["enable_snap"]="Enable Snap"
    ["backup_packages"]="Backup"
    ["restore_packages"]="Restore"
    ["system_info"]="System Info"
    ["disk_usage"]="Disk Usage"
    ["change_lang"]="Change Language"
    ["change_theme"]="Change Theme"
    ["about"]="About"
    ["not_found"]="No package manager found"
    ["no_package"]="Enter package name"
    ["enter_package"]="Enter package name:"
    ["enter_repo"]="Enter repository URL:"
    ["exiting"]="Exiting program... Goodbye!"
    ["terminal_output"]="Terminal output (live log)"
)

msg() {
    local key="$1"
    if [[ "$CURRENT_LANG" == "ar" ]]; then
        echo "${MSG_AR[$key]}"
    else
        echo "${MSG_EN[$key]}"
    fi
}

YAD_WIDTH=850
YAD_HEIGHT=600

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

run_terminal() {
    local title="$1"
    local cmd="$2"
    yad --center --width=$YAD_WIDTH --height=$YAD_HEIGHT --title="$title" --button="$(msg back)":0 --terminal --command="bash -c \"$cmd; echo; echo '$(msg terminal_output)'\"" &
    wait $!
}

pause() {
    yad --center --width=400 --height=100 --title="GT-CLPM" --text="$(msg back)" --button="$(msg back)":0
}

# -------- قوائم البرنامج الرئيسية (مفتاح/نص) --------
main_menu() {
    while true; do
        choice=$(yad --center --width=$YAD_WIDTH --height=$YAD_HEIGHT --title="$(msg main_menu)" \
            --list --column="ID" --column="$(msg main_menu)" --print-column=1 \
            "pkg" "$(msg package_manager)" \
            "flatpak" "$(msg flatpak_manager)" \
            "snap" "$(msg snap_manager)" \
            "tools" "$(msg system_tools)" \
            "settings" "$(msg settings)" \
            "exit" "$(msg exit)"
        )
        case "$choice" in
            "pkg")  package_manager_menu ;;
            "flatpak") flatpak_menu ;;
            "snap") snap_menu ;;
            "tools") system_tools_menu ;;
            "settings") settings_menu ;;
            "exit"|"") yad --center --width=400 --height=100 --title="GT-CLPM" --text="$(msg exiting)" --button="$(msg back)":0; exit 0 ;;
        esac
    done
}

package_manager_menu() {
    while true; do
        choice=$(yad --center --width=$YAD_WIDTH --height=500 --title="$(msg package_manager)" \
            --list --column="ID" --column="$(msg package_manager)" --print-column=1 \
            "install" "$(msg install)" \
            "remove" "$(msg remove)" \
            "search" "$(msg search)" \
            "update" "$(msg update)" \
            "upgrade" "$(msg upgrade)" \
            "list" "$(msg list)" \
            "info" "$(msg info)" \
            "fix" "$(msg fix)" \
            "clean" "$(msg clean)" \
            "autoremove" "$(msg autoremove)" \
            "back" "$(msg back)"
        )
        case "$choice" in
            "install")
                package=$(yad --center --width=400 --height=100 --entry --title="$(msg install)" --text="$(msg enter_package)")
                [[ -n "$package" ]] && install_package "$package"
                ;;
            "remove")
                package=$(yad --center --width=400 --height=100 --entry --title="$(msg remove)" --text="$(msg enter_package)")
                [[ -n "$package" ]] && remove_package "$package"
                ;;
            "search")
                package=$(yad --center --width=400 --height=100 --entry --title="$(msg search)" --text="$(msg enter_package)")
                [[ -n "$package" ]] && search_package "$package"
                ;;
            "update"|"upgrade")
                update_packages
                ;;
            "list")
                list_packages
                ;;
            "info")
                package=$(yad --center --width=400 --height=100 --entry --title="$(msg info)" --text="$(msg enter_package)")
                [[ -n "$package" ]] && package_info "$package"
                ;;
            "fix")
                fix_packages
                ;;
            "clean"|"autoremove")
                clean_cache
                ;;
            "back"|"") break ;;
        esac
    done
}

flatpak_menu() {
    check_flatpak
    while true; do
        choice=$(yad --center --width=$YAD_WIDTH --height=500 --title="$(msg flatpak_manager)" \
            --list --column="ID" --column="$(msg flatpak_manager)" --print-column=1 \
            "install" "$(msg install_flatpak)" \
            "remove" "$(msg remove_flatpak)" \
            "search" "$(msg search_flatpak)" \
            "update" "$(msg update_flatpak)" \
            "list" "$(msg list_flatpak)" \
            "addrepo" "$(msg add_flatpak_repo)" \
            "back" "$(msg back)"
        )
        case "$choice" in
            "install")
                package=$(yad --center --width=400 --height=100 --entry --title="$(msg install_flatpak)" --text="$(msg enter_package)")
                [[ -n "$package" ]] && run_terminal "$(msg install_flatpak) $package" "flatpak install -y flathub \"$package\""
                ;;
            "remove")
                package=$(yad --center --width=400 --height=100 --entry --title="$(msg remove_flatpak)" --text="$(msg enter_package)")
                [[ -n "$package" ]] && run_terminal "$(msg remove_flatpak) $package" "flatpak uninstall -y \"$package\""
                ;;
            "search")
                package=$(yad --center --width=400 --height=100 --entry --title="$(msg search_flatpak)" --text="$(msg enter_package)")
                [[ -n "$package" ]] && run_terminal "$(msg search_flatpak) $package" "flatpak search \"$package\""
                ;;
            "update") run_terminal "$(msg update_flatpak)" "flatpak update -y" ;;
            "list")   run_terminal "$(msg list_flatpak)" "flatpak list" ;;
            "addrepo")
                repo=$(yad --center --width=400 --height=100 --entry --title="$(msg add_flatpak_repo)" --text="$(msg enter_repo)")
                [[ -n "$repo" ]] && run_terminal "$(msg add_flatpak_repo)" "flatpak remote-add --if-not-exists custom \"$repo\""
                ;;
            "back"|"") break ;;
        esac
    done
}

snap_menu() {
    check_snap
    while true; do
        choice=$(yad --center --width=$YAD_WIDTH --height=500 --title="$(msg snap_manager)" \
            --list --column="ID" --column="$(msg snap_manager)" --print-column=1 \
            "install" "$(msg install_snap)" \
            "remove" "$(msg remove_snap)" \
            "search" "$(msg search_snap)" \
            "update" "$(msg update_snap)" \
            "list" "$(msg list_snap)" \
            "enable" "$(msg enable_snap)" \
            "back" "$(msg back)"
        )
        case "$choice" in
            "install")
                package=$(yad --center --width=400 --height=100 --entry --title="$(msg install_snap)" --text="$(msg enter_package)")
                [[ -n "$package" ]] && run_terminal "$(msg install_snap) $package" "snap install \"$package\""
                ;;
            "remove")
                package=$(yad --center --width=400 --height=100 --entry --title="$(msg remove_snap)" --text="$(msg enter_package)")
                [[ -n "$package" ]] && run_terminal "$(msg remove_snap) $package" "snap remove \"$package\""
                ;;
            "search")
                package=$(yad --center --width=400 --height=100 --entry --title="$(msg search_snap)" --text="$(msg enter_package)")
                [[ -n "$package" ]] && run_terminal "$(msg search_snap) $package" "snap find \"$package\""
                ;;
            "update") run_terminal "$(msg update_snap)" "snap refresh" ;;
            "list")   run_terminal "$(msg list_snap)" "snap list" ;;
            "enable") run_terminal "$(msg enable_snap)" "systemctl enable --now snapd.socket" ;;
            "back"|"") break ;;
        esac
    done
}

system_tools_menu() {
    while true; do
        choice=$(yad --center --width=$YAD_WIDTH --height=400 --title="$(msg system_tools)" \
            --list --column="ID" --column="$(msg system_tools)" --print-column=1 \
            "backup" "$(msg backup_packages)" \
            "restore" "$(msg restore_packages)" \
            "info" "$(msg system_info)" \
            "disk" "$(msg disk_usage)" \
            "back" "$(msg back)"
        )
        case "$choice" in
            "backup") backup_packages ;;
            "restore") restore_packages ;;
            "info")    show_system_info ;;
            "disk")    show_disk_usage ;;
            "back"|"") break ;;
        esac
    done
}

settings_menu() {
    while true; do
        choice=$(yad --center --width=400 --height=200 --title="$(msg settings)" \
            --list --column="ID" --column="$(msg settings)" --print-column=1 \
            "lang" "$(msg change_lang)" \
            "theme" "$(msg change_theme)" \
            "about" "$(msg about)" \
            "back" "$(msg back)"
        )
        case "$choice" in
            "lang") change_language ;;
            "theme") change_theme ;;
            "about") show_about ;;
            "back"|"") break ;;
        esac
    done
}

# -------- دوال الأوامر التنفيذية (كما في السكربت السابق) --------

install_package() {
    local package="$1"
    local pm=$(detect_package_manager)
    if [[ -z "$package" ]]; then
        yad --center --width=400 --height=100 --title="GT-CLPM" --text="$(msg no_package)" --button="$(msg back)":0
        return 1
    fi
    local cmd
    case $pm in
        "apt") cmd="apt update && apt install -y \"$package\"" ;;
        "dnf") cmd="dnf install -y \"$package\"" ;;
        "yum") cmd="yum install -y \"$package\"" ;;
        "pacman") cmd="pacman -S --noconfirm \"$package\"" ;;
        "zypper") cmd="zypper install -y \"$package\"" ;;
        "eopkg") cmd="eopkg install \"$package\"" ;;
        "xbps") cmd="xbps-install -S \"$package\"" ;;
        "emerge") cmd="emerge \"$package\"" ;;
        "pkg") cmd="pkg install \"$package\"" ;;
        "apk") cmd="apk add \"$package\"" ;;
        "nix") cmd="nix-env -i \"$package\"" ;;
        *) yad --center --width=400 --height=100 --title="GT-CLPM" --text="$(msg not_found)" --button="$(msg back)":0; return 1 ;;
    esac
    run_terminal "$(msg install) $package" "$cmd"
}

remove_package() {
    local package="$1"
    local pm=$(detect_package_manager)
    if [[ -z "$package" ]]; then
        yad --center --width=400 --height=100 --title="GT-CLPM" --text="$(msg no_package)" --button="$(msg back)":0
        return 1
    fi
    local cmd
    case $pm in
        "apt") cmd="apt remove -y \"$package\"" ;;
        "dnf") cmd="dnf remove -y \"$package\"" ;;
        "yum") cmd="yum remove -y \"$package\"" ;;
        "pacman") cmd="pacman -R --noconfirm \"$package\"" ;;
        "zypper") cmd="zypper remove -y \"$package\"" ;;
        "eopkg") cmd="eopkg remove \"$package\"" ;;
        "xbps") cmd="xbps-remove \"$package\"" ;;
        "emerge") cmd="emerge --unmerge \"$package\"" ;;
        "pkg") cmd="pkg delete \"$package\"" ;;
        "apk") cmd="apk del \"$package\"" ;;
        "nix") cmd="nix-env -e \"$package\"" ;;
        *) yad --center --width=400 --height=100 --title="GT-CLPM" --text="$(msg not_found)" --button="$(msg back)":0; return 1 ;;
    esac
    run_terminal "$(msg remove) $package" "$cmd"
}

search_package() {
    local package="$1"
    local pm=$(detect_package_manager)
    if [[ -z "$package" ]]; then
        yad --center --width=400 --height=100 --title="GT-CLPM" --text="$(msg no_package)" --button="$(msg back)":0
        return 1
    fi
    local cmd
    case $pm in
        "apt") cmd="apt search \"$package\"" ;;
        "dnf") cmd="dnf search \"$package\"" ;;
        "yum") cmd="yum search \"$package\"" ;;
        "pacman") cmd="pacman -Ss \"$package\"" ;;
        "zypper") cmd="zypper search \"$package\"" ;;
        "eopkg") cmd="eopkg search \"$package\"" ;;
        "xbps") cmd="xbps-query -Rs \"$package\"" ;;
        "emerge") cmd="emerge --search \"$package\"" ;;
        "pkg") cmd="pkg search \"$package\"" ;;
        "apk") cmd="apk search \"$package\"" ;;
        "nix") cmd="nix-env -qa | grep \"$package\"" ;;
        *) yad --center --width=400 --height=100 --title="GT-CLPM" --text="$(msg not_found)" --button="$(msg back)":0; return 1 ;;
    esac
    run_terminal "$(msg search) $package" "$cmd"
}

update_packages() {
    local pm=$(detect_package_manager)
    local cmd
    case $pm in
        "apt") cmd="apt update && apt upgrade -y" ;;
        "dnf") cmd="dnf update -y" ;;
        "yum") cmd="yum update -y" ;;
        "pacman") cmd="pacman -Syu --noconfirm" ;;
        "zypper") cmd="zypper update -y" ;;
        "eopkg") cmd="eopkg upgrade" ;;
        "xbps") cmd="xbps-install -Su" ;;
        "emerge") cmd="emerge --sync && emerge -uDN @world" ;;
        "pkg") cmd="pkg update && pkg upgrade" ;;
        "apk") cmd="apk update && apk upgrade" ;;
        "nix") cmd="nix-channel --update && nix-env -u" ;;
        *) yad --center --width=400 --height=100 --title="GT-CLPM" --text="$(msg not_found)" --button="$(msg back)":0; return 1 ;;
    esac
    run_terminal "$(msg update)" "$cmd"
}

fix_packages() {
    local pm=$(detect_package_manager)
    local cmd
    case $pm in
        "apt") cmd="apt update && apt --fix-broken install -y && dpkg --configure -a" ;;
        "dnf") cmd="dnf check && dnf autoremove -y" ;;
        "yum") cmd="yum check && yum autoremove -y" ;;
        "pacman") cmd="pacman -Dk && pacman -Sc --noconfirm" ;;
        "zypper") cmd="zypper verify && zypper clean -a" ;;
        "eopkg") cmd="eopkg check" ;;
        "xbps") cmd="xbps-pkgdb -a && xbps-remove -Oo" ;;
        "emerge") cmd="emerge --depclean && revdep-rebuild" ;;
        "pkg") cmd="pkg check -d && pkg autoremove" ;;
        "apk") cmd="apk fix && apk cache clean" ;;
        "nix") cmd="nix-collect-garbage -d" ;;
        *) yad --center --width=400 --height=100 --title="GT-CLPM" --text="$(msg not_found)" --button="$(msg back)":0; return 1 ;;
    esac
    run_terminal "$(msg fix)" "$cmd"
}

list_packages() {
    local pm=$(detect_package_manager)
    local cmd
    case $pm in
        "apt") cmd="dpkg -l | grep ^ii" ;;
        "dnf"|"yum") cmd="$pm list installed" ;;
        "pacman") cmd="pacman -Q" ;;
        "zypper") cmd="zypper search -i" ;;
        "eopkg") cmd="eopkg list-installed" ;;
        "xbps") cmd="xbps-query -l" ;;
        "emerge") cmd="qlist -I" ;;
        "pkg") cmd="pkg info" ;;
        "apk") cmd="apk info" ;;
        "nix") cmd="nix-env -q" ;;
        *) yad --center --width=400 --height=100 --title="GT-CLPM" --text="$(msg not_found)" --button="$(msg back)":0; return 1 ;;
    esac
    run_terminal "$(msg list)" "$cmd"
}

package_info() {
    local package="$1"
    local pm=$(detect_package_manager)
    if [[ -z "$package" ]]; then
        yad --center --width=400 --height=100 --title="GT-CLPM" --text="$(msg no_package)" --button="$(msg back)":0
        return 1
    fi
    local cmd
    case $pm in
        "apt") cmd="apt show \"$package\"" ;;
        "dnf"|"yum") cmd="$pm info \"$package\"" ;;
        "pacman") cmd="pacman -Si \"$package\"" ;;
        "zypper") cmd="zypper info \"$package\"" ;;
        "eopkg") cmd="eopkg info \"$package\"" ;;
        "xbps") cmd="xbps-query -R \"$package\"" ;;
        "emerge") cmd="emerge --info \"$package\"" ;;
        "pkg") cmd="pkg info \"$package\"" ;;
        "apk") cmd="apk info \"$package\"" ;;
        "nix") cmd="nix-env -qa --description | grep \"$package\"" ;;
        *) yad --center --width=400 --height=100 --title="GT-CLPM" --text="$(msg not_found)" --button="$(msg back)":0; return 1 ;;
    esac
    run_terminal "$(msg info) $package" "$cmd"
}

clean_cache() {
    local pm=$(detect_package_manager)
    local cmd
    case $pm in
        "apt") cmd="apt autoclean && apt autoremove -y" ;;
        "dnf") cmd="dnf clean all && dnf autoremove -y" ;;
        "yum") cmd="yum clean all && yum autoremove -y" ;;
        "pacman") cmd="pacman -Sc --noconfirm && pacman -Rns \$(pacman -Qtdq) --noconfirm 2>/dev/null || true" ;;
        "zypper") cmd="zypper clean -a" ;;
        "eopkg") cmd="eopkg delete-cache" ;;
        "xbps") cmd="xbps-remove -Oo" ;;
        "emerge") cmd="emerge --depclean && eclean distfiles" ;;
        "pkg") cmd="pkg clean && pkg autoremove" ;;
        "apk") cmd="apk cache clean" ;;
        "nix") cmd="nix-collect-garbage -d" ;;
        *) yad --center --width=400 --height=100 --title="GT-CLPM" --text="$(msg not_found)" --button="$(msg back)":0; return 1 ;;
    esac
    run_terminal "$(msg clean)" "$cmd"
}

show_system_info() {
    local cmd
    cmd="echo 'OS: $(lsb_release -d 2>/dev/null | cut -f2 || cat /etc/os-release | grep PRETTY_NAME | cut -d'\"' -f2)'
echo 'Kernel: $(uname -r)'
echo 'Architecture: $(uname -m)'
echo 'Package Manager: $(detect_package_manager)'
echo 'Uptime: $(uptime -p 2>/dev/null || uptime)'
echo 'Memory: $(free -h | grep Mem | awk \\'{print \$3\"/\"\$2}\\')'
echo 'CPU: $(grep \"model name\" /proc/cpuinfo | head -1 | cut -d\":\" -f2 | sed \\'s/^ *//\\')'"
    run_terminal "$(msg system_info)" "$cmd"
}

show_disk_usage() {
    run_terminal "$(msg disk_usage)" "df -h | grep -v tmpfs | grep -v udev"
}

backup_packages() {
    local pm=$(detect_package_manager)
    local backup_file="$HOME/gt-clpm-backup-$(date +%Y%m%d_%H%M%S).txt"
    local cmd
    case $pm in
        "apt") cmd="dpkg --get-selections > \"$backup_file\" && echo '$(msg backup_packages): $backup_file'" ;;
        "dnf"|"yum") cmd="$pm list installed > \"$backup_file\" && echo '$(msg backup_packages): $backup_file'" ;;
        "pacman") cmd="pacman -Q > \"$backup_file\" && echo '$(msg backup_packages): $backup_file'" ;;
        "zypper") cmd="zypper search -i > \"$backup_file\" && echo '$(msg backup_packages): $backup_file'" ;;
        "eopkg") cmd="eopkg list-installed > \"$backup_file\" && echo '$(msg backup_packages): $backup_file'" ;;
        *) yad --center --width=400 --height=100 --title="GT-CLPM" --text="Backup not implemented for this manager" --button="$(msg back)":0; return 1 ;;
    esac
    run_terminal "$(msg backup_packages)" "$cmd"
}

restore_packages() {
    yad --center --width=600 --height=200 --title="GT-CLPM" --text="هذه الميزة تتطلب تنفيذ يدوي. ملفات النسخ الاحتياطي محفوظة في: $HOME/gt-clpm-backup-*.txt" --button="$(msg back)":0
}

change_language() {
    if [[ "$CURRENT_LANG" == "ar" ]]; then
        CURRENT_LANG="en"
        echo "en" > "$LANG_FILE"
    else
        CURRENT_LANG="ar"
        echo "ar" > "$LANG_FILE"
    fi
    yad --center --width=400 --height=100 --title="GT-CLPM" --text="تم تغيير اللغة" --button="$(msg back)":0
}

change_theme() {
    theme_choice=$(yad --center --width=400 --height=180 --title="$(msg change_theme)" --list --column="ID" --column="$(msg change_theme)" --print-column=1 \
        "light" "فاتح / Light" \
        "dark" "داكن / Dark")
    [[ "$theme_choice" == "dark" ]] && CURRENT_MODE="dark" || CURRENT_MODE="light"
    echo "$CURRENT_MODE" > "$MODE_FILE"
    set_yad_theme
    yad --center --width=400 --height=100 --title="GT-CLPM" --text="تم تغيير النمط" --button="$(msg back)":0
}

show_about() {
    msg="GT-CLPM - GNUTUX Command Line Package Manager\n"
    msg+="مدير حزم شامل لأنظمة جنو/لينكس\n"
    msg+="يدعم: APT, DNF/YUM, Pacman, Zypper, Eopkg, XBPS, Emerge, PKG, APK, Nix, Flatpak, Snap"
    yad --center --width=600 --height=350 --title="$(msg about)" --text="$msg" --button="$(msg back)":0
}

# -------- دوال فحص Flatpak و Snap --------
check_flatpak() {
    if ! command -v flatpak &> /dev/null; then
        yad --center --width=400 --height=100 --title="GT-CLPM" --text="فلاتباك غير مثبت. هل ترغب بالتثبيت؟" --button="نعم":0 --button="لا":1
        if [[ $? -eq 0 ]]; then
            run_terminal "تثبيت Flatpak" "apt install -y flatpak || dnf install -y flatpak || pacman -S --noconfirm flatpak || zypper install -y flatpak || eopkg install -y flatpak"
            flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
        else
            return 1
        fi
    fi
}

check_snap() {
    if ! command -v snap &> /dev/null; then
        yad --center --width=400 --height=100 --title="GT-CLPM" --text="سناب غير مثبت. هل ترغب بالتثبيت؟" --button="نعم":0 --button="لا":1
        if [[ $? -eq 0 ]]; then
            run_terminal "تثبيت Snap" "apt install -y snapd || dnf install -y snapd || pacman -S --noconfirm snapd || zypper install -y snapd || eopkg install -y snapd"
            systemctl enable --now snapd.socket
        else
            return 1
        fi
    fi
}
main() {
    main_menu
}
main "$@"
