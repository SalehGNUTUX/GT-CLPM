#!/bin/bash

# GT-CLPM - GNUTUX Command Line Package Manager (Zenity GUI)
# Version: 1.3
# License: GPLv2
# Developer: GNUTUX

# --- تحسينات رئيسية ---
# 1. إصلاح عرض مخرجات الطرفية بشكل حي
# 2. تحسين الترجمة العربية في قسم الإعدادات
# 3. تحسين كفاءة تنفيذ الأوامر
# 4. إضافة فحص تلقائي لصلاحيات root
# 5. تحسين دعم الوضع الداكن والفاتح

# ---- فحص Zenity ----
if ! command -v zenity &> /dev/null; then
    zen_txt="Zenity is required for graphical interface. Installing..."
    if command -v apt &> /dev/null; then
        x-terminal-emulator -e "sudo apt update && sudo apt install -y zenity"
    elif command -v dnf &> /dev/null; then
        x-terminal-emulator -e "sudo dnf install -y zenity"
    elif command -v pacman &> /dev/null; then
        x-terminal-emulator -e "sudo pacman -S --noconfirm zenity"
    elif command -v zypper &> /dev/null; then
        x-terminal-emulator -e "sudo zypper install -y zenity"
    elif command -v eopkg &> /dev/null; then
        x-terminal-emulator -e "sudo eopkg install zenity"
    else
        echo "$zen_txt"
        exit 1
    fi
    sleep 5 # انتظار اكتمال التثبيت
fi

# ---- فحص صلاحيات root وإعادة التشغيل التلقائي ----
if [[ "$EUID" -ne 0 ]]; then
    zenity --question --title="GT-CLPM" --text="يجب تشغيل البرنامج بصلاحيات المدير (root).\nهل ترغب في تشغيله الآن؟"
    if [[ $? -eq 0 ]]; then
        exec pkexec env DISPLAY=$DISPLAY XAUTHORITY=$XAUTHORITY bash "$(readlink -f "$0")" "$@"
    else
        zenity --error --title="GT-CLPM" --text="البرنامج يحتاج لصلاحيات المدير (root) لتنفيذ العمليات."
        exit 1
    fi
fi

# ---- إعدادات اللغة ----
LANG_FILE="$HOME/.gt-clpm-lang"
if [[ -f "$LANG_FILE" ]]; then
    CURRENT_LANG=$(cat "$LANG_FILE")
else
    CURRENT_LANG="en"
fi

# ---- إعدادات الوضع الداكن ----
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

set_zenity_env() {
    if [[ "$CURRENT_MODE" == "dark" ]]; then
        export GTK_THEME="Adwaita:dark"
        export GNOME_THEME="Adwaita-dark"
    else
        export GTK_THEME="Adwaita:light"
        export GNOME_THEME="Adwaita"
    fi
}
set_zenity_env

# ---- مصفوفات اللغة ----
declare -A MESSAGES_EN=(
    ["title"]="GT-CLPM - GNUTUX Command Line Package Manager"
    ["version"]="Version 1.3 - GPLv2 License - Developed by GNUTUX"
    ["main_menu"]="Main Menu"
    ["package_manager"]="Package Manager Operations"
    ["flatpak_manager"]="Flatpak Manager"
    ["snap_manager"]="Snap Manager"
    ["system_tools"]="System Tools"
    ["settings"]="Settings"
    ["exit"]="Exit"
    ["install"]="Install package"
    ["remove"]="Remove package"
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
    ["search_flatpak"]="Search Flatpak packages"
    ["update_flatpak"]="Update Flatpak packages"
    ["list_flatpak"]="List Flatpak packages"
    ["add_flatpak_repo"]="Add Flatpak repository"
    ["install_snap"]="Install Snap package"
    ["remove_snap"]="Remove Snap package"
    ["search_snap"]="Search Snap packages"
    ["update_snap"]="Update Snap packages"
    ["list_snap"]="List Snap packages"
    ["enable_snap"]="Enable Snap service"
    ["backup_packages"]="Backup package list"
    ["restore_packages"]="Restore packages from backup"
    ["system_info"]="Show system information"
    ["disk_usage"]="Show disk usage"
    ["change_lang"]="Change language"
    ["change_theme"]="Change theme (Light/Dark)"
    ["about"]="About GT-CLPM"
    ["back"]="Back"
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
    ["theme_changed"]="Theme changed"
    ["flatpak_not_installed"]="Flatpak is not installed. Installing..."
    ["snap_not_installed"]="Snap is not installed. Installing..."
    ["enter_package"]="Enter package name:"
    ["enter_choice"]="Choose an operation:"
    ["operation_completed"]="Operation completed"
    ["press_enter"]="Press OK to continue..."
    ["enter_repo"]="Enter repository URL:"
    ["backup_created"]="Package list backup created"
    ["restore_completed"]="Package restoration completed"
    ["exiting"]="Exiting GT-CLPM... Goodbye!"
    ["terminal_output"]="Terminal output (live log)"
    ["sysinfo"]="System Information:\n\nOS: $(lsb_release -d 2>/dev/null | cut -f2 || cat /etc/os-release | grep PRETTY_NAME | cut -d'\"' -f2)\nKernel: $(uname -r)\nArchitecture: $(uname -m)\nPackage Manager: $(detect_package_manager)\nUptime: $(uptime -p 2>/dev/null || uptime)\nMemory: $(free -h | grep Mem | awk '{print $3"/"$2}')\nCPU: $(grep "model name" /proc/cpuinfo | head -1 | cut -d":" -f2 | sed 's/^ *//')"
)

declare -A MESSAGES_AR=(
    ["title"]="GT-CLPM - مدير حزم سطر الأوامر من جنوتكس"
    ["version"]="الإصدار 1.3 - رخصة GPLv2 - من تطوير GNUTUX"
    ["main_menu"]="القائمة الرئيسية"
    ["package_manager"]="عمليات مدير الحزم"
    ["flatpak_manager"]="مدير فلاتباك"
    ["snap_manager"]="مدير سناب"
    ["system_tools"]="أدوات النظام"
    ["settings"]="الإعدادات"
    ["exit"]="خروج"
    ["install"]="تثبيت حزمة"
    ["remove"]="إزالة حزمة"
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
    ["search_flatpak"]="البحث في حزم فلاتباك"
    ["update_flatpak"]="تحديث حزم فلاتباك"
    ["list_flatpak"]="عرض حزم فلاتباك"
    ["add_flatpak_repo"]="إضافة مستودع فلاتباك"
    ["install_snap"]="تثبيت حزمة سناب"
    ["remove_snap"]="إزالة حزمة سناب"
    ["search_snap"]="البحث في حزم سناب"
    ["update_snap"]="تحديث حزم سناب"
    ["list_snap"]="عرض حزم سناب"
    ["enable_snap"]="تفعيل خدمة سناب"
    ["backup_packages"]="نسخ احتياطي لقائمة الحزم"
    ["restore_packages"]="استعادة الحزم من النسخ الاحتياطي"
    ["system_info"]="عرض معلومات النظام"
    ["disk_usage"]="عرض استخدام القرص"
    ["change_lang"]="تغيير اللغة"
    ["change_theme"]="تغيير النمط (فاتح/داكن)"
    ["about"]="حول البرنامج"
    ["back"]="رجوع"
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
    ["theme_changed"]="تم تغيير النمط"
    ["flatpak_not_installed"]="فلاتباك غير مثبت. جاري التثبيت..."
    ["snap_not_installed"]="سناب غير مثبت. جاري التثبيت..."
    ["enter_package"]="أدخل اسم الحزمة:"
    ["enter_choice"]="اختر العملية:"
    ["operation_completed"]="تمت العملية بنجاح"
    ["press_enter"]="اضغط موافق للمتابعة..."
    ["enter_repo"]="أدخل رابط المستودع:"
    ["backup_created"]="تم إنشاء نسخة احتياطية لقائمة الحزم"
    ["restore_completed"]="تم استعادة الحزم بنجاح"
    ["exiting"]="جاري الخروج من البرنامج... وداعاً!"
    ["terminal_output"]="مخرجات الطرفية (سجل حي)"
    ["sysinfo"]="معلومات النظام:\n\nنظام التشغيل: $(lsb_release -d 2>/dev/null | cut -f2 || cat /etc/os-release | grep PRETTY_NAME | cut -d'\"' -f2)\nالنواة: $(uname -r)\nالهيكل: $(uname -m)\nمدير الحزم: $(detect_package_manager)\nمدة التشغيل: $(uptime -p 2>/dev/null || uptime)\nالذاكرة: $(free -h | grep Mem | awk '{print $3"/"$2}')\nالمعالج: $(grep "model name" /proc/cpuinfo | head -1 | cut -d":" -f2 | sed 's/^ *//')"
)

get_msg() {
    local key="$1"
    if [[ "$CURRENT_LANG" == "ar" ]]; then
        echo "${MESSAGES_AR[$key]}"
    else
        echo "${MESSAGES_EN[$key]}"
    fi
}

ZENITY_WIDTH=880
ZENITY_HEIGHT=680

# ==== محسن: مربع حوار الطرفية مع عرض حي للمخرجات ====
show_terminal_box() {
    local title="$1"
    local cmd="$2"
    local tmpfile="$(mktemp /tmp/gtclpm-terminal.XXXXXX)"

    # تنفيذ الأمر في الخلفية وحفظ المخرجات في ملف مؤقت
    ($cmd | tee "$tmpfile") &
    local pid=$!

    # عرض شريط التقدم مع المخرجات الحية
    (
        while kill -0 $pid 2>/dev/null; do
            echo "# $(tail -n 1 "$tmpfile")"
            sleep 0.5
        done
    ) | zenity --progress --title="$title" --text="$(get_msg "terminal_output")" \
        --auto-close --width=$ZENITY_WIDTH --height=120 --no-cancel --pulsate

    # عرض كامل السجل بعد الانتهاء
    zenity --text-info --title="$title - $(get_msg "terminal_output")" \
        --width=$ZENITY_WIDTH --height=400 --filename="$tmpfile" \
        --ok-label="$(get_msg "press_enter")"

    rm -f "$tmpfile"
}

pause() {
    zenity --info --text="$(get_msg "press_enter")" --title="GT-CLPM" --width=400 --height=100
}

show_header() {
    local subtitle="$1"
    zenity --info --title="GT-CLPM" --width=800 --height=180 \
        --text="$(get_msg "title")\n$(get_msg "version")\n$(get_msg "detected") $(detect_package_manager)\n\n$subtitle"
}

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

# ==== دوال إدارة الحزم مع مربع الطرفية المحسن ====
install_package() {
    local package="$1"
    local pm=$(detect_package_manager)
    if [[ -z "$package" ]]; then
        zenity --error --text="$(get_msg "error") $(get_msg "no_package")" --title="GT-CLPM" --width=400 --height=100
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
        *) zenity --error --text="$(get_msg "error") $(get_msg "not_found")" --title="GT-CLPM" --width=400 --height=100; return 1 ;;
    esac
    show_terminal_box "$(get_msg "installing") $package" "$cmd"
}

remove_package() {
    local package="$1"
    local pm=$(detect_package_manager)
    if [[ -z "$package" ]]; then
        zenity --error --text="$(get_msg "error") $(get_msg "no_package")" --title="GT-CLPM" --width=400 --height=100
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
        *) zenity --error --text="$(get_msg "error") $(get_msg "not_found")" --title="GT-CLPM" --width=400 --height=100; return 1 ;;
    esac
    show_terminal_box "$(get_msg "removing") $package" "$cmd"
}

search_package() {
    local package="$1"
    local pm=$(detect_package_manager)

    if [[ -z "$package" ]]; then
        zenity --error --text="$(get_msg "error") $(get_msg "no_package")" \
               --title="GT-CLPM" --width=400 --height=100
        return 1
    fi

    local tmpfile="$(mktemp /tmp/gtclpm-search.XXXXXX)"
    local cmd

    case $pm in
        "apt") cmd="apt-cache search \"$package\" | grep -i \"$package\" | head -n 50" ;;
        "dnf") cmd="dnf search \"$package\" | grep -i \"$package\" | head -n 50" ;;
        "yum") cmd="yum search \"$package\" | grep -i \"$package\" | head -n 50" ;;
        "pacman") cmd="pacman -Ss \"$package\" | grep -i \"$package\" | head -n 50" ;;
        "zypper") cmd="zypper search -s \"$package\" | grep -i \"$package\" | head -n 50" ;;
        "eopkg") cmd="eopkg search \"$package\" | grep -i \"$package\" | head -n 50" ;;
        "xbps") cmd="xbps-query -Rs \"$package\" | grep -i \"$package\" | head -n 50" ;;
        "emerge") cmd="emerge --search \"$package\" | grep -i \"$package\" | head -n 50" ;;
        "pkg") cmd="pkg search \"$package\" | grep -i \"$package\" | head -n 50" ;;
        "apk") cmd="apk search \"$package\" | grep -i \"$package\" | head -n 50" ;;
        "nix") cmd="nix-env -qa \"*$package*\" | grep -i \"$package\" | head -n 50" ;;
        *)
            zenity --error --text="$(get_msg "error") $(get_msg "not_found")" \
                   --title="GT-CLPM" --width=400 --height=100
            return 1
            ;;
    esac

    # تنفيذ الأمر وحفظ النتائج في ملف مؤقت
    eval "$cmd" > "$tmpfile" 2>&1

    # التحقق من وجود نتائج
    if [[ ! -s "$tmpfile" ]]; then
        zenity --info --text="$(get_msg "info_msg") No packages found matching '$package'" \
               --title="$(get_msg "searching")" --width=400 --height=100
        rm -f "$tmpfile"
        return 0
    fi

    # عرض النتائج في نافذة نصية مع تمييز الحزمة المطلوبة
    zenity --text-info --title="$(get_msg "searching") $package - $(get_msg "results")" \
           --width=800 --height=600 --filename="$tmpfile" \
           --ok-label="$(get_msg "back")" \
           --cancel-label="$(get_msg "install")"

    local ret=$?

    # إذا ضغط المستخدم على زر التثبيت
    if [[ $ret -eq 1 ]]; then
        local selected_pkg=$(zenity --entry --title="$(get_msg "install")" \
                                   --text="$(get_msg "enter_package_name_to_install")" \
                                   --width=400 --height=100)
        if [[ -n "$selected_pkg" ]]; then
            install_package "$selected_pkg"
        fi
    fi

    rm -f "$tmpfile"
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
        *) zenity --error --text="$(get_msg "error") $(get_msg "not_found")" --title="GT-CLPM" --width=400 --height=100; return 1 ;;
    esac
    show_terminal_box "$(get_msg "updating")" "$cmd"
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
        *) zenity --error --text="$(get_msg "error") $(get_msg "not_found")" --title="GT-CLPM" --width=400 --height=100; return 1 ;;
    esac
    show_terminal_box "$(get_msg "fixing")" "$cmd"
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
        *) zenity --error --text="$(get_msg "error") $(get_msg "not_found")" --title="GT-CLPM" --width=400 --height=100; return 1 ;;
    esac
    show_terminal_box "$(get_msg "listing")" "$cmd"
}

package_info() {
    local package="$1"
    local pm=$(detect_package_manager)
    if [[ -z "$package" ]]; then
        zenity --error --text="$(get_msg "error") $(get_msg "no_package")" --title="GT-CLPM" --width=400 --height=100
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
        *) zenity --error --text="$(get_msg "error") $(get_msg "not_found")" --title="GT-CLPM" --width=400 --height=100; return 1 ;;
    esac
    show_terminal_box "$(get_msg "info") $package" "$cmd"
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
        *) zenity --error --text="$(get_msg "error") $(get_msg "not_found")" --title="GT-CLPM" --width=400 --height=100; return 1 ;;
    esac
    show_terminal_box "$(get_msg "cleaning")" "$cmd"
}

show_system_info() {
    show_terminal_box "$(get_msg "system_info")" "echo -e \"$(get_msg "sysinfo")\""
}

show_disk_usage() {
    show_terminal_box "$(get_msg "disk_usage")" "df -h | grep -v tmpfs | grep -v udev"
}

backup_packages() {
    local pm=$(detect_package_manager)
    local backup_file="$HOME/gt-clpm-backup-$(date +%Y%m%d_%H%M%S).txt"
    local cmd
    case $pm in
        "apt") cmd="dpkg --get-selections > \"$backup_file\" && echo '$(get_msg "backup_created"): $backup_file'" ;;
        "dnf"|"yum") cmd="$pm list installed > \"$backup_file\" && echo '$(get_msg "backup_created"): $backup_file'" ;;
        "pacman") cmd="pacman -Q > \"$backup_file\" && echo '$(get_msg "backup_created"): $backup_file'" ;;
        "zypper") cmd="zypper search -i > \"$backup_file\" && echo '$(get_msg "backup_created"): $backup_file'" ;;
        "eopkg") cmd="eopkg list-installed > \"$backup_file\" && echo '$(get_msg "backup_created"): $backup_file'" ;;
        *) zenity --warning --text="$(get_msg "warning") Backup not implemented for this package manager" --title="GT-CLPM" --width=400 --height=100; return 1 ;;
    esac
    show_terminal_box "$(get_msg "backup_packages")" "$cmd"
}

restore_packages() {
    zenity --warning --text="$(get_msg "warning") This feature requires manual implementation for safety.\nBackup files are stored in: $HOME/gt-clpm-backup-*.txt" --title="GT-CLPM" --width=600 --height=200
}

change_language() {
    if [[ "$CURRENT_LANG" == "en" ]]; then
        CURRENT_LANG="ar"
        echo "ar" > "$LANG_FILE"
    else
        CURRENT_LANG="en"
        echo "en" > "$LANG_FILE"
    fi
    zenity --info --text="$(get_msg "lang_changed")" --title="GT-CLPM" --width=400 --height=100
}

change_theme() {
    local theme_choice
    if [[ "$CURRENT_LANG" == "ar" ]]; then
        theme_choice=$(zenity --list --title="$(get_msg "change_theme")" --column="" --width=400 --height=180 "فاتح" "داكن")
        [[ "$theme_choice" == "داكن" ]] && CURRENT_MODE="dark" || CURRENT_MODE="light"
    else
        theme_choice=$(zenity --list --title="$(get_msg "change_theme")" --column="" --width=400 --height=180 "Light" "Dark")
        [[ "$theme_choice" == "Dark" ]] && CURRENT_MODE="dark" || CURRENT_MODE="light"
    fi
    echo "$CURRENT_MODE" > "$MODE_FILE"
    set_zenity_env
    zenity --info --text="$(get_msg "theme_changed")" --title="GT-CLPM" --width=400 --height=100
}

show_about() {
    local msg
    if [[ "$CURRENT_LANG" == "ar" ]]; then
        msg="GT-CLPM - مدير حزم سطر الأوامر من جنوتكس\n"
        msg+="الإصدار: 1.3\nالرخصة: GPLv2\nالمطور: GNUTUX\nمدير حزم شامل لأنظمة جنو/لينكس\n\n"
        msg+="مديرو الحزم المدعومون:\n"
        msg+="• APT (ديبيان، أوبنتو)\n• DNF/YUM (فيدورا، RHEL)\n• Pacman (أرش، مانجارو)\n"
        msg+="• Zypper (أوبن سوزي)\n• Eopkg (سولوس)\n• XBPS (فويد لينكس)\n• Emerge (جنتو)\n"
        msg+="• PKG (فري بي إس دي)\n• APK (ألبين)\n• Nix (نيكس أو إس)\n• فلاتباك\n• سناب"
    else
        msg="GT-CLPM - GNUTUX Command Line Package Manager\n"
        msg+="Version: 1.3\nLicense: GPLv2\nDeveloper: GNUTUX\nUniversal package manager for GNU/Linux systems\n\n"
        msg+="Supported Package Managers:\n"
        msg+="• APT (Debian, Ubuntu)\n• DNF/YUM (Fedora, RHEL)\n• Pacman (Arch, Manjaro)\n"
        msg+="• Zypper (openSUSE)\n• Eopkg (Solus)\n• XBPS (Void Linux)\n• Emerge (Gentoo)\n"
        msg+="• PKG (FreeBSD)\n• APK (Alpine)\n• Nix (NixOS)\n• Flatpak\n• Snap"
    fi
    zenity --info --title="$(get_msg "about")" --text="$msg" --width=600 --height=350
}

# ==== دوال فحص Flatpak و Snap ====
check_flatpak() {
    if ! command -v flatpak &> /dev/null; then
        zenity --question --text="$(get_msg "flatpak_not_installed")" --title="GT-CLPM" --width=400 --height=100
        if [[ $? -eq 0 ]]; then
            show_terminal_box "$(get_msg "installing") Flatpak" "apt install -y flatpak || dnf install -y flatpak || pacman -S --noconfirm flatpak || zypper install -y flatpak || eopkg install -y flatpak"
            flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
        else
            return 1
        fi
    fi
}

check_snap() {
    if ! command -v snap &> /dev/null; then
        zenity --question --text="$(get_msg "snap_not_installed")" --title="GT-CLPM" --width=400 --height=100
        if [[ $? -eq 0 ]]; then
            show_terminal_box "$(get_msg "installing") Snap" "apt install -y snapd || dnf install -y snapd || pacman -S --noconfirm snapd || zypper install -y snapd || eopkg install -y snapd"
            systemctl enable --now snapd.socket
        else
            return 1
        fi
    fi
}

# ==== دوال القوائم ====
package_manager_menu() {
    while true; do
        local choice
        choice=$(zenity --list --title="$(get_msg "package_manager")" --column="" --width=$ZENITY_WIDTH --height=500 \
            "$(get_msg "install")" \
            "$(get_msg "remove")" \
            "$(get_msg "search")" \
            "$(get_msg "update")" \
            "$(get_msg "upgrade")" \
            "$(get_msg "list")" \
            "$(get_msg "info")" \
            "$(get_msg "fix")" \
            "$(get_msg "clean")" \
            "$(get_msg "autoremove")" \
            "$(get_msg "back")"
        )
        case "$choice" in
            "$(get_msg "install")")
                package=$(zenity --entry --title="$(get_msg "install")" --text="$(get_msg "enter_package")" --width=400 --height=100)
                install_package "$package"
                ;;
            "$(get_msg "remove")")
                package=$(zenity --entry --title="$(get_msg "remove")" --text="$(get_msg "enter_package")" --width=400 --height=100)
                remove_package "$package"
                ;;
            "$(get_msg "search")")
                package=$(zenity --entry --title="$(get_msg "search")" --text="$(get_msg "enter_package")" --width=400 --height=100)
                search_package "$package"
                ;;
            "$(get_msg "update")"|"$(get_msg "upgrade")")
                update_packages
                ;;
            "$(get_msg "list")")
                list_packages
                ;;
            "$(get_msg "info")")
                package=$(zenity --entry --title="$(get_msg "info")" --text="$(get_msg "enter_package")" --width=400 --height=100)
                package_info "$package"
                ;;
            "$(get_msg "fix")")
                fix_packages
                ;;
            "$(get_msg "clean")"|"$(get_msg "autoremove")")
                clean_cache
                ;;
            "$(get_msg "back")"|""|*)
                break
                ;;
        esac
    done
}

flatpak_menu() {
    check_flatpak || return
    while true; do
        local choice
        choice=$(zenity --list --title="$(get_msg "flatpak_manager")" --column="" --width=$ZENITY_WIDTH --height=500 \
            "$(get_msg "install_flatpak")" \
            "$(get_msg "remove_flatpak")" \
            "$(get_msg "search_flatpak")" \
            "$(get_msg "update_flatpak")" \
            "$(get_msg "list_flatpak")" \
            "$(get_msg "add_flatpak_repo")" \
            "$(get_msg "back")"
        )
        case "$choice" in
            "$(get_msg "install_flatpak")")
                package=$(zenity --entry --title="$(get_msg "install_flatpak")" --text="$(get_msg "enter_package")" --width=400 --height=100)
                if [[ -n "$package" ]]; then
                    show_terminal_box "$(get_msg "install_flatpak") $package" "flatpak install -y flathub \"$package\""
                fi
                ;;
            "$(get_msg "remove_flatpak")")
                package=$(zenity --entry --title="$(get_msg "remove_flatpak")" --text="$(get_msg "enter_package")" --width=400 --height=100)
                if [[ -n "$package" ]]; then
                    show_terminal_box "$(get_msg "remove_flatpak") $package" "flatpak uninstall -y \"$package\""
                fi
                ;;
            "$(get_msg "search_flatpak")")
                package=$(zenity --entry --title="$(get_msg "search_flatpak")" --text="$(get_msg "enter_package")" --width=400 --height=100)
                if [[ -n "$package" ]]; then
                    show_terminal_box "$(get_msg "search_flatpak") $package" "flatpak search \"$package\""
                fi
                ;;
            "$(get_msg "update_flatpak")")
                show_terminal_box "$(get_msg "update_flatpak")" "flatpak update -y"
                ;;
            "$(get_msg "list_flatpak")")
                show_terminal_box "$(get_msg "list_flatpak")" "flatpak list"
                ;;
            "$(get_msg "add_flatpak_repo")")
                repo=$(zenity --entry --title="$(get_msg "add_flatpak_repo")" --text="$(get_msg "enter_repo")" --width=400 --height=100)
                if [[ -n "$repo" ]]; then
                    show_terminal_box "$(get_msg "add_flatpak_repo")" "flatpak remote-add --if-not-exists custom \"$repo\""
                fi
                ;;
            "$(get_msg "back")"|""|*)
                break
                ;;
        esac
    done
}

snap_menu() {
    check_snap || return
    while true; do
        local choice
        choice=$(zenity --list --title="$(get_msg "snap_manager")" --column="" --width=$ZENITY_WIDTH --height=500 \
            "$(get_msg "install_snap")" \
            "$(get_msg "remove_snap")" \
            "$(get_msg "search_snap")" \
            "$(get_msg "update_snap")" \
            "$(get_msg "list_snap")" \
            "$(get_msg "enable_snap")" \
            "$(get_msg "back")"
        )
        case "$choice" in
            "$(get_msg "install_snap")")
                package=$(zenity --entry --title="$(get_msg "install_snap")" --text="$(get_msg "enter_package")" --width=400 --height=100)
                if [[ -n "$package" ]]; then
                    show_terminal_box "$(get_msg "install_snap") $package" "snap install \"$package\""
                fi
                ;;
            "$(get_msg "remove_snap")")
                package=$(zenity --entry --title="$(get_msg "remove_snap")" --text="$(get_msg "enter_package")" --width=400 --height=100)
                if [[ -n "$package" ]]; then
                    show_terminal_box "$(get_msg "remove_snap") $package" "snap remove \"$package\""
                fi
                ;;
            "$(get_msg "search_snap")")
                package=$(zenity --entry --title="$(get_msg "search_snap")" --text="$(get_msg "enter_package")" --width=400 --height=100)
                if [[ -n "$package" ]]; then
                    show_terminal_box "$(get_msg "search_snap") $package" "snap find \"$package\""
                fi
                ;;
            "$(get_msg "update_snap")")
                show_terminal_box "$(get_msg "update_snap")" "snap refresh"
                ;;
            "$(get_msg "list_snap")")
                show_terminal_box "$(get_msg "list_snap")" "snap list"
                ;;
            "$(get_msg "enable_snap")")
                show_terminal_box "$(get_msg "enable_snap")" "systemctl enable --now snapd.socket"
                ;;
            "$(get_msg "back")"|""|*)
                break
                ;;
        esac
    done
}

system_tools_menu() {
    while true; do
        local choice
        choice=$(zenity --list --title="$(get_msg "system_tools")" --column="" --width=$ZENITY_WIDTH --height=400 \
            "$(get_msg "backup_packages")" \
            "$(get_msg "restore_packages")" \
            "$(get_msg "system_info")" \
            "$(get_msg "disk_usage")" \
            "$(get_msg "back")"
        )
        case "$choice" in
            "$(get_msg "backup_packages")")
                backup_packages
                ;;
            "$(get_msg "restore_packages")")
                restore_packages
                ;;
            "$(get_msg "system_info")")
                show_system_info
                ;;
            "$(get_msg "disk_usage")")
                show_disk_usage
                ;;
            "$(get_msg "back")"|""|*)
                break
                ;;
        esac
    done
}

settings_menu() {
    while true; do
        local choice
        choice=$(zenity --list --title="$(get_msg "settings")" --column="" --width=400 --height=200 \
            "$(get_msg "change_lang")" \
            "$(get_msg "change_theme")" \
            "$(get_msg "about")" \
            "$(get_msg "back")"
        )
        case "$choice" in
            "$(get_msg "change_lang")")
                change_language
                ;;
            "$(get_msg "change_theme")")
                change_theme
                ;;
            "$(get_msg "about")")
                show_about
                ;;
            "$(get_msg "back")"|""|*)
                break
                ;;
        esac
    done
}

main_menu() {
    while true; do
        local choice
        choice=$(zenity --list --title="$(get_msg "main_menu")" --column="" --width=$ZENITY_WIDTH --height=$ZENITY_HEIGHT \
            "$(get_msg "package_manager")" \
            "$(get_msg "flatpak_manager")" \
            "$(get_msg "snap_manager")" \
            "$(get_msg "system_tools")" \
            "$(get_msg "settings")" \
            "$(get_msg "exit")"
        )
        case "$choice" in
            "$(get_msg "package_manager")")
                package_manager_menu
                ;;
            "$(get_msg "flatpak_manager")")
                flatpak_menu
                ;;
            "$(get_msg "snap_manager")")
                snap_menu
                ;;
            "$(get_msg "system_tools")")
                system_tools_menu
                ;;
            "$(get_msg "settings")")
                settings_menu
                ;;
            "$(get_msg "exit")"|""|*)
                zenity --info --text="$(get_msg "exiting")" --title="GT-CLPM" --width=400 --height=100
                exit 0
                ;;
        esac
    done
}

main() {
    main_menu
}

main "$@"
