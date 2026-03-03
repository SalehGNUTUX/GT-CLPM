#!/bin/bash

# GT-CLPM - GNUTUX Command Line Package Manager (Zenity GUI)
# Version: 1.5.0
# License: GPLv2
# Developer: GNUTUX
# Description: Graphical interface for GT-CLPM using Zenity

# ─── اكتشاف الأداة الرسومية (Zenity / KDialog) ────────────────────────────────
APP_NAME_DETECT="GT-CLPM"
UI_FILE="$HOME/.gt-clpm-ui"

detect_ui_tool() {
    # zenity هي الافتراضي لجميع البيئات — kdialog خيار اختياري يُحفظ من الإعدادات فقط
    [[ -f "$UI_FILE" ]] && { cat "$UI_FILE"; return; }
    echo "zenity"
}
UI_TOOL=$(detect_ui_tool)

_show_dep_error() {
    local tool="$1"
    local deps_ar="التبعيات المطلوبة:\n  • ${tool}\n\nأوامر التثبيت:\n  apt install ${tool}\n  dnf install ${tool}\n  pacman -S ${tool}\n  zypper install ${tool}\n  eopkg install ${tool}"
    local deps_en="Required dependencies:\n  • ${tool}\n\nInstall commands:\n  apt install ${tool}\n  dnf install ${tool}\n  pacman -S ${tool}\n  zypper install ${tool}\n  eopkg install ${tool}"
    local err_title="${APP_NAME_DETECT} — خطأ في التبعيات / Dependency Error"
    local err_msg="تعذّر تشغيل أو تثبيت '${tool}'.\n\n${deps_ar}\n\n---\n\nFailed to run or install '${tool}'.\n\n${deps_en}"
    if [[ "$tool" == "zenity" ]] && command -v kdialog &>/dev/null; then
        kdialog --error "$err_msg" --title "$err_title"
    elif [[ "$tool" == "kdialog" ]] && command -v zenity &>/dev/null; then
        zenity --error --title="$err_title" --text="$err_msg" --width=500
    else
        echo "========================================"
        echo "$err_title"
        echo -e "$err_msg"
        echo "========================================"
    fi
}

ensure_ui_installed() {
    local tool="$1"
    command -v "$tool" &>/dev/null && return 0
    if command -v apt &>/dev/null;      then sudo apt install -y "$tool" &>/dev/null
    elif command -v dnf &>/dev/null;    then sudo dnf install -y "$tool" &>/dev/null
    elif command -v pacman &>/dev/null; then sudo pacman -S --noconfirm "$tool" &>/dev/null
    elif command -v zypper &>/dev/null; then sudo zypper install -y "$tool" &>/dev/null
    elif command -v eopkg &>/dev/null;  then sudo eopkg install "$tool" &>/dev/null
    fi
    if ! command -v "$tool" &>/dev/null; then
        _show_dep_error "$tool"
        exit 1
    fi
}

ensure_ui_installed "$UI_TOOL"

# ─── صلاحيات sudo (تُطلب عند الحاجة لكل أمر) ────────────────────────────────
# نستخدم pkexec أولاً (يفتح نافذة رسومية تلقائياً)
# إن لم يكن متوفراً نستخدم SUDO_ASKPASS مع zenity أو kdialog
# show_terminal_box تتولى ذلك تلقائياً

# ─── إعدادات اللغة ────────────────────────────────────────────────────────────
LANG_FILE="$HOME/.gt-clpm-lang"
if [[ -f "$LANG_FILE" ]]; then
    CURRENT_LANG=$(cat "$LANG_FILE")
else
    if [[ $LANG == *"ar"* ]] || [[ $LANGUAGE == *"ar"* ]]; then
        CURRENT_LANG="ar"
    else
        CURRENT_LANG="en"
    fi
    echo "$CURRENT_LANG" > "$LANG_FILE"
fi

# ─── الوضع الداكن / الفاتح ────────────────────────────────────────────────────
MODE_FILE="$HOME/.gt-clpm-mode"
detect_system_dark() {
    # ── KDE / Plasma ──
    for kread in kreadconfig6 kreadconfig5; do
        if command -v "$kread" &>/dev/null; then
            local scheme
            scheme=$("$kread" --group General --key ColorScheme 2>/dev/null || true)
            echo "$scheme" | grep -qi "dark\|breeze-dark\|breezedark" && { echo "dark"; return; }
            break
        fi
    done
    local kdeglobals="$HOME/.config/kdeglobals"
    if [[ -f "$kdeglobals" ]]; then
        grep -q -i "dark" <(grep -i "^ColorScheme=" "$kdeglobals" 2>/dev/null) 2>/dev/null && { echo "dark"; return; }
    fi

    # ── GNOME / GTK via gsettings ──
    if command -v gsettings &>/dev/null; then
        local cs; cs=$(gsettings get org.gnome.desktop.interface color-scheme 2>/dev/null || true)
        echo "$cs" | grep -qi "dark" && { echo "dark"; return; }
        local gtheme; gtheme=$(gsettings get org.gnome.desktop.interface gtk-theme 2>/dev/null || true)
        echo "$gtheme" | grep -qi "dark" && { echo "dark"; return; }
    fi

    # ── GTK config files ──
    local g3="$HOME/.config/gtk-3.0/settings.ini"
    local g4="$HOME/.config/gtk-4.0/settings.ini"
    if grep -q "gtk-application-prefer-dark-theme=1" "$g3" 2>/dev/null ||
       grep -q "gtk-application-prefer-dark-theme=1" "$g4" 2>/dev/null ||
       grep -q "color-scheme=prefer-dark"            "$g3" 2>/dev/null ||
       grep -q "color-scheme=prefer-dark"            "$g4" 2>/dev/null; then
        echo "dark"; return
    fi

    echo "light"
}
[[ -f "$MODE_FILE" ]] && CURRENT_MODE=$(cat "$MODE_FILE") \
                      || CURRENT_MODE=$(detect_system_dark)

set_zenity_env() {
    if [[ "$CURRENT_MODE" == "dark" ]]; then
        export GTK_THEME="Adwaita:dark"
    else
        export GTK_THEME="Adwaita:light"
    fi
}
set_zenity_env

# ─── شيم zenity → kdialog (يُفعَّل تلقائياً عند اختيار KDialog) ────────────
# يعترض جميع استدعاءات zenity في الكود ويُترجمها إلى kdialog
if [[ "$UI_TOOL" == "kdialog" ]]; then
zenity() {
    local mode="" title="GT-CLPM" text="" filename="" width=400 height=300
    local ok_label="OK" entry_text="" pulsate=false
    local -a columns=() hide_cols=() items=()

    while [[ $# -gt 0 ]]; do
        case "$1" in
            --info)       mode="info" ;;
            --error)      mode="error" ;;
            --warning)    mode="warning" ;;
            --question)   mode="question" ;;
            --entry)      mode="entry" ;;
            --password)   mode="password" ;;
            --list)       mode="list" ;;
            --text-info)  mode="text-info" ;;
            --progress)   mode="progress" ;;
            --title=*)    title="${1#--title=}" ;;
            --title)      title="$2"; shift ;;
            --text=*)     text="${1#--text=}" ;;
            --text)       text="$2"; shift ;;
            --filename=*) filename="${1#--filename=}" ;;
            --filename)   filename="$2"; shift ;;
            --width=*)    width="${1#--width=}" ;;
            --width)      width="$2"; shift ;;
            --height=*)   height="${1#--height=}" ;;
            --height)     height="$2"; shift ;;
            --column=*)   columns+=("${1#--column=}") ;;
            --column)     columns+=("$2"); shift ;;
            --hide-column=*) hide_cols+=("${1#--hide-column=}") ;;
            --hide-column)   hide_cols+=("$2"); shift ;;
            --ok-label=*) ok_label="${1#--ok-label=}" ;;
            --ok-label)   ok_label="$2"; shift ;;
            --entry-text=*) entry_text="${1#--entry-text=}" ;;
            --entry-text)   entry_text="$2"; shift ;;
            --pulsate|--auto-close|--no-cancel) ;;
            --*) ;;
            *) items+=("$1") ;;
        esac
        shift
    done

    case "$mode" in
        info)     kdialog --msgbox "$text" --title "$title"; return $? ;;
        error)    kdialog --error "$text" --title "$title"; return $? ;;
        warning)  kdialog --sorry "$text" --title "$title"; return $? ;;
        question) kdialog --yesno "$text" --title "$title"; return $? ;;
        password) kdialog --password "" --title "$title"; return $? ;;
        entry)
            local result
            result=$(kdialog --inputbox "$text" "${entry_text}" --title "$title")
            local ret=$?; echo "$result"; return $ret ;;
        text-info)
            kdialog --textbox "$filename" "$width" "$height" --title "$title"
            return $? ;;
        progress)
            # استنزاف stdin حتى الانتهاء (kdialog لا يحتاج تغذية stdin)
            while IFS= read -r line; do [[ "$line" == "100" ]] && break; done
            return 0 ;;
        list)
            local ncols=${#columns[@]}
            [[ $ncols -eq 0 ]] && ncols=1
            local -a menu_args=()

            if [[ $ncols -eq 1 ]]; then
                # قائمة عمود واحد — radiolist يسمح بالتأكيد بـ Enter مباشرة
                local i=0
                for item in "${items[@]}"; do
                    # الحالة: false (غير محدد مبدئياً)
                    menu_args+=("$item" "$item" "false")
                    ((i++))
                done
                local sel
                sel=$(kdialog --radiolist "$title" "${menu_args[@]}" --title "$title" 2>/dev/null)
                local ret=$?; [[ $ret -ne 0 || -z "$sel" ]] && return 1
                echo "$sel"

            elif [[ $ncols -ge 3 && ${#hide_cols[@]} -gt 0 ]]; then
                # عدة أعمدة مع عمود مخفي (بحث flatpak وغيره)
                local hcol="${hide_cols[0]}"
                local j=0
                while [[ $j -lt ${#items[@]} ]]; do
                    local tag="${items[$((j + hcol - 1))]}"
                    local label="${items[$j]} — ${items[$((j+1))]:-}"
                    menu_args+=("$tag" "$label" "false")
                    ((j += ncols))
                done
                local sel
                sel=$(kdialog --radiolist "$title" "${menu_args[@]}" --title "$title" 2>/dev/null)
                local ret=$?; [[ $ret -ne 0 || -z "$sel" ]] && return 1
                echo "$sel"

            else
                # عمودان: العمود الأول tag والثاني description
                local i=0
                while [[ $i -lt ${#items[@]} ]]; do
                    menu_args+=("${items[$i]}" "${items[$((i+1))]:-}" "false")
                    ((i += ncols))
                done
                local sel
                sel=$(kdialog --radiolist "$title" "${menu_args[@]}" --title "$title" 2>/dev/null)
                local ret=$?; [[ $ret -ne 0 || -z "$sel" ]] && return 1
                echo "$sel"
            fi ;;
    esac
}
fi
# ─────────────────────────────────────────────────────────────────────────────

# ─── مصفوفات الرسائل ──────────────────────────────────────────────────────────
declare -A MESSAGES_EN=(
    ["title"]="GT-CLPM - GNUTUX Command Line Package Manager"
    ["version"]="Version 1.5.0 - GPLv2 License - Developed by GNUTUX"
    ["main_menu"]="🏠 Main Menu"
    ["package_manager"]="📦 Package Manager"
    ["flatpak_manager"]="📦 Flatpak Manager"
    ["snap_manager"]="📦 Snap Manager"
    ["other_installers"]="🛠️ Other Installers (Language Tools)"
    ["system_tools"]="🖥️ System Tools"
    ["settings"]="⚙️ Settings"
    ["exit"]="🚪 Exit"
    ["install"]="➕ Install package"
    ["remove"]="➖ Remove package"
    ["smart_remove"]="🗑️ Smart Remove"
    ["search"]="🔍 Search for package"
    ["search_apps"]="🔍 Search applications"
    ["search_all"]="🔍 Search all packages"
    ["update"]="🔄 Update system packages"
    ["upgrade"]="⬆️ Upgrade system packages"
    ["list"]="📋 List installed packages"
    ["info"]="ℹ️ Package information"
    ["fix"]="🔧 Fix broken packages"
    ["clean"]="🧹 Clean cache / Autoremove"
    ["add_repo"]="🗂️ Manage repositories"
    ["install_flatpak"]="➕ Install Flatpak package"
    ["remove_flatpak"]="➖ Remove Flatpak package"
    ["smart_remove_flatpak"]="🗑️ Smart Remove Flatpak"
    ["search_flatpak"]="🔍 Search Flatpak packages"
    ["update_flatpak"]="🔄 Update Flatpak packages"
    ["list_flatpak"]="📋 List Flatpak packages"
    ["add_flatpak_repo"]="➕ Add Flatpak repository"
    ["refresh_flathub"]="🔃 Refresh Flathub"
    ["install_snap"]="➕ Install Snap package"
    ["remove_snap"]="➖ Remove Snap package"
    ["smart_remove_snap"]="🗑️ Smart Remove Snap"
    ["search_snap"]="🔍 Search Snap packages"
    ["update_snap"]="🔄 Update Snap packages"
    ["list_snap"]="📋 List Snap packages"
    ["enable_snap"]="▶️ Enable Snap service"
    ["python_tools"]="🐍 Python Tools (pip/pipx/venv)"
    ["nodejs_tools"]="🟩 Node.js Tools (npm/yarn/pnpm)"
    ["ruby_tools"]="💎 Ruby Tools (gem/bundler)"
    ["rust_tools"]="🦀 Rust Tools (cargo/rustup)"
    ["go_tools"]="🐹 Go Tools (go install)"
    ["java_tools"]="☕ Java Tools (maven/gradle/sdkman)"
    ["php_tools"]="🐘 PHP Tools (composer)"
    ["haskell_tools"]="λ Haskell Tools (cabal/stack/ghcup)"
    ["scientific_tools"]="🔬 Scientific Tools (Spack/Conda/Mamba)"
    ["backup_packages"]="💾 Backup package list"
    ["restore_packages"]="📥 Restore packages from backup"
    ["system_info"]="🖥️ Show system information"
    ["disk_usage"]="💽 Show disk usage"
    ["change_lang"]="🌐 Change language"
    ["change_theme"]="🎨 Change theme (Light/Dark)"
    ["about"]="ℹ️ About GT-CLPM"
    ["back"]="◀️ Back"
    ["detected"]="Detected package manager:"
    ["not_found"]="Package manager not found"
    ["no_package"]="No package name provided"
    ["installing"]="⏳ Installing"
    ["removing"]="🗑️ Removing"
    ["searching"]="🔍 Searching for"
    ["updating"]="🔄 Updating system packages..."
    ["fixing"]="🔧 Fixing broken packages..."
    ["listing"]="📋 Listing installed packages..."
    ["cleaning"]="🧹 Cleaning package cache..."
    ["error"]="❌ Error:"
    ["success"]="✅ Success:"
    ["warning"]="⚠️ Warning:"
    ["invalid_option"]="Invalid option"
    ["lang_changed"]="🌐 Language changed to English"
    ["theme_changed"]="🎨 Theme changed"
    ["flatpak_not_installed"]="Flatpak is not installed. Install it?"
    ["snap_not_installed"]="Snap is not installed. Install it?"
    ["enter_package"]="Enter package name:"
    ["enter_appid"]="Enter Application ID (e.g. org.videolan.VLC):"
    ["enter_choice"]="Choose an operation:"
    ["operation_completed"]="✅ Operation completed"
    ["press_ok"]="OK"
    ["enter_repo"]="Enter repository URL:"
    ["backup_created"]="💾 Package list backup created"
    ["restore_completed"]="✅ Package restoration completed"
    ["exiting"]="👋 Exiting GT-CLPM... Goodbye!"
    ["terminal_output"]="Terminal output (live)"
    ["installed"]="✅ [installed]"
    ["search_results"]="🔍 Search Results"
    ["no_results"]="❌ No results found"
    ["confirm_remove"]="Remove package?"
    ["confirm_install"]="Install?"
    ["package_removed"]="✅ Package removed successfully"
    ["removal_cancelled"]="Removal cancelled"
    ["not_installed_auto"]="not found. Install it? (y/N)"
    ["dependency_ok"]="✅ Dependencies OK:"
    ["manual_entry"]="⌨️ Manual entry"
    ["browse_packages"]="📋 Browse installed packages"
    ["select_to_remove"]="Select a package to remove:"
    ["select_to_install"]="Select a package to install:"
    ["change_ui_tool"]="🖼️ Change UI tool (Zenity / KDialog)"
    ["ui_tool_changed"]="✅ UI tool changed. Restart to apply."
    ["check_update"]="🔄 Check for updates"
    ["uninstall_app"]="🗑️ Uninstall GT-CLPM GUI"
    ["update_available"]="🎉 Update available!"
    ["no_update"]="✅ You are on the latest version."
    ["update_now"]="Update now"
    ["remind_later"]="Remind me later"
    ["update_error"]="Could not check for updates. Check your connection."
    ["uninstall_confirm"]="Are you sure you want to uninstall GT-CLPM GUI?"
    ["uninstaller_missing"]="Uninstaller not found locally. Download it?"
)


declare -A MESSAGES_AR=(
    ["title"]="GT-CLPM - مدير حزم سطر الأوامر من جنوتكس"
    ["version"]="الإصدار 1.5.0 - رخصة GPLv2 - من تطوير GNUTUX"
    ["main_menu"]="🏠 القائمة الرئيسية"
    ["package_manager"]="📦 مدير الحزم"
    ["flatpak_manager"]="📦 مدير فلاتباك"
    ["snap_manager"]="📦 مدير سناب"
    ["other_installers"]="🛠️ طرق تثبيت أخرى (أدوات اللغات)"
    ["system_tools"]="🖥️ أدوات النظام"
    ["settings"]="⚙️ الإعدادات"
    ["exit"]="🚪 خروج"
    ["install"]="➕ تثبيت حزمة"
    ["remove"]="➖ إزالة حزمة"
    ["smart_remove"]="🗑️ إزالة ذكية"
    ["search"]="🔍 البحث عن حزمة"
    ["search_apps"]="🔍 البحث عن تطبيقات"
    ["search_all"]="🔍 البحث في كل الحزم"
    ["update"]="🔄 تحديث حزم النظام"
    ["upgrade"]="⬆️ ترقية حزم النظام"
    ["list"]="📋 عرض الحزم المثبتة"
    ["info"]="ℹ️ معلومات الحزمة"
    ["fix"]="🔧 إصلاح الحزم المعطلة"
    ["clean"]="🧹 تنظيف الذاكرة المؤقتة / إزالة الأيتام"
    ["add_repo"]="🗂️ إدارة المستودعات"
    ["install_flatpak"]="➕ تثبيت حزمة فلاتباك"
    ["remove_flatpak"]="➖ إزالة حزمة فلاتباك"
    ["smart_remove_flatpak"]="🗑️ إزالة ذكية - فلاتباك"
    ["search_flatpak"]="🔍 البحث في حزم فلاتباك"
    ["update_flatpak"]="🔄 تحديث حزم فلاتباك"
    ["list_flatpak"]="📋 عرض حزم فلاتباك"
    ["add_flatpak_repo"]="➕ إضافة مستودع فلاتباك"
    ["refresh_flathub"]="🔃 تحديث مستودع Flathub"
    ["install_snap"]="➕ تثبيت حزمة سناب"
    ["remove_snap"]="➖ إزالة حزمة سناب"
    ["smart_remove_snap"]="🗑️ إزالة ذكية - سناب"
    ["search_snap"]="🔍 البحث في حزم سناب"
    ["update_snap"]="🔄 تحديث حزم سناب"
    ["list_snap"]="📋 عرض حزم سناب"
    ["enable_snap"]="▶️ تفعيل خدمة سناب"
    ["python_tools"]="🐍 أدوات Python (pip/pipx/venv)"
    ["nodejs_tools"]="🟩 أدوات Node.js (npm/yarn/pnpm)"
    ["ruby_tools"]="💎 أدوات Ruby (gem/bundler)"
    ["rust_tools"]="🦀 أدوات Rust (cargo/rustup)"
    ["go_tools"]="🐹 أدوات Go (go install)"
    ["java_tools"]="☕ أدوات Java (maven/gradle/sdkman)"
    ["php_tools"]="🐘 أدوات PHP (composer)"
    ["haskell_tools"]="λ أدوات Haskell (cabal/stack/ghcup)"
    ["scientific_tools"]="🔬 أدوات علمية (Spack/Conda/Mamba)"
    ["backup_packages"]="💾 نسخ احتياطي لقائمة الحزم"
    ["restore_packages"]="📥 استعادة الحزم من النسخ الاحتياطي"
    ["system_info"]="🖥️ عرض معلومات النظام"
    ["disk_usage"]="💽 عرض استخدام القرص"
    ["change_lang"]="🌐 تغيير اللغة"
    ["change_theme"]="🎨 تغيير النمط (فاتح/داكن)"
    ["about"]="ℹ️ حول البرنامج"
    ["back"]="◀️ رجوع"
    ["detected"]="مدير الحزم المكتشف:"
    ["not_found"]="مدير الحزم غير موجود"
    ["no_package"]="لم يتم توفير اسم الحزمة"
    ["installing"]="⏳ جاري التثبيت"
    ["removing"]="🗑️ جاري الإزالة"
    ["searching"]="🔍 البحث عن"
    ["updating"]="🔄 جاري تحديث حزم النظام..."
    ["fixing"]="🔧 جاري إصلاح الحزم المعطلة..."
    ["listing"]="📋 جاري عرض الحزم المثبتة..."
    ["cleaning"]="🧹 جاري التنظيف..."
    ["error"]="❌ خطأ:"
    ["success"]="✅ نجح:"
    ["warning"]="⚠️ تحذير:"
    ["invalid_option"]="خيار غير صحيح"
    ["lang_changed"]="🌐 تم تغيير اللغة إلى العربية"
    ["theme_changed"]="🎨 تم تغيير النمط"
    ["flatpak_not_installed"]="فلاتباك غير مثبت. هل تريد تثبيته؟"
    ["snap_not_installed"]="سناب غير مثبت. هل تريد تثبيته؟"
    ["enter_package"]="أدخل اسم الحزمة:"
    ["enter_appid"]="أدخل معرّف التطبيق (مثال: org.videolan.VLC):"
    ["enter_choice"]="اختر العملية:"
    ["operation_completed"]="✅ تمت العملية"
    ["press_ok"]="موافق"
    ["enter_repo"]="أدخل رابط المستودع:"
    ["backup_created"]="💾 تم إنشاء نسخة احتياطية"
    ["restore_completed"]="✅ تم استعادة الحزم"
    ["exiting"]="👋 جاري الخروج... وداعاً!"
    ["terminal_output"]="مخرجات الطرفية (مباشر)"
    ["installed"]="✅ [مثبت]"
    ["search_results"]="🔍 نتائج البحث"
    ["no_results"]="❌ لا توجد نتائج"
    ["confirm_remove"]="إزالة الحزمة؟"
    ["confirm_install"]="تثبيت؟"
    ["package_removed"]="✅ تمت إزالة الحزمة بنجاح"
    ["removal_cancelled"]="تم إلغاء الإزالة"
    ["not_installed_auto"]="غير مثبت. هل تريد تثبيته؟ (y/N)"
    ["dependency_ok"]="✅ المتطلبات متوفرة:"
    ["manual_entry"]="⌨️ إدخال يدوي"
    ["browse_packages"]="📋 تصفح الحزم المثبتة"
    ["select_to_remove"]="اختر حزمة للإزالة:"
    ["select_to_install"]="اختر حزمة للتثبيت:"
    ["change_ui_tool"]="🖼️ تغيير أداة الواجهة (Zenity / KDialog)"
    ["ui_tool_changed"]="✅ تم تغيير أداة الواجهة. أعد التشغيل لتطبيق التغيير."
    ["check_update"]="🔄 فحص التحديثات"
    ["uninstall_app"]="🗑️ إلغاء تثبيت GT-CLPM GUI"
    ["update_available"]="🎉 يوجد تحديث متاح!"
    ["no_update"]="✅ أنت تستخدم أحدث إصدار."
    ["update_now"]="تحديث الآن"
    ["remind_later"]="تذكيري لاحقاً"
    ["update_error"]="تعذّر الاتصال. تحقق من الإنترنت."
    ["uninstall_confirm"]="هل أنت متأكد من إلغاء تثبيت GT-CLPM GUI؟"
    ["uninstaller_missing"]="ملف إلغاء التثبيت غير موجود. هل تريد تنزيله؟"
)


get_msg() { echo "${MESSAGES_EN[$1]}"; [[ "$CURRENT_LANG" == "ar" ]] && echo "${MESSAGES_AR[$1]}" || echo "${MESSAGES_EN[$1]}"; }
get_msg() {
    local key="$1"
    if [[ "$CURRENT_LANG" == "ar" ]]; then
        echo "${MESSAGES_AR[$key]:-${MESSAGES_EN[$key]}}"
    else
        echo "${MESSAGES_EN[$key]}"
    fi
}

ZENITY_W=900
ZENITY_H=700

# ─── تنفيذ أمر بصلاحيات root مع نافذة كلمة مرور رسومية ──────────────────────
_run_root() {
    local cmd="$1"

    # الأولوية الأولى: pkexec
    if command -v pkexec &>/dev/null; then
        pkexec bash -c "$cmd"
        return $?
    fi

    # الأولوية الثانية: SUDO_ASKPASS مع zenity أو kdialog
    local askpass
    askpass=$(mktemp /tmp/gt-clpm-askpass-XXXXXX.sh)
    chmod 700 "$askpass"

    if [[ "$UI_TOOL" == "kdialog" ]]; then
        printf '#!/bin/bash\nkdialog --password "" --title "GT-CLPM — صلاحيات المدير"\n' > "$askpass"
    else
        printf '#!/bin/bash\nzenity --password --title="GT-CLPM — صلاحيات المدير"\n' > "$askpass"
    fi

    SUDO_ASKPASS="$askpass" sudo -A bash -c "$cmd"
    local ret=$?
    rm -f "$askpass"
    return $ret
}

# ─── واجهة الطرفية المدمجة ────────────────────────────────────────────────────
# تشغيل أمر في طرفية حقيقية مع عرض شريط تقدم ثم النتيجة
show_terminal_box() {
    local title="$1"
    local cmd="$2"
    local tmpfile
    tmpfile=$(mktemp /tmp/gtclpm-out.XXXXXX)

    # تنفيذ الأمر وتسجيل المخرجات
    _run_root "$cmd" > "$tmpfile" 2>&1 &
    local pid=$!

    if [[ "$UI_TOOL" == "kdialog" ]]; then
        # ── kdialog: شريط تقدم حقيقي عبر DBus ──────────────────────────────
        local dbus_ref dbus_service dbus_path
        dbus_ref=$(kdialog --progressbar "$(get_msg "terminal_output")..." 0 --title "$title" 2>/dev/null)
        if [[ -n "$dbus_ref" ]]; then
            dbus_service=$(echo "$dbus_ref" | awk '{print $1}')
            dbus_path=$(echo    "$dbus_ref" | awk '{print $2}')
            # إخفاء زر الإلغاء
            qdbus "$dbus_service" "$dbus_path" showCancelButton false 2>/dev/null
            # تحديث النص بآخر سطر مخرجات كل 0.4 ثانية
            while kill -0 "$pid" 2>/dev/null; do
                local last_line
                last_line=$(tail -n 1 "$tmpfile" 2>/dev/null | tr -d '\r')
                [[ -n "$last_line" ]] && \
                    qdbus "$dbus_service" "$dbus_path" setLabelText "$last_line" 2>/dev/null
                sleep 0.4
            done
            qdbus "$dbus_service" "$dbus_path" close 2>/dev/null
        else
            # احتياط: إن لم يدعم kdialog --progressbar
            wait "$pid"
        fi
    else
        # ── zenity: شريط تقدم نابض ───────────────────────────────────────────
        (
            while kill -0 "$pid" 2>/dev/null; do
                echo "# $(tail -n 1 "$tmpfile" 2>/dev/null)"
                sleep 0.4
            done
            echo "100"
        ) | zenity --progress \
            --title="$title" \
            --text="$(get_msg "terminal_output")..." \
            --pulsate --auto-close --no-cancel \
            --width=$ZENITY_W --height=120
    fi

    wait "$pid"
    local exit_code=$?

    # عرض المخرجات الكاملة
    zenity --text-info \
        --title="$title — $(get_msg "terminal_output")" \
        --filename="$tmpfile" \
        --width=$ZENITY_W --height=500 \
        --ok-label="$(get_msg "press_ok")"

    rm -f "$tmpfile"
    return $exit_code
}

# تشغيل أمر وإرجاع مخرجاته كنص (بدون نافذة)
run_silent() {
    bash -c "$1" 2>/dev/null
}

# ─── اكتشاف مدير الحزم ───────────────────────────────────────────────────────
detect_package_manager() {
    if command -v apt      &>/dev/null; then echo "apt"
    elif command -v dnf    &>/dev/null; then echo "dnf"
    elif command -v yum    &>/dev/null; then echo "yum"
    elif command -v pacman &>/dev/null; then echo "pacman"
    elif command -v zypper &>/dev/null; then echo "zypper"
    elif command -v eopkg  &>/dev/null; then echo "eopkg"
    elif command -v xbps-install &>/dev/null; then echo "xbps"
    elif command -v emerge &>/dev/null; then echo "emerge"
    elif command -v apk    &>/dev/null; then echo "apk"
    elif command -v nix-env &>/dev/null; then echo "nix"
    elif command -v brew   &>/dev/null; then echo "brew"
    elif command -v pkg    &>/dev/null; then echo "pkg"
    else echo "unknown"; fi
}

# ─── عمليات الحزم الأساسية ───────────────────────────────────────────────────
install_package() {
    local package="$1"
    local pm; pm=$(detect_package_manager)
    [[ -z "$package" ]] && return 1
    local cmd
    case $pm in
        apt)    cmd="apt update && apt install -y \"$package\"" ;;
        dnf)    cmd="dnf install -y \"$package\"" ;;
        yum)    cmd="yum install -y \"$package\"" ;;
        pacman) cmd="pacman -S --noconfirm \"$package\"" ;;
        zypper) cmd="zypper install -y \"$package\"" ;;
        eopkg)  cmd="eopkg install \"$package\"" ;;
        xbps)   cmd="xbps-install -S \"$package\"" ;;
        emerge) cmd="emerge \"$package\"" ;;
        apk)    cmd="apk add \"$package\"" ;;
        nix)    cmd="nix-env -i \"$package\"" ;;
        brew)   cmd="brew install \"$package\"" ;;
        pkg)    cmd="pkg install -y \"$package\"" ;;
        *)
            zenity --error --title="GT-CLPM" \
                --text="$(get_msg "error") $(get_msg "not_found")" --width=400
            return 1 ;;
    esac
    show_terminal_box "$(get_msg "installing") $package" "$cmd"
}

remove_package() {
    local package="$1"
    local pm; pm=$(detect_package_manager)
    [[ -z "$package" ]] && return 1
    local cmd
    case $pm in
        apt)    cmd="apt remove -y \"$package\"" ;;
        dnf)    cmd="dnf remove -y \"$package\"" ;;
        yum)    cmd="yum remove -y \"$package\"" ;;
        pacman) cmd="pacman -R --noconfirm \"$package\"" ;;
        zypper) cmd="zypper remove -y \"$package\"" ;;
        eopkg)  cmd="eopkg remove \"$package\"" ;;
        xbps)   cmd="xbps-remove \"$package\"" ;;
        emerge) cmd="emerge --unmerge \"$package\"" ;;
        apk)    cmd="apk del \"$package\"" ;;
        nix)    cmd="nix-env -e \"$package\"" ;;
        brew)   cmd="brew uninstall \"$package\"" ;;
        pkg)    cmd="pkg delete -y \"$package\"" ;;
        *)
            zenity --error --title="GT-CLPM" \
                --text="$(get_msg "error") $(get_msg "not_found")" --width=400
            return 1 ;;
    esac
    show_terminal_box "$(get_msg "removing") $package" "$cmd"
}

update_packages() {
    local pm; pm=$(detect_package_manager)
    local cmd
    case $pm in
        apt)    cmd="apt update && apt upgrade -y" ;;
        dnf)    cmd="dnf update -y" ;;
        yum)    cmd="yum update -y" ;;
        pacman) cmd="pacman -Syu --noconfirm" ;;
        zypper) cmd="zypper update -y" ;;
        eopkg)  cmd="eopkg upgrade" ;;
        xbps)   cmd="xbps-install -Su" ;;
        emerge) cmd="emerge --sync && emerge -uDN @world" ;;
        apk)    cmd="apk update && apk upgrade" ;;
        nix)    cmd="nix-channel --update && nix-env -u" ;;
        brew)   cmd="brew update && brew upgrade" ;;
        pkg)    cmd="pkg update && pkg upgrade -y" ;;
        *) zenity --error --title="GT-CLPM" --text="$(get_msg "error") $(get_msg "not_found")" --width=400; return 1 ;;
    esac
    show_terminal_box "$(get_msg "updating")" "$cmd"
}

dist_upgrade_packages() {
    local pm; pm=$(detect_package_manager)
    local cmd
    case $pm in
        apt)    cmd="apt update && apt dist-upgrade -y" ;;
        dnf)    cmd="dnf distro-sync -y" ;;
        yum)    cmd="yum distro-sync -y" ;;
        pacman) cmd="pacman -Syyu --noconfirm" ;;
        zypper) cmd="zypper dup -y" ;;
        *)
            if [[ "$CURRENT_LANG" == "ar" ]]; then
                zenity --info --title="GT-CLPM" \
                    --text="هذا الإجراء غير متاح في مدير الحزم: $pm" --width=400
            else
                zenity --info --title="GT-CLPM" \
                    --text="This action is not available for package manager: $pm" --width=400
            fi
            return ;;
    esac
    if [[ "$CURRENT_LANG" == "ar" ]]; then
        show_terminal_box "ترقية شاملة للنظام (Dist Upgrade)" "$cmd"
    else
        show_terminal_box "Full System Upgrade (Dist Upgrade)" "$cmd"
    fi
}

update_submenu() {
    local choice
    if [[ "$CURRENT_LANG" == "ar" ]]; then
        choice=$(zenity --list \
            --title="$(get_msg "update") — $(detect_package_manager)" \
            --column="" \
            --width=500 --height=220 \
            "تحديث النظام (upgrade)" \
            "ترقية شاملة للنظام (dist-upgrade)" \
            "$(get_msg "back")" 2>/dev/null)
        case "$choice" in
            "تحديث النظام"*) update_packages ;;
            "ترقية شاملة"*)  dist_upgrade_packages ;;
        esac
    else
        choice=$(zenity --list \
            --title="$(get_msg "update") — $(detect_package_manager)" \
            --column="" \
            --width=500 --height=220 \
            "Update system (upgrade)" \
            "Full system upgrade (dist-upgrade)" \
            "$(get_msg "back")" 2>/dev/null)
        case "$choice" in
            "Update system"*) update_packages ;;
            "Full system"*)   dist_upgrade_packages ;;
        esac
    fi
}

fix_packages() {
    local pm; pm=$(detect_package_manager)
    local cmd
    case $pm in
        apt)    cmd="apt update && apt --fix-broken install -y && dpkg --configure -a" ;;
        dnf)    cmd="dnf check && dnf autoremove -y" ;;
        yum)    cmd="yum check && yum autoremove -y" ;;
        pacman) cmd="pacman -Dk && pacman -Sc --noconfirm" ;;
        zypper) cmd="zypper verify && zypper clean -a" ;;
        eopkg)  cmd="eopkg check" ;;
        xbps)   cmd="xbps-pkgdb -a && xbps-remove -Oo" ;;
        emerge) cmd="emerge --depclean && revdep-rebuild" ;;
        apk)    cmd="apk fix && apk cache clean" ;;
        nix)    cmd="nix-collect-garbage -d" ;;
        brew)   cmd="brew doctor" ;;
        pkg)    cmd="pkg check -d && pkg autoremove" ;;
        *) zenity --error --title="GT-CLPM" --text="$(get_msg "error") $(get_msg "not_found")" --width=400; return 1 ;;
    esac
    show_terminal_box "$(get_msg "fixing")" "$cmd"
}

list_packages() {
    local pm; pm=$(detect_package_manager)
    local cmd
    case $pm in
        apt)        cmd="dpkg -l | grep ^ii" ;;
        dnf|yum)    cmd="$pm list installed" ;;
        pacman)     cmd="pacman -Q" ;;
        zypper)     cmd="zypper search -i" ;;
        eopkg)      cmd="eopkg list-installed" ;;
        xbps)       cmd="xbps-query -l" ;;
        emerge)     cmd="qlist -I" ;;
        apk)        cmd="apk info" ;;
        nix)        cmd="nix-env -q" ;;
        brew)       cmd="brew list" ;;
        pkg)        cmd="pkg info" ;;
        *) zenity --error --title="GT-CLPM" --text="$(get_msg "error") $(get_msg "not_found")" --width=400; return 1 ;;
    esac
    show_terminal_box "$(get_msg "listing")" "$cmd"
}

package_info() {
    local package="$1"
    [[ -z "$package" ]] && return 1
    local pm; pm=$(detect_package_manager)
    local cmd
    case $pm in
        apt)        cmd="apt show \"$package\"" ;;
        dnf|yum)    cmd="$pm info \"$package\"" ;;
        pacman)     cmd="pacman -Si \"$package\"" ;;
        zypper)     cmd="zypper info \"$package\"" ;;
        eopkg)      cmd="eopkg info \"$package\"" ;;
        xbps)       cmd="xbps-query -R \"$package\"" ;;
        emerge)     cmd="emerge --info \"$package\"" ;;
        apk)        cmd="apk info -a \"$package\"" ;;
        nix)        cmd="nix-env -qa --description | grep \"$package\"" ;;
        brew)       cmd="brew info \"$package\"" ;;
        pkg)        cmd="pkg info \"$package\"" ;;
        *) zenity --error --title="GT-CLPM" --text="$(get_msg "error") $(get_msg "not_found")" --width=400; return 1 ;;
    esac
    show_terminal_box "$(get_msg "info") $package" "$cmd"
}

clean_cache() {
    local pm; pm=$(detect_package_manager)
    local cmd
    case $pm in
        apt)    cmd="apt autoclean && apt autoremove -y" ;;
        dnf)    cmd="dnf clean all && dnf autoremove -y" ;;
        yum)    cmd="yum clean all && yum autoremove -y" ;;
        pacman) cmd="pacman -Sc --noconfirm; orphans=\$(pacman -Qtdq 2>/dev/null); [ -n \"\$orphans\" ] && pacman -Rns \$orphans --noconfirm || true" ;;
        zypper) cmd="zypper clean -a" ;;
        eopkg)  cmd="eopkg delete-cache" ;;
        xbps)   cmd="xbps-remove -Oo" ;;
        emerge) cmd="emerge --depclean && eclean distfiles" ;;
        apk)    cmd="apk cache clean" ;;
        nix)    cmd="nix-collect-garbage -d" ;;
        brew)   cmd="brew cleanup" ;;
        pkg)    cmd="pkg clean && pkg autoremove" ;;
        *) zenity --error --title="GT-CLPM" --text="$(get_msg "error") $(get_msg "not_found")" --width=400; return 1 ;;
    esac
    show_terminal_box "$(get_msg "cleaning")" "$cmd"
}

# ─── التحقق من صحة معرّف Flatpak ─────────────────────────────────────────────
_valid_flatpak_id() {
    local id="$1"
    id=$(echo "$id" | sed 's/\x1b\[[0-9;]*m//g; s/[[:space:]]//g')
    [[ "$id" =~ ^[A-Za-z][A-Za-z0-9_-]*(\.[A-Za-z][A-Za-z0-9_-]*){1,}$ ]] || return 1
    echo "$id"
}

# ─── البحث في Flatpak وعرض نتائج قابلة للاختيار والتثبيت ──────────────────────
search_and_install_flatpak() {
    local query="$1"
    [[ -z "$query" ]] && return 1

    # شريط تقدم أثناء البحث
    local tmpraw; tmpraw=$(mktemp /tmp/gtclpm-fk-raw.XXXXXX)
    (
        flatpak search --columns=name,description,application,version,branch,remotes \
            "$query" 2>/dev/null | tail -n +2
    ) > "$tmpraw" &
    local spid=$!
    (
        while kill -0 "$spid" 2>/dev/null; do echo "10"; sleep 0.3; done
        echo "100"
    ) | zenity --progress --title="🔍 Flatpak" \
        --text="$(get_msg "searching") $query ..." \
        --pulsate --auto-close --no-cancel --width=400 --height=80
    wait "$spid"

    # ── تحليل المخرجات ────────────────────────────────────────────────────────
    local -a app_ids=() disp_names=() disp_descs=()
    local SKIP_PAT='\.Sdk$|\.Sdk\.[0-9]|\.Platform$|\.Platform\.[0-9]|BaseApp|\.Locale$|\.Debug$|Sources$'

    while IFS=$'\t' read -r name desc app_id version branch remotes; do
        name=$(echo "$name"     | sed 's/^[[:space:]]*//; s/[[:space:]]*$//; s/\x1b\[[0-9;]*m//g')
        app_id=$(echo "$app_id" | sed 's/^[[:space:]]*//; s/[[:space:]]*$//; s/\x1b\[[0-9;]*m//g')
        desc=$(echo "$desc"     | sed 's/^[[:space:]]*//; s/[[:space:]]*$//; s/\x1b\[[0-9;]*m//g')
        branch=$(echo "$branch" | sed 's/^[[:space:]]*//; s/[[:space:]]*$//')
        remotes=$(echo "$remotes"| sed 's/^[[:space:]]*//; s/[[:space:]]*$//')

        [[ -z "$app_id" || "$app_id" == "Application" || "$app_id" == "Application ID" ]] && continue
        [[ "$name" == "Name" ]] && continue

        local clean_id
        clean_id=$(_valid_flatpak_id "$app_id") || continue
        [[ $clean_id =~ $SKIP_PAT ]] && continue

        local mark=""
        flatpak list --app --columns=application 2>/dev/null | grep -qx "$clean_id" && \
            mark=" ✅"

        app_ids+=("$clean_id")
        disp_names+=("${name}${mark}")
        disp_descs+=("${desc:-—} [${remotes:-flathub}/${branch:-stable}]  •  $clean_id")
        [[ ${#app_ids[@]} -ge 60 ]] && break
    done < "$tmpraw"

    # ── Fallback: flatpak search بدون --columns ───────────────────────────────
    if [[ ${#app_ids[@]} -eq 0 ]]; then
        local tmpfb; tmpfb=$(mktemp /tmp/gtclpm-fk-fb.XXXXXX)
        flatpak search "$query" 2>/dev/null | grep -v "^No matches\|^$\|^Name" > "$tmpfb"
        while IFS=$'\t' read -r name desc app_id rest; do
            name=$(echo "$name"     | sed 's/^[[:space:]]*//; s/[[:space:]]*$//; s/\x1b\[[0-9;]*m//g')
            app_id=$(echo "$app_id" | sed 's/^[[:space:]]*//; s/[[:space:]]*$//; s/\x1b\[[0-9;]*m//g')
            [[ -z "$app_id" ]] && continue
            local clean_id
            clean_id=$(_valid_flatpak_id "$app_id") || continue
            [[ $clean_id =~ $SKIP_PAT ]] && continue
            local mark=""
            flatpak list --app 2>/dev/null | grep -q "^$clean_id" && mark=" ✅"
            app_ids+=("$clean_id")
            disp_names+=("${name:-$clean_id}${mark}")
            disp_descs+=("${desc:-—}  •  $clean_id")
            [[ ${#app_ids[@]} -ge 60 ]] && break
        done < "$tmpfb"
        rm -f "$tmpfb"
    fi
    rm -f "$tmpraw"

    if [[ ${#app_ids[@]} -eq 0 ]]; then
        zenity --info --title="🔍 GT-CLPM" \
            --text="$(get_msg "no_results"):\n$query" --width=400
        return 1
    fi

    # ── بناء قائمة zenity ─────────────────────────────────────────────────────
    local -a zargs=()
    for ((i=0; i<${#app_ids[@]}; i++)); do
        zargs+=("${disp_names[$i]}" "${disp_descs[$i]}" "${app_ids[$i]}")
    done

    # ⚠️  --print-column=3 ضروري لإرجاع App ID لا اسم العرض
    local selected_id
    selected_id=$(zenity --list \
        --title="🔍 $(get_msg "search_results") (${#app_ids[@]}) — Flatpak" \
        --column="📦 $(get_msg "install")" \
        --column="📝 Description / ID" \
        --column="🔑 app_id" \
        --hide-column=3 \
        --print-column=3 \
        --width=$ZENITY_W --height=$ZENITY_H \
        "${zargs[@]}" 2>/dev/null)

    [[ -z "$selected_id" ]] && return 0

    # تنظيف المعرّف
    local clean_id
    clean_id=$(echo "$selected_id" | sed 's/[[:space:]]//g; s/\x1b\[[0-9;]*m//g')

    # التحقق من صحة المعرّف قبل التثبيت
    if ! _valid_flatpak_id "$clean_id" &>/dev/null; then
        zenity --error --title="GT-CLPM" \
            --text="$(get_msg "error") معرّف غير صالح:\n$clean_id\n\nInvalid Application ID." \
            --width=400
        return 1
    fi

    zenity --question --title="📦 GT-CLPM" \
        --text="$(get_msg "confirm_install")\n\n📦 $clean_id" --width=420
    if [[ $? -eq 0 ]]; then
        show_terminal_box "📦 $(get_msg "installing") $clean_id" \
            "flatpak install -y flathub \"$clean_id\""
    fi
}

# ─── بحث عام (APT/DNF/Pacman...) مع قائمة zenity ────────────────────────────
search_and_install_system() {
    local query="$1"
    [[ -z "$query" ]] && return 1
    local pm; pm=$(detect_package_manager)

    local tmpfile; tmpfile=$(mktemp /tmp/gtclpm-search.XXXXXX)

    # تشغيل البحث في الخلفية مع شريط تقدم
    (
        case $pm in
            apt)    apt-cache search "$query" 2>/dev/null | head -80 ;;
            dnf)    dnf search "$query" 2>/dev/null | grep -v "^=\|^Last\|^Loaded\|^$" | head -80 ;;
            yum)    yum search "$query" 2>/dev/null | grep -v "^=\|^Last\|^Loaded\|^$" | head -80 ;;
            pacman) pacman -Ss "$query" 2>/dev/null | grep -v "^    " | head -80 ;;
            zypper) zypper search "$query" 2>/dev/null | grep "^[|i ]" | grep -v "^---" | head -80 ;;
            eopkg)  eopkg search "$query" 2>/dev/null | head -80 ;;
            xbps)   xbps-query -Rs "*${query}*" 2>/dev/null | head -80 ;;
            apk)    apk search "$query" 2>/dev/null | head -80 ;;
            nix)    nix-env -qa "*${query}*" 2>/dev/null | head -80 ;;
            brew)   brew search "$query" 2>/dev/null | head -80 ;;
            *)      echo "$(get_msg "not_found")" ;;
        esac
    ) > "$tmpfile" 2>&1 &
    local spid=$!

    (
        while kill -0 "$spid" 2>/dev/null; do echo "10"; sleep 0.3; done
        echo "100"
    ) | zenity --progress \
        --title="🔍 $(get_msg "searching") $query" \
        --text="🔍 $(get_msg "searching") $query ..." \
        --pulsate --auto-close --no-cancel \
        --width=420 --height=80
    wait "$spid"

    if [[ ! -s "$tmpfile" ]]; then
        zenity --info --title="🔍 GT-CLPM" \
            --text="$(get_msg "no_results"):\n$query" --width=400
        rm -f "$tmpfile"
        return 0
    fi

    # ── تحليل المخرجات حسب مدير الحزم ─────────────────────────────────────────
    local -a pkg_names=() pkg_descs=()
    while IFS= read -r line; do
        [[ -z "$line" ]] && continue
        local name="" desc=""
        case $pm in
            apt)
                # "inkscape - Scalable Vector Graphics editor"
                name=$(echo "$line" | awk -F' - ' '{print $1}' | awk '{print $1}')
                desc=$(echo "$line" | awk -F' - ' '{print $2}')
                [[ -z "$desc" ]] && desc=$(echo "$line" | cut -d' ' -f2-)
                ;;
            dnf|yum)
                # "inkscape.x86_64 : Scalable Vector..." or "inkscape : ..."
                if echo "$line" | grep -q ' : '; then
                    name=$(echo "$line" | awk -F' : ' '{print $1}' | awk '{print $1}' | cut -d. -f1)
                    desc=$(echo "$line" | awk -F' : ' '{print $2}')
                else
                    name=$(echo "$line" | awk '{print $1}')
                    desc=$(echo "$line" | cut -d' ' -f2-)
                fi
                ;;
            pacman)
                # "community/inkscape 1.2.2 ..."
                name=$(echo "$line" | awk '{print $1}' | cut -d'/' -f2)
                desc=$(echo "$line" | cut -d' ' -f3-)
                ;;
            zypper)
                # "| inkscape | Scalable Vector ... | x86_64 | packman"
                name=$(echo "$line" | awk -F'|' '{gsub(/ /,"",$2); print $2}')
                desc=$(echo "$line" | awk -F'|' '{sub(/^ /,"",$3); print $3}')
                ;;
            eopkg)
                name=$(echo "$line" | awk '{print $1}')
                desc=$(echo "$line" | cut -d' ' -f2-)
                ;;
            xbps)
                # "[-] inkscape-1.2.2_1 Scalable..."
                name=$(echo "$line" | awk '{print $2}' | sed 's/-[0-9].*//')
                desc=$(echo "$line" | cut -d' ' -f3-)
                ;;
            apk)
                name=$(echo "$line" | awk '{print $1}')
                desc=""
                ;;
            nix)
                name=$(echo "$line" | awk '{print $1}')
                desc=""
                ;;
            brew)
                name=$(echo "$line" | awk '{print $1}')
                desc=$(echo "$line" | cut -d' ' -f2-)
                ;;
            *)
                name=$(echo "$line" | awk '{print $1}')
                desc=$(echo "$line" | cut -d' ' -f2-)
                ;;
        esac
        # تنظيف وتحقق
        name=$(echo "$name" | sed 's/^[[:space:]]*//; s/[[:space:]]*$//')
        [[ -z "$name" || "$name" == "Name" ]] && continue
        pkg_names+=("$name")
        pkg_descs+=("${desc:0:120}")
    done < "$tmpfile"
    rm -f "$tmpfile"

    if [[ ${#pkg_names[@]} -eq 0 ]]; then
        zenity --info --title="🔍 GT-CLPM" \
            --text="$(get_msg "no_results"):\n$query" --width=400
        return 0
    fi

    # ── عرض النتائج ───────────────────────────────────────────────────────────
    local -a zargs=()
    for ((i=0; i<${#pkg_names[@]}; i++)); do
        # عمودان + عمود مخفي للاسم الدقيق
        zargs+=("${pkg_names[$i]}" "${pkg_descs[$i]}" "${pkg_names[$i]}")
    done

    local selected
    selected=$(zenity --list \
        --title="🔍 $(get_msg "search_results") (${#pkg_names[@]}) — $pm" \
        --column="📦 Package" \
        --column="📝 Description" \
        --column="🔑 name" \
        --hide-column=3 \
        --print-column=3 \
        --width=$ZENITY_W --height=$ZENITY_H \
        "${zargs[@]}" 2>/dev/null)

    [[ -z "$selected" ]] && return 0

    # تنظيف الاسم
    selected=$(echo "$selected" | sed 's/^[[:space:]]*//; s/[[:space:]]*$//')

    zenity --question --title="📦 GT-CLPM" \
        --text="$(get_msg "confirm_install")\n\n📦 $selected" --width=420
    [[ $? -eq 0 ]] && install_package "$selected"
}

# ─── الإزالة الذكية عبر zenity ───────────────────────────────────────────────
_smart_remove_gui() {
    local title="$1"
    local list_cmd="$2"
    local remove_cmd="$3"

    local choice
    choice=$(zenity --list \
        --title="$title" --column="" \
        --width=400 --height=200 \
        "$(get_msg "manual_entry")" \
        "$(get_msg "browse_packages")" 2>/dev/null)

    case "$choice" in
        "$(get_msg "manual_entry")")
            local pkg
            pkg=$(zenity --entry --title="$title" \
                --text="$(get_msg "enter_package")" --width=400)
            [[ -z "$pkg" ]] && return
            zenity --question --title="$title" \
                --text="$(get_msg "confirm_remove")\n\n$pkg" --width=400
            [[ $? -eq 0 ]] && show_terminal_box "$title" "$remove_cmd \"$pkg\""
            ;;
        "$(get_msg "browse_packages")")
            # جمع القائمة مع شريط تقدم
            local tmpfile; tmpfile=$(mktemp /tmp/gtclpm-list.XXXXXX)
            (eval "$list_cmd" 2>/dev/null) > "$tmpfile"

            if [[ ! -s "$tmpfile" ]]; then
                zenity --info --title="$title" \
                    --text="$(get_msg "no_results")" --width=400
                rm -f "$tmpfile"
                return
            fi

            # بناء قائمة zenity
            local zenity_args=()
            while IFS= read -r p; do
                [[ -z "$p" ]] && continue
                zenity_args+=("$p")
            done < "$tmpfile"
            rm -f "$tmpfile"

            local selected
            selected=$(zenity --list \
                --title="$(get_msg "select_to_remove")" \
                --column="Package" \
                --width=$ZENITY_W --height=$ZENITY_H \
                "${zenity_args[@]}" 2>/dev/null)

            [[ -z "$selected" ]] && return

            zenity --question --title="$title" \
                --text="$(get_msg "confirm_remove")\n\n$selected" --width=400
            [[ $? -eq 0 ]] && \
                show_terminal_box "$title" "$remove_cmd \"$selected\""
            ;;
    esac
}

smart_remove_system() {
    local pm; pm=$(detect_package_manager)
    local list_cmd remove_cmd
    case $pm in
        apt)    list_cmd="dpkg-query -f '\${Package}\n' -W | sort"
                remove_cmd="apt remove -y" ;;
        dnf)    list_cmd="dnf list installed | awk 'NR>1{print \$1}' | cut -d. -f1 | sort"
                remove_cmd="dnf remove -y" ;;
        yum)    list_cmd="yum list installed | awk 'NR>1{print \$1}' | cut -d. -f1 | sort"
                remove_cmd="yum remove -y" ;;
        pacman) list_cmd="pacman -Q | awk '{print \$1}' | sort"
                remove_cmd="pacman -R --noconfirm" ;;
        zypper) list_cmd="zypper search -i | grep '^i' | awk '{print \$3}' | sort"
                remove_cmd="zypper remove -y" ;;
        eopkg)  list_cmd="eopkg list-installed | awk '{print \$1}' | sort"
                remove_cmd="eopkg remove" ;;
        xbps)   list_cmd="xbps-query -l | awk '{print \$2}' | sed 's/-[0-9].*//' | sort"
                remove_cmd="xbps-remove" ;;
        apk)    list_cmd="apk info | sort"
                remove_cmd="apk del" ;;
        nix)    list_cmd="nix-env -q | sort"
                remove_cmd="nix-env -e" ;;
        brew)   list_cmd="brew list | sort"
                remove_cmd="brew uninstall" ;;
        pkg)    list_cmd="pkg info | awk '{print \$1}' | sort"
                remove_cmd="pkg delete -y" ;;
        *)
            zenity --error --title="GT-CLPM" \
                --text="$(get_msg "error") $(get_msg "not_found")" --width=400
            return 1 ;;
    esac
    _smart_remove_gui "$(get_msg "smart_remove")" "$list_cmd" "$remove_cmd"
}

smart_remove_flatpak() {
    _smart_remove_gui \
        "$(get_msg "smart_remove_flatpak")" \
        "flatpak list --app --columns=application | tail -n +1 | sort" \
        "flatpak uninstall -y"
}

smart_remove_snap() {
    _smart_remove_gui \
        "$(get_msg "smart_remove_snap")" \
        "snap list | awk 'NR>1{print \$1}' | sort" \
        "snap remove"
}

# ─── عرض المستودعات الحالية ───────────────────────────────────────────────────
view_repositories() {
    local pm; pm=$(detect_package_manager)
    local title_ar="المستودعات المفعّلة حالياً"
    local title_en="Currently Enabled Repositories"
    local title; [[ "$CURRENT_LANG" == "ar" ]] && title="$title_ar" || title="$title_en"
    local cmd
    case $pm in
        apt)
            cmd="{ echo '=== /etc/apt/sources.list ==='; grep -v '^[[:space:]]*#' /etc/apt/sources.list 2>/dev/null | grep -v '^[[:space:]]*$' || true; echo; echo '=== /etc/apt/sources.list.d/ ==='; for f in /etc/apt/sources.list.d/*.list /etc/apt/sources.list.d/*.sources; do [ -f \"\$f\" ] || continue; echo \"--- \$f ---\"; grep -v '^[[:space:]]*#' \"\$f\" 2>/dev/null | grep -v '^[[:space:]]*$' || true; echo; done; }"
            ;;
        dnf|yum)
            cmd="$pm repolist --all 2>/dev/null"
            ;;
        pacman)
            cmd="echo '=== /etc/pacman.conf — Repositories ==='; grep -A2 '^\[' /etc/pacman.conf 2>/dev/null | grep -v '^--\$'"
            ;;
        zypper)
            cmd="zypper repos --details 2>/dev/null"
            ;;
        eopkg)
            cmd="eopkg list-repo 2>/dev/null"
            ;;
        xbps)
            cmd="cat /etc/xbps.d/*.conf 2>/dev/null; cat /usr/share/xbps.d/*.conf 2>/dev/null"
            ;;
        nix)
            cmd="nix-channel --list 2>/dev/null"
            ;;
        brew)
            cmd="brew tap 2>/dev/null"
            ;;
        *)
            zenity --warning --title="GT-CLPM" \
                --text="$(get_msg "warning") $(get_msg "not_found"): $pm" --width=400
            return ;;
    esac

    local tmpfile; tmpfile=$(mktemp /tmp/gtclpm-repos.XXXXXX)
    bash -c "$cmd" > "$tmpfile" 2>&1
    zenity --text-info \
        --title="$title — $pm" \
        --filename="$tmpfile" \
        --width=$ZENITY_W --height=550 \
        --ok-label="$(get_msg "press_ok")"
    rm -f "$tmpfile"
}

# ─── إدارة المستودعات ─────────────────────────────────────────────────────────
add_repository_gui() {
    local pm; pm=$(detect_package_manager)
    local view_label
    [[ "$CURRENT_LANG" == "ar" ]] && view_label="عرض المستودعات الحالية" \
                                  || view_label="View current repositories"
    local choice

    case $pm in
        apt)
            choice=$(zenity --list --title="$(get_msg "add_repo") — APT" \
                --column="" --width=500 --height=280 \
                "$view_label" \
                "Add PPA (Ubuntu/Mint)" \
                "Add custom repository (sources.list.d)" \
                "Add GPG key + repository" 2>/dev/null)

            case "$choice" in
                "$view_label")  view_repositories ;;
                "Add PPA"*)
                    local ppa
                    ppa=$(zenity --entry --title="Add PPA" \
                        --text="Enter PPA (e.g. ppa:user/repo):" --width=400)
                    [[ -n "$ppa" ]] && \
                        show_terminal_box "Add PPA" \
                        "add-apt-repository -y \"$ppa\" && apt update"
                    ;;
                "Add custom"*)
                    local repo_line repo_name
                    repo_line=$(zenity --entry --title="Add Repository" \
                        --text="Enter repository line (deb ...):" --width=500)
                    repo_name=$(zenity --entry --title="Add Repository" \
                        --text="Enter file name (e.g. myrepo):" --width=400)
                    [[ -n "$repo_line" && -n "$repo_name" ]] && \
                        show_terminal_box "Add Repository" \
                        "echo \"$repo_line\" | tee /etc/apt/sources.list.d/${repo_name}.list && apt update"
                    ;;
                "Add GPG"*)
                    local key_url repo_line repo_name
                    key_url=$(zenity --entry --title="Add GPG + Repository" \
                        --text="Enter GPG key URL:" --width=500)
                    repo_line=$(zenity --entry --title="Add GPG + Repository" \
                        --text="Enter repository line (deb ...):" --width=500)
                    repo_name=$(zenity --entry --title="Add GPG + Repository" \
                        --text="Enter file name (e.g. myrepo):" --width=400)
                    [[ -n "$key_url" && -n "$repo_line" && -n "$repo_name" ]] && \
                        show_terminal_box "Add GPG + Repository" \
                        "curl -fsSL \"$key_url\" | gpg --dearmor -o /etc/apt/keyrings/${repo_name}.gpg && echo \"$repo_line\" | tee /etc/apt/sources.list.d/${repo_name}.list && apt update"
                    ;;
            esac ;;

        dnf)
            choice=$(zenity --list --title="$(get_msg "add_repo") — DNF" \
                --column="" --width=400 --height=250 \
                "$view_label" \
                "Add COPR repository" \
                "Add RPM repository URL" \
                "Install RPM Fusion" 2>/dev/null)
            case "$choice" in
                "$view_label")  view_repositories ;;
                "Add COPR"*)
                    local copr
                    copr=$(zenity --entry --title="Add COPR" \
                        --text="Enter COPR (e.g. user/repo):" --width=400)
                    [[ -n "$copr" ]] && \
                        show_terminal_box "Add COPR" \
                        "dnf copr enable -y \"$copr\" && dnf update"
                    ;;
                "Add RPM"*)
                    local rurl
                    rurl=$(zenity --entry --title="Add RPM Repo" \
                        --text="Enter .repo file URL:" --width=500)
                    [[ -n "$rurl" ]] && \
                        show_terminal_box "Add RPM Repository" \
                        "dnf config-manager --add-repo \"$rurl\""
                    ;;
                "Install RPM Fusion"*)
                    show_terminal_box "Install RPM Fusion" \
                        "dnf install -y https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-\$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-\$(rpm -E %fedora).noarch.rpm"
                    ;;
            esac ;;

        pacman)
            choice=$(zenity --list --title="$(get_msg "add_repo") — Pacman" \
                --column="" --width=400 --height=250 \
                "$view_label" \
                "Enable multilib" \
                "Add custom repository" \
                "Install AUR helper (yay)" 2>/dev/null)
            case "$choice" in
                "$view_label")  view_repositories ;;
                "Enable multilib"*)
                    show_terminal_box "Enable multilib" \
                        "sed -i '/^#\[multilib\]/,/^#Include/ s/^#//' /etc/pacman.conf && pacman -Sy"
                    ;;
                "Add custom"*)
                    local rname rurl
                    rname=$(zenity --entry --title="Add Repository" \
                        --text="Repository name:" --width=400)
                    rurl=$(zenity --entry --title="Add Repository" \
                        --text="Repository URL:" --width=500)
                    [[ -n "$rname" && -n "$rurl" ]] && \
                        show_terminal_box "Add Repository" \
                        "echo -e \"\n[$rname]\nServer = $rurl\" | tee -a /etc/pacman.conf && pacman -Sy"
                    ;;
                "Install AUR helper"*)
                    show_terminal_box "Install yay" \
                        "pacman -S --noconfirm git base-devel && cd /tmp && git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si --noconfirm && cd / && rm -rf /tmp/yay"
                    ;;
            esac ;;

        zypper)
            choice=$(zenity --list --title="$(get_msg "add_repo") — Zypper" \
                --column="" --width=400 --height=230 \
                "$view_label" \
                "Add repository by URL" \
                "Add Packman repository" 2>/dev/null)
            case "$choice" in
                "$view_label")  view_repositories ;;
                "Add repository"*)
                    local rurl ralias
                    rurl=$(zenity --entry --title="Add Repository" \
                        --text="Repository URL:" --width=500)
                    ralias=$(zenity --entry --title="Add Repository" \
                        --text="Repository alias:" --width=400)
                    [[ -n "$rurl" ]] && \
                        show_terminal_box "Add Repository" \
                        "zypper addrepo -f \"$rurl\" \"${ralias:-custom}\""
                    ;;
                "Add Packman"*)
                    show_terminal_box "Add Packman" \
                        "VER=\$(. /etc/os-release; echo \$VERSION_ID); zypper addrepo -cfp 90 \"https://ftp.gwdg.de/pub/linux/misc/packman/suse/openSUSE_Leap_\${VER}/\" packman && zypper --gpg-auto-import-keys refresh"
                    ;;
            esac ;;

        *)
            view_repositories
            zenity --warning --title="GT-CLPM" \
                --text="$(get_msg "warning") Repository management not implemented for: $pm" \
                --width=400 ;;
    esac
}

# ─── فحص Flatpak و Snap ───────────────────────────────────────────────────────
check_flatpak() {
    if ! command -v flatpak &>/dev/null; then
        zenity --question --title="GT-CLPM" \
            --text="$(get_msg "flatpak_not_installed")" --width=400
        [[ $? -eq 0 ]] || return 1
        local pm; pm=$(detect_package_manager)
        local cmd
        case $pm in
            apt)    cmd="apt install -y flatpak" ;;
            dnf)    cmd="dnf install -y flatpak" ;;
            pacman) cmd="pacman -S --noconfirm flatpak" ;;
            zypper) cmd="zypper install -y flatpak" ;;
            eopkg)  cmd="eopkg install flatpak" ;;
            *)      cmd="echo 'Please install flatpak manually'" ;;
        esac
        show_terminal_box "$(get_msg "installing") Flatpak" \
            "$cmd && flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo"
    fi
}

check_snap() {
    if ! command -v snap &>/dev/null; then
        zenity --question --title="GT-CLPM" \
            --text="$(get_msg "snap_not_installed")" --width=400
        [[ $? -eq 0 ]] || return 1
        local pm; pm=$(detect_package_manager)
        local cmd
        case $pm in
            apt)    cmd="apt install -y snapd" ;;
            dnf)    cmd="dnf install -y snapd" ;;
            pacman) cmd="pacman -S --noconfirm snapd" ;;
            zypper) cmd="zypper install -y snapd" ;;
            *)      cmd="echo 'Please install snapd manually'" ;;
        esac
        show_terminal_box "$(get_msg "installing") Snap" \
            "$cmd && systemctl enable --now snapd.socket"
    fi
}

# ─── أدوات النظام ─────────────────────────────────────────────────────────────
show_system_info() {
    local os_name; os_name=$(grep PRETTY_NAME /etc/os-release 2>/dev/null | cut -d'"' -f2)
    [[ -z "$os_name" ]] && os_name=$(lsb_release -d 2>/dev/null | cut -f2)
    [[ -z "$os_name" ]] && os_name="Unknown"

    local info
    info="$(get_msg "title")\n$(get_msg "version")\n"
    info+="$(get_msg "detected") $(detect_package_manager)\n\n"
    info+="OS:            $os_name\n"
    info+="Kernel:        $(uname -r)\n"
    info+="Architecture:  $(uname -m)\n"
    info+="Hostname:      $(hostname)\n"
    info+="Uptime:        $(uptime -p 2>/dev/null || uptime)\n"
    info+="Memory:        $(free -h 2>/dev/null | awk '/Mem:/{print $3"/"$2}' || echo 'N/A')\n"
    info+="CPU:           $(grep "model name" /proc/cpuinfo 2>/dev/null | head -1 | cut -d':' -f2 | sed 's/^ *//' || echo 'N/A')\n"
    info+="\nLanguage Runtimes:\n"
    command -v python3 &>/dev/null && info+="  Python3: $(python3 --version 2>&1)\n"
    command -v node    &>/dev/null && info+="  Node.js: $(node --version 2>/dev/null)\n"
    command -v ruby    &>/dev/null && info+="  Ruby:    $(ruby --version 2>/dev/null | awk '{print $1,$2}')\n"
    command -v go      &>/dev/null && info+="  Go:      $(go version 2>/dev/null)\n"
    command -v rustc   &>/dev/null && info+="  Rust:    $(rustc --version 2>/dev/null)\n"
    command -v php     &>/dev/null && info+="  PHP:     $(php --version 2>/dev/null | head -1)\n"
    command -v java    &>/dev/null && info+="  Java:    $(java -version 2>&1 | head -1)\n"

    zenity --info --title="$(get_msg "system_info")" \
        --text="$info" --width=600 --height=500
}

show_disk_usage() {
    show_terminal_box "$(get_msg "disk_usage")" \
        "df -h | grep -v 'tmpfs\|udev\|loop'"
}

backup_packages() {
    local pm; pm=$(detect_package_manager)
    local backup_file="$HOME/gt-clpm-backup-$(date +%Y%m%d_%H%M%S).txt"
    local cmd
    case $pm in
        apt)     cmd="dpkg --get-selections > \"$backup_file\" && echo 'Backup: $backup_file'" ;;
        dnf|yum) cmd="$pm list installed > \"$backup_file\" && echo 'Backup: $backup_file'" ;;
        pacman)  cmd="pacman -Q > \"$backup_file\" && echo 'Backup: $backup_file'" ;;
        zypper)  cmd="zypper search -i > \"$backup_file\" && echo 'Backup: $backup_file'" ;;
        eopkg)   cmd="eopkg list-installed > \"$backup_file\" && echo 'Backup: $backup_file'" ;;
        brew)    cmd="brew list > \"$backup_file\" && echo 'Backup: $backup_file'" ;;
        pkg)     cmd="pkg info > \"$backup_file\" && echo 'Backup: $backup_file'" ;;
        *)
            zenity --warning --title="GT-CLPM" \
                --text="$(get_msg "warning") Backup not implemented for: $pm" --width=400
            return 1 ;;
    esac
    show_terminal_box "$(get_msg "backup_packages")" "$cmd"
    zenity --info --title="GT-CLPM" \
        --text="$(get_msg "backup_created"):\n$backup_file" --width=500
}

restore_packages() {
    local files
    files=$(ls "$HOME"/gt-clpm-backup-*.txt 2>/dev/null)
    if [[ -z "$files" ]]; then
        zenity --warning --title="GT-CLPM" \
            --text="$(get_msg "warning") No backup files found in \$HOME" --width=400
        return
    fi

    local zenity_args=()
    while IFS= read -r f; do zenity_args+=("$f"); done <<< "$files"

    local chosen
    chosen=$(zenity --list \
        --title="$(get_msg "restore_packages")" \
        --column="Backup File" \
        --width=700 --height=400 \
        "${zenity_args[@]}" 2>/dev/null)
    [[ -z "$chosen" ]] && return

    zenity --question --title="$(get_msg "restore_packages")" \
        --text="$(get_msg "warning") This will reinstall packages from:\n$chosen\n\nContinue?" \
        --width=500
    [[ $? -ne 0 ]] && return

    local pm; pm=$(detect_package_manager)
    local cmd
    case $pm in
        apt)    cmd="dpkg --set-selections < \"$chosen\" && apt-get dselect-upgrade -y" ;;
        pacman) cmd="awk '{print \$1}' \"$chosen\" | pacman -S --noconfirm -" ;;
        *)
            zenity --info --title="GT-CLPM" \
                --text="$(get_msg "warning") Automatic restore not available for $pm.\nBackup file: $chosen" \
                --width=500
            return ;;
    esac
    show_terminal_box "$(get_msg "restore_packages")" "$cmd"
}

# ─── أدوات اللغات (تُفتح في طرفية) ──────────────────────────────────────────
# كل أدوات اللغات تعمل في x-terminal-emulator لأنها تحتاج stdin تفاعلي
_open_in_terminal() {
    local cmd="$1"
    if command -v x-terminal-emulator &>/dev/null; then
        x-terminal-emulator -e bash -c "$cmd; echo; echo 'Press Enter to close...'; read"
    elif command -v gnome-terminal &>/dev/null; then
        gnome-terminal -- bash -c "$cmd; echo; echo 'Press Enter to close...'; read"
    elif command -v xterm &>/dev/null; then
        xterm -e bash -c "$cmd; echo; echo 'Press Enter to close...'; read"
    elif command -v konsole &>/dev/null; then
        konsole -e bash -c "$cmd; echo; echo 'Press Enter to close...'; read"
    else
        zenity --error --title="GT-CLPM" \
            --text="No terminal emulator found.\nPlease install xterm or gnome-terminal." \
            --width=400
    fi
}

python_tools_gui() {
    while true; do
        local choice
        choice=$(zenity --list \
            --title="$(get_msg "python_tools")" \
            --column="" \
            --width=$ZENITY_W --height=600 \
            "Install with pipx (recommended - isolated)" \
            "Install in virtual environment" \
            "Install with pip --user (no sudo)" \
            "Install with pip --break-system-packages" \
            "Remove Python package" \
            "List installed packages (pipx + pip)" \
            "Create virtual environment" \
            "Search PyPI (opens browser)" \
            "$(get_msg "back")" 2>/dev/null)

        [[ -z "$choice" || "$choice" == "$(get_msg "back")" ]] && break

        local pkg
        case "$choice" in
            "Install with pipx"*)
                pkg=$(zenity --entry --title="pipx install" \
                    --text="Package name:" --width=400)
                [[ -n "$pkg" ]] && \
                    show_terminal_box "pipx install $pkg" \
                    "pipx install \"$pkg\" && pipx ensurepath"
                ;;
            "Install in virtual"*)
                pkg=$(zenity --entry --title="Install in venv" \
                    --text="Package name:" --width=400)
                local vname
                vname=$(zenity --entry --title="Install in venv" \
                    --text="Virtual env name (default: $pkg):" --width=400)
                vname="${vname:-$pkg}"
                [[ -n "$pkg" ]] && \
                    show_terminal_box "Install $pkg in venv_$vname" \
                    "python3 -m venv \$HOME/venv_${vname} && \$HOME/venv_${vname}/bin/pip install \"$pkg\" && echo 'Activate: source \$HOME/venv_${vname}/bin/activate'"
                ;;
            "Install with pip --user"*)
                pkg=$(zenity --entry --title="pip --user install" \
                    --text="Package name:" --width=400)
                [[ -n "$pkg" ]] && \
                    show_terminal_box "pip --user install $pkg" \
                    "pip3 install --user \"$pkg\""
                ;;
            "Install with pip --break"*)
                pkg=$(zenity --entry --title="pip install" \
                    --text="Package name:" --width=400)
                if [[ -n "$pkg" ]]; then
                    zenity --question --title="GT-CLPM" \
                        --text="Warning: may affect system Python packages.\nContinue?" --width=400
                    [[ $? -eq 0 ]] && \
                        show_terminal_box "pip install $pkg" \
                        "pip3 install \"$pkg\" --break-system-packages"
                fi
                ;;
            "Remove Python"*)
                local method
                method=$(zenity --list --title="Remove Python Package" \
                    --column="" --width=400 --height=200 \
                    "Remove pipx package" "Remove pip --user package" 2>/dev/null)
                pkg=$(zenity --entry --title="Remove Python Package" \
                    --text="Package name:" --width=400)
                [[ -z "$pkg" ]] && continue
                case "$method" in
                    "Remove pipx"*) show_terminal_box "pipx uninstall $pkg" "pipx uninstall \"$pkg\"" ;;
                    "Remove pip"*)  show_terminal_box "pip uninstall $pkg"  "pip3 uninstall -y \"$pkg\"" ;;
                esac
                ;;
            "List installed"*)
                show_terminal_box "Python Packages" \
                    "echo '=== pipx ==='; pipx list --short 2>/dev/null; echo; echo '=== pip user ==='; pip3 list --user 2>/dev/null"
                ;;
            "Create virtual"*)
                local vname
                vname=$(zenity --entry --title="Create venv" \
                    --text="Virtual environment name:" --width=400)
                [[ -n "$vname" ]] && \
                    show_terminal_box "Create venv_$vname" \
                    "python3 -m venv \$HOME/venv_${vname} && echo 'Created: \$HOME/venv_${vname}' && echo 'Activate: source \$HOME/venv_${vname}/bin/activate'"
                ;;
            "Search PyPI"*)
                local q
                q=$(zenity --entry --title="Search PyPI" \
                    --text="Search query:" --width=400)
                [[ -n "$q" ]] && xdg-open "https://pypi.org/search/?q=$q" 2>/dev/null &
                ;;
        esac
    done
}

nodejs_tools_gui() {
    while true; do
        local choice
        choice=$(zenity --list \
            --title="$(get_msg "nodejs_tools")" \
            --column="" \
            --width=$ZENITY_W --height=600 \
            "Install package globally (npm)" \
            "Install package locally (npm)" \
            "Run package with npx" \
            "Remove package" \
            "List installed packages" \
            "Install with yarn" \
            "Install with pnpm" \
            "Install yarn" \
            "Install pnpm" \
            "$(get_msg "back")" 2>/dev/null)

        [[ -z "$choice" || "$choice" == "$(get_msg "back")" ]] && break

        local pkg
        case "$choice" in
            "Install package globally"*)
                pkg=$(zenity --entry --title="npm install -g" --text="Package name:" --width=400)
                [[ -n "$pkg" ]] && show_terminal_box "npm install -g $pkg" "npm install -g \"$pkg\""
                ;;
            "Install package locally"*)
                pkg=$(zenity --entry --title="npm install" --text="Package name:" --width=400)
                [[ -n "$pkg" ]] && show_terminal_box "npm install $pkg" "npm install \"$pkg\""
                ;;
            "Run package with npx"*)
                pkg=$(zenity --entry --title="npx" --text="Package (with args):" --width=400)
                [[ -n "$pkg" ]] && show_terminal_box "npx $pkg" "npx $pkg"
                ;;
            "Remove package"*)
                local scope
                scope=$(zenity --list --title="Remove npm package" --column="" \
                    --width=300 --height=200 "Global" "Local" "yarn" "pnpm" 2>/dev/null)
                pkg=$(zenity --entry --title="Remove package" --text="Package name:" --width=400)
                [[ -z "$pkg" ]] && continue
                case "$scope" in
                    "Global") show_terminal_box "npm uninstall -g $pkg" "npm uninstall -g \"$pkg\"" ;;
                    "Local")  show_terminal_box "npm uninstall $pkg"    "npm uninstall \"$pkg\"" ;;
                    "yarn")   show_terminal_box "yarn remove $pkg"      "yarn remove \"$pkg\"" ;;
                    "pnpm")   show_terminal_box "pnpm remove $pkg"      "pnpm remove \"$pkg\"" ;;
                esac
                ;;
            "List installed"*)
                show_terminal_box "npm list" \
                    "echo '=== Global ==='; npm list -g --depth=0 2>/dev/null; echo; echo '=== Local ==='; npm list --depth=0 2>/dev/null"
                ;;
            "Install with yarn"*)
                pkg=$(zenity --entry --title="yarn add" --text="Package name:" --width=400)
                [[ -n "$pkg" ]] && show_terminal_box "yarn add $pkg" "yarn add \"$pkg\""
                ;;
            "Install with pnpm"*)
                pkg=$(zenity --entry --title="pnpm add" --text="Package name:" --width=400)
                [[ -n "$pkg" ]] && show_terminal_box "pnpm add $pkg" "pnpm add \"$pkg\""
                ;;
            "Install yarn"*)
                show_terminal_box "Install yarn" "npm install -g yarn"
                ;;
            "Install pnpm"*)
                show_terminal_box "Install pnpm" "npm install -g pnpm"
                ;;
        esac
    done
}

ruby_tools_gui() {
    while true; do
        local choice
        choice=$(zenity --list \
            --title="$(get_msg "ruby_tools")" --column="" \
            --width=$ZENITY_W --height=500 \
            "Install gem (system)" \
            "Install gem (user)" \
            "Remove gem" \
            "List installed gems" \
            "Update all gems" \
            "Install bundler" \
            "Bundle install (Gemfile)" \
            "$(get_msg "back")" 2>/dev/null)

        [[ -z "$choice" || "$choice" == "$(get_msg "back")" ]] && break

        local pkg
        case "$choice" in
            "Install gem (system)"*)
                pkg=$(zenity --entry --title="gem install" --text="Gem name:" --width=400)
                [[ -n "$pkg" ]] && show_terminal_box "gem install $pkg" "gem install \"$pkg\""
                ;;
            "Install gem (user)"*)
                pkg=$(zenity --entry --title="gem install --user" --text="Gem name:" --width=400)
                [[ -n "$pkg" ]] && show_terminal_box "gem install --user $pkg" "gem install --user-install \"$pkg\""
                ;;
            "Remove gem"*)
                pkg=$(zenity --entry --title="gem uninstall" --text="Gem name:" --width=400)
                if [[ -n "$pkg" ]]; then
                    zenity --question --title="GT-CLPM" \
                        --text="$(get_msg "confirm_remove")\n\n$pkg" --width=400
                    [[ $? -eq 0 ]] && show_terminal_box "gem uninstall $pkg" "gem uninstall \"$pkg\""
                fi
                ;;
            "List installed gems"*)
                show_terminal_box "gem list" "gem list 2>/dev/null"
                ;;
            "Update all gems"*)
                show_terminal_box "gem update" "gem update"
                ;;
            "Install bundler"*)
                show_terminal_box "Install bundler" "gem install bundler"
                ;;
            "Bundle install"*)
                show_terminal_box "bundle install" "bundle install"
                ;;
        esac
    done
}

rust_tools_gui() {
    while true; do
        local choice
        choice=$(zenity --list \
            --title="$(get_msg "rust_tools")" --column="" \
            --width=$ZENITY_W --height=500 \
            "Install crate (cargo install)" \
            "Remove crate" \
            "List installed crates" \
            "Update Rust toolchain (rustup)" \
            "Add Rust component (clippy/rustfmt...)" \
            "Install Rust via rustup" \
            "$(get_msg "back")" 2>/dev/null)

        [[ -z "$choice" || "$choice" == "$(get_msg "back")" ]] && break

        local pkg
        case "$choice" in
            "Install crate"*)
                pkg=$(zenity --entry --title="cargo install" --text="Crate name:" --width=400)
                [[ -n "$pkg" ]] && \
                    show_terminal_box "cargo install $pkg" \
                    "source \$HOME/.cargo/env 2>/dev/null; cargo install \"$pkg\""
                ;;
            "Remove crate"*)
                pkg=$(zenity --entry --title="cargo uninstall" --text="Crate name:" --width=400)
                if [[ -n "$pkg" ]]; then
                    zenity --question --title="GT-CLPM" \
                        --text="$(get_msg "confirm_remove")\n\n$pkg" --width=400
                    [[ $? -eq 0 ]] && \
                        show_terminal_box "cargo uninstall $pkg" \
                        "source \$HOME/.cargo/env 2>/dev/null; cargo uninstall \"$pkg\""
                fi
                ;;
            "List installed"*)
                show_terminal_box "cargo install --list" \
                    "source \$HOME/.cargo/env 2>/dev/null; cargo install --list"
                ;;
            "Update Rust"*)
                show_terminal_box "rustup update" \
                    "source \$HOME/.cargo/env 2>/dev/null; rustup update"
                ;;
            "Add Rust component"*)
                pkg=$(zenity --entry --title="rustup component add" \
                    --text="Component name (e.g. clippy, rustfmt):" --width=400)
                [[ -n "$pkg" ]] && \
                    show_terminal_box "rustup component add $pkg" \
                    "source \$HOME/.cargo/env 2>/dev/null; rustup component add \"$pkg\""
                ;;
            "Install Rust"*)
                show_terminal_box "Install Rust via rustup" \
                    "curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y"
                ;;
        esac
    done
}

go_tools_gui() {
    while true; do
        local choice
        choice=$(zenity --list \
            --title="$(get_msg "go_tools")" --column="" \
            --width=$ZENITY_W --height=500 \
            "Install package (go install)" \
            "Install specific version" \
            "List installed binaries" \
            "Remove installed binary" \
            "Install Go (if missing)" \
            "go get (add dependency to project)" \
            "$(get_msg "back")" 2>/dev/null)

        [[ -z "$choice" || "$choice" == "$(get_msg "back")" ]] && break

        local pkg
        case "$choice" in
            "Install package"*)
                pkg=$(zenity --entry --title="go install" \
                    --text="Package path (e.g. github.com/user/tool@latest):" --width=500)
                [[ -n "$pkg" ]] && \
                    show_terminal_box "go install $pkg" \
                    "export PATH=\$PATH:/usr/local/go/bin:\$HOME/go/bin; go install \"$pkg\""
                ;;
            "Install specific"*)
                pkg=$(zenity --entry --title="go install version" \
                    --text="Package path with version (e.g. tool@v1.2.3):" --width=500)
                [[ -n "$pkg" ]] && \
                    show_terminal_box "go install $pkg" \
                    "export PATH=\$PATH:/usr/local/go/bin:\$HOME/go/bin; go install \"$pkg\""
                ;;
            "List installed"*)
                show_terminal_box "Go binaries" \
                    "ls \${GOPATH:-\$HOME/go}/bin 2>/dev/null"
                ;;
            "Remove installed"*)
                pkg=$(zenity --entry --title="Remove Go binary" \
                    --text="Binary name:" --width=400)
                if [[ -n "$pkg" ]]; then
                    zenity --question --title="GT-CLPM" \
                        --text="$(get_msg "confirm_remove")\n\n$pkg" --width=400
                    [[ $? -eq 0 ]] && \
                        show_terminal_box "Remove $pkg" \
                        "rm -f \${GOPATH:-\$HOME/go}/bin/\"$pkg\" && echo 'Removed'"
                fi
                ;;
            "Install Go"*)
                show_terminal_box "Install Go" \
                    "ARCH=\$(uname -m); [ \"\$ARCH\" = x86_64 ] && ARCH=amd64; [ \"\$ARCH\" = aarch64 ] && ARCH=arm64; curl -fsSL https://go.dev/dl/go1.22.0.linux-\${ARCH}.tar.gz -o /tmp/go.tar.gz && rm -rf /usr/local/go && tar -C /usr/local -xzf /tmp/go.tar.gz && echo 'export PATH=\$PATH:/usr/local/go/bin' >> \$HOME/.bashrc && echo 'Go installed. Restart terminal.'"
                ;;
            "go get"*)
                pkg=$(zenity --entry --title="go get" \
                    --text="Package path:" --width=500)
                [[ -n "$pkg" ]] && \
                    show_terminal_box "go get $pkg" \
                    "export PATH=\$PATH:/usr/local/go/bin:\$HOME/go/bin; go get \"$pkg\""
                ;;
        esac
    done
}

java_tools_gui() {
    while true; do
        local choice
        choice=$(zenity --list \
            --title="$(get_msg "java_tools")" --column="" \
            --width=$ZENITY_W --height=600 \
            "Install Maven" \
            "Install Gradle" \
            "Run Maven command" \
            "Run Gradle command" \
            "Install SDKMAN" \
            "Manage JDK via SDKMAN" \
            "Show Java version info" \
            "Switch Java version (update-alternatives)" \
            "$(get_msg "back")" 2>/dev/null)

        [[ -z "$choice" || "$choice" == "$(get_msg "back")" ]] && break

        case "$choice" in
            "Install Maven"*)
                show_terminal_box "Install Maven" "$(detect_package_manager) install -y maven 2>/dev/null || apt install -y maven 2>/dev/null || dnf install -y maven 2>/dev/null || pacman -S --noconfirm maven"
                ;;
            "Install Gradle"*)
                show_terminal_box "Install Gradle" "$(detect_package_manager) install -y gradle 2>/dev/null || apt install -y gradle 2>/dev/null"
                ;;
            "Run Maven command"*)
                local cmd
                cmd=$(zenity --entry --title="mvn" \
                    --text="Maven command (e.g. clean install -DskipTests):" --width=500)
                [[ -n "$cmd" ]] && show_terminal_box "mvn $cmd" "mvn $cmd"
                ;;
            "Run Gradle command"*)
                local cmd
                cmd=$(zenity --entry --title="gradle" \
                    --text="Gradle task (e.g. build):" --width=400)
                [[ -n "$cmd" ]] && show_terminal_box "gradle $cmd" "gradle $cmd"
                ;;
            "Install SDKMAN"*)
                show_terminal_box "Install SDKMAN" \
                    "curl -s https://get.sdkman.io | bash && echo 'SDKMAN installed. Source: source \$HOME/.sdkman/bin/sdkman-init.sh'"
                ;;
            "Manage JDK via SDKMAN"*)
                local sdk_action
                sdk_action=$(zenity --list --title="SDKMAN" --column="" \
                    --width=400 --height=200 \
                    "List Java versions" "Install Java version" "Use Java version" 2>/dev/null)
                case "$sdk_action" in
                    "List"*)
                        show_terminal_box "sdk list java" \
                            "source \$HOME/.sdkman/bin/sdkman-init.sh 2>/dev/null; sdk list java"
                        ;;
                    "Install"*)
                        local v
                        v=$(zenity --entry --title="sdk install java" \
                            --text="Version (e.g. 21.0.2-tem):" --width=400)
                        [[ -n "$v" ]] && \
                            show_terminal_box "sdk install java $v" \
                            "source \$HOME/.sdkman/bin/sdkman-init.sh 2>/dev/null; sdk install java \"$v\""
                        ;;
                    "Use"*)
                        local v
                        v=$(zenity --entry --title="sdk use java" \
                            --text="Version:" --width=400)
                        [[ -n "$v" ]] && \
                            show_terminal_box "sdk use java $v" \
                            "source \$HOME/.sdkman/bin/sdkman-init.sh 2>/dev/null; sdk use java \"$v\""
                        ;;
                esac
                ;;
            "Show Java"*)
                show_terminal_box "Java version" "java -version 2>&1; javac -version 2>/dev/null"
                ;;
            "Switch Java version"*)
                show_terminal_box "update-alternatives java" "update-alternatives --config java"
                ;;
        esac
    done
}

php_tools_gui() {
    while true; do
        local choice
        choice=$(zenity --list \
            --title="$(get_msg "php_tools")" --column="" \
            --width=$ZENITY_W --height=600 \
            "Install Composer" \
            "Install package (composer require)" \
            "Install package globally (composer global)" \
            "Remove package (composer remove)" \
            "Update packages (composer update)" \
            "Install project dependencies (composer install)" \
            "List installed packages (composer show)" \
            "Install PHP extensions" \
            "$(get_msg "back")" 2>/dev/null)

        [[ -z "$choice" || "$choice" == "$(get_msg "back")" ]] && break

        local pkg
        case "$choice" in
            "Install Composer"*)
                show_terminal_box "Install Composer" \
                    "curl -sS https://getcomposer.org/installer | php && mv composer.phar /usr/local/bin/composer && chmod +x /usr/local/bin/composer && echo 'Composer installed'"
                ;;
            "Install package (composer"*)
                pkg=$(zenity --entry --title="composer require" \
                    --text="Package (e.g. vendor/package):" --width=400)
                [[ -n "$pkg" ]] && show_terminal_box "composer require $pkg" "composer require \"$pkg\""
                ;;
            "Install package globally"*)
                pkg=$(zenity --entry --title="composer global require" \
                    --text="Package:" --width=400)
                [[ -n "$pkg" ]] && show_terminal_box "composer global require $pkg" "composer global require \"$pkg\""
                ;;
            "Remove package"*)
                pkg=$(zenity --entry --title="composer remove" \
                    --text="Package:" --width=400)
                [[ -n "$pkg" ]] && show_terminal_box "composer remove $pkg" "composer remove \"$pkg\""
                ;;
            "Update packages"*)
                show_terminal_box "composer update" "composer update"
                ;;
            "Install project"*)
                show_terminal_box "composer install" "composer install"
                ;;
            "List installed"*)
                show_terminal_box "composer show" "composer show 2>/dev/null"
                ;;
            "Install PHP extensions"*)
                pkg=$(zenity --entry --title="Install PHP extension" \
                    --text="Extension name(s) space-separated (e.g. mbstring curl gd):" --width=500)
                if [[ -n "$pkg" ]]; then
                    local pm; pm=$(detect_package_manager)
                    local cmd=""
                    for ext in $pkg; do
                        case $pm in
                            apt)    cmd+="apt install -y \"php-${ext}\" 2>/dev/null || apt install -y \"php\$(php -r 'echo PHP_MAJOR_VERSION.\".\".PHP_MINOR_VERSION;')-${ext}\"; " ;;
                            dnf)    cmd+="dnf install -y \"php-${ext}\"; " ;;
                            pacman) cmd+="pacman -S --noconfirm \"php-${ext}\"; " ;;
                            *)      cmd+="echo 'Install php-${ext} manually'; " ;;
                        esac
                    done
                    show_terminal_box "Install PHP extensions" "$cmd"
                fi
                ;;
        esac
    done
}

haskell_tools_gui() {
    while true; do
        local choice
        choice=$(zenity --list \
            --title="$(get_msg "haskell_tools")" --column="" \
            --width=$ZENITY_W --height=500 \
            "Install package with cabal" \
            "Install package with stack" \
            "List cabal packages" \
            "Update cabal package list" \
            "Update GHC via ghcup" \
            "Build project (cabal build)" \
            "Build project (stack build)" \
            "Install via GHCup" \
            "$(get_msg "back")" 2>/dev/null)

        [[ -z "$choice" || "$choice" == "$(get_msg "back")" ]] && break

        local pkg
        case "$choice" in
            "Install package with cabal"*)
                pkg=$(zenity --entry --title="cabal install" --text="Package name:" --width=400)
                [[ -n "$pkg" ]] && show_terminal_box "cabal install $pkg" "cabal install \"$pkg\""
                ;;
            "Install package with stack"*)
                pkg=$(zenity --entry --title="stack install" --text="Package name:" --width=400)
                [[ -n "$pkg" ]] && show_terminal_box "stack install $pkg" "stack install \"$pkg\""
                ;;
            "List cabal"*)
                show_terminal_box "ghc-pkg list" "ghc-pkg list 2>/dev/null"
                ;;
            "Update cabal"*)
                show_terminal_box "cabal update" "cabal update"
                ;;
            "Update GHC"*)
                show_terminal_box "ghcup upgrade" "ghcup upgrade"
                ;;
            "Build project (cabal"*)
                show_terminal_box "cabal build" "cabal build"
                ;;
            "Build project (stack"*)
                show_terminal_box "stack build" "stack build"
                ;;
            "Install via GHCup"*)
                show_terminal_box "Install GHCup" \
                    "curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | sh"
                ;;
        esac
    done
}

scientific_tools_gui() {
    while true; do
        local has_spack=0 has_conda=0 has_mamba=0
        command -v spack &>/dev/null && has_spack=1
        command -v conda &>/dev/null && has_conda=1
        command -v mamba &>/dev/null && has_mamba=1

        local status="Spack: $([ $has_spack -eq 1 ] && echo '✓' || echo '✗')  Conda: $([ $has_conda -eq 1 ] && echo '✓' || echo '✗')  Mamba: $([ $has_mamba -eq 1 ] && echo '✓' || echo '✗')"

        local choice
        choice=$(zenity --list \
            --title="$(get_msg "scientific_tools") — $status" \
            --column="" \
            --width=$ZENITY_W --height=600 \
            "Install Spack" \
            "Install with Spack" \
            "Install Miniconda (conda)" \
            "Install with conda" \
            "Install Mamba (faster conda)" \
            "Install with mamba" \
            "Create conda environment" \
            "List conda environments" \
            "$(get_msg "back")" 2>/dev/null)

        [[ -z "$choice" || "$choice" == "$(get_msg "back")" ]] && break

        local pkg
        case "$choice" in
            "Install Spack"*)
                show_terminal_box "Install Spack" \
                    "git clone -c feature.manyFiles=true https://github.com/spack/spack.git \$HOME/spack && echo 'source \$HOME/spack/share/spack/setup-env.sh' >> \$HOME/.bashrc && echo 'Spack installed. Restart terminal.'"
                ;;
            "Install with Spack"*)
                pkg=$(zenity --entry --title="spack install" --text="Package name:" --width=400)
                [[ -n "$pkg" ]] && \
                    show_terminal_box "spack install $pkg" \
                    "source \$HOME/spack/share/spack/setup-env.sh 2>/dev/null; spack install \"$pkg\""
                ;;
            "Install Miniconda"*)
                show_terminal_box "Install Miniconda" \
                    "ARCH=\$(uname -m); curl -fsSL \"https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-\${ARCH}.sh\" -o /tmp/miniconda.sh && bash /tmp/miniconda.sh -b -p \$HOME/miniconda3 && \$HOME/miniconda3/bin/conda init bash && echo 'Miniconda installed. Restart terminal.'"
                ;;
            "Install with conda"*)
                pkg=$(zenity --entry --title="conda install" --text="Package name:" --width=400)
                [[ -n "$pkg" ]] && show_terminal_box "conda install $pkg" "conda install -y \"$pkg\""
                ;;
            "Install Mamba"*)
                show_terminal_box "Install Mamba" \
                    "conda install -y -c conda-forge mamba && echo 'Mamba installed'"
                ;;
            "Install with mamba"*)
                pkg=$(zenity --entry --title="mamba install" --text="Package name:" --width=400)
                [[ -n "$pkg" ]] && show_terminal_box "mamba install $pkg" "mamba install -y \"$pkg\""
                ;;
            "Create conda environment"*)
                local ename pyver
                ename=$(zenity --entry --title="conda create" --text="Environment name:" --width=400)
                pyver=$(zenity --entry --title="conda create" \
                    --text="Python version (e.g. 3.11, leave blank for default):" --width=400)
                if [[ -n "$ename" ]]; then
                    local cmd
                    [[ -n "$pyver" ]] && cmd="conda create -y -n \"$ename\" python=\"$pyver\"" \
                                      || cmd="conda create -y -n \"$ename\""
                    show_terminal_box "conda create $ename" "$cmd && echo 'Activate: conda activate $ename'"
                fi
                ;;
            "List conda environments"*)
                show_terminal_box "conda env list" "conda env list"
                ;;
        esac
    done
}

# ─── شاشة "حول البرنامج" ─────────────────────────────────────────────────────
show_about() {
    local msg
    if [[ "$CURRENT_LANG" == "ar" ]]; then
        msg="GT-CLPM - مدير حزم سطر الأوامر من جنوتكس\n"
        msg+="الإصدار: 1.4.0 | الرخصة: GPLv2 | المطور: GNUTUX\n\n"
        msg+="مديرو الحزم المدعومون (13):\n"
        msg+="APT • DNF/YUM • Pacman • Zypper • Eopkg • XBPS\n"
        msg+="Emerge • PKG • APK • Nix • Homebrew • Flatpak • Snap\n\n"
        msg+="أدوات اللغات:\n"
        msg+="Python (pip/pipx/venv) • Node.js (npm/yarn/pnpm)\n"
        msg+="Ruby (gem/bundler) • Rust (cargo/rustup)\n"
        msg+="Go • Java (maven/gradle/sdkman) • PHP (composer)\n"
        msg+="Haskell (cabal/stack/ghcup) • Scientific (Spack/Conda/Mamba)\n\n"
        msg+="الجديد في v1.4.0:\n"
        msg+="✓ إصلاح بحث Flatpak (نتائج صحيحة)\n"
        msg+="✓ جميع أدوات اللغات مكتملة\n"
        msg+="✓ إدارة المستودعات (PPA/COPR/AUR)\n"
        msg+="✓ دعم Homebrew و Scientific tools"
    else
        msg="GT-CLPM - GNUTUX Command Line Package Manager\n"
        msg+="Version: 1.4.0 | License: GPLv2 | Developer: GNUTUX\n\n"
        msg+="Supported Package Managers (13):\n"
        msg+="APT • DNF/YUM • Pacman • Zypper • Eopkg • XBPS\n"
        msg+="Emerge • PKG • APK • Nix • Homebrew • Flatpak • Snap\n\n"
        msg+="Language Tools:\n"
        msg+="Python (pip/pipx/venv) • Node.js (npm/yarn/pnpm)\n"
        msg+="Ruby (gem/bundler) • Rust (cargo/rustup)\n"
        msg+="Go • Java (maven/gradle/sdkman) • PHP (composer)\n"
        msg+="Haskell (cabal/stack/ghcup) • Scientific (Spack/Conda/Mamba)\n\n"
        msg+="New in v1.4.0:\n"
        msg+="✓ Fixed Flatpak search (correct results, no false filters)\n"
        msg+="✓ All language tool menus fully implemented\n"
        msg+="✓ Repository management (PPA/COPR/AUR/Packman)\n"
        msg+="✓ Homebrew + Scientific tools (Spack/Conda/Mamba)"
    fi
    zenity --info --title="$(get_msg "about")" \
        --text="$msg" --width=600 --height=500
}

change_language() {
    if [[ "$CURRENT_LANG" == "en" ]]; then
        CURRENT_LANG="ar"; echo "ar" > "$LANG_FILE"
    else
        CURRENT_LANG="en"; echo "en" > "$LANG_FILE"
    fi
    zenity --info --title="GT-CLPM" \
        --text="$(get_msg "lang_changed")" --width=400
}

change_theme() {
    local choice
    if [[ "$CURRENT_LANG" == "ar" ]]; then
        choice=$(zenity --list --title="$(get_msg "change_theme")" \
            --column="" --width=300 --height=180 "فاتح" "داكن" 2>/dev/null)
        [[ "$choice" == "داكن" ]] && CURRENT_MODE="dark" || CURRENT_MODE="light"
    else
        choice=$(zenity --list --title="$(get_msg "change_theme")" \
            --column="" --width=300 --height=180 "Light" "Dark" 2>/dev/null)
        [[ "$choice" == "Dark" ]] && CURRENT_MODE="dark" || CURRENT_MODE="light"
    fi
    echo "$CURRENT_MODE" > "$MODE_FILE"
    set_zenity_env
    zenity --info --title="GT-CLPM" \
        --text="$(get_msg "theme_changed")" --width=300
}

# ─── القوائم الرئيسية ─────────────────────────────────────────────────────────
package_manager_menu() {
    while true; do
        local choice
        choice=$(zenity --list \
            --title="$(get_msg "package_manager") — $(detect_package_manager)" \
            --column="" \
            --width=$ZENITY_W --height=700 \
            "$(get_msg "install")" \
            "$(get_msg "remove")" \
            "$(get_msg "smart_remove")" \
            "$(get_msg "search_apps")" \
            "$(get_msg "search_all")" \
            "$(get_msg "update")" \
            "$(get_msg "list")" \
            "$(get_msg "info")" \
            "$(get_msg "fix")" \
            "$(get_msg "clean")" \
            "$(get_msg "add_repo")" \
            "$(get_msg "back")" 2>/dev/null)

        [[ -z "$choice" || "$choice" == "$(get_msg "back")" ]] && break

        case "$choice" in
            "$(get_msg "install")")
                local pkg
                pkg=$(zenity --entry --title="$(get_msg "install")" \
                    --text="$(get_msg "enter_package")" --width=400)
                [[ -n "$pkg" ]] && install_package "$pkg"
                ;;
            "$(get_msg "remove")")
                local pkg
                pkg=$(zenity --entry --title="$(get_msg "remove")" \
                    --text="$(get_msg "enter_package")" --width=400)
                if [[ -n "$pkg" ]]; then
                    zenity --question --title="$(get_msg "remove")" \
                        --text="$(get_msg "confirm_remove")\n\n$pkg" --width=400
                    [[ $? -eq 0 ]] && remove_package "$pkg"
                fi
                ;;
            "$(get_msg "smart_remove")")
                smart_remove_system ;;
            "$(get_msg "search_apps")")
                local q
                q=$(zenity --entry --title="$(get_msg "search_apps")" \
                    --text="$(get_msg "enter_package")" --width=400)
                [[ -n "$q" ]] && search_and_install_system "$q"
                ;;
            "$(get_msg "search_all")")
                local q
                q=$(zenity --entry --title="$(get_msg "search_all")" \
                    --text="$(get_msg "enter_package")" --width=400)
                [[ -n "$q" ]] && search_and_install_system "$q"
                ;;
            "$(get_msg "update")")
                update_submenu ;;
            "$(get_msg "list")")
                list_packages ;;
            "$(get_msg "info")")
                local pkg
                pkg=$(zenity --entry --title="$(get_msg "info")" \
                    --text="$(get_msg "enter_package")" --width=400)
                [[ -n "$pkg" ]] && package_info "$pkg"
                ;;
            "$(get_msg "fix")")
                fix_packages ;;
            "$(get_msg "clean")")
                clean_cache ;;
            "$(get_msg "add_repo")")
                add_repository_gui ;;
        esac
    done
}

flatpak_menu() {
    check_flatpak || return
    while true; do
        local choice
        choice=$(zenity --list \
            --title="$(get_msg "flatpak_manager")" \
            --column="" \
            --width=$ZENITY_W --height=600 \
            "$(get_msg "install_flatpak")" \
            "$(get_msg "remove_flatpak")" \
            "$(get_msg "smart_remove_flatpak")" \
            "$(get_msg "search_flatpak")" \
            "$(get_msg "update_flatpak")" \
            "$(get_msg "list_flatpak")" \
            "$(get_msg "add_flatpak_repo")" \
            "$(get_msg "refresh_flathub")" \
            "$(get_msg "back")" 2>/dev/null)

        [[ -z "$choice" || "$choice" == "$(get_msg "back")" ]] && break

        case "$choice" in
            "$(get_msg "install_flatpak")")
                local method
                method=$(zenity --list \
                    --title="$(get_msg "install_flatpak")" \
                    --column="" --width=400 --height=180 \
                    "$(get_msg "search_flatpak")" \
                    "$(get_msg "manual_entry") (Application ID)" 2>/dev/null)
                case "$method" in
                    "$(get_msg "search_flatpak")"*)
                        local q
                        q=$(zenity --entry --title="$(get_msg "search_flatpak")" \
                            --text="$(get_msg "enter_package")" --width=400)
                        [[ -n "$q" ]] && search_and_install_flatpak "$q"
                        ;;
                    "$(get_msg "manual_entry")"*)
                        local pkg
                        pkg=$(zenity --entry \
                            --title="$(get_msg "manual_entry")" \
                            --text="$(get_msg "enter_appid")\n\n⚠️ يجب أن يكون بصيغة: org.inkscape.Inkscape\nMust be in format: org.inkscape.Inkscape" \
                            --width=520)
                        if [[ -n "$pkg" ]]; then
                            pkg=$(echo "$pkg" | sed 's/[[:space:]]//g')
                            # التحقق من صحة المعرّف — إن كان مجرد اسم يُحوَّل إلى بحث
                            if ! _valid_flatpak_id "$pkg" &>/dev/null; then
                                zenity --info --title="⚠️ GT-CLPM" \
                                    --text="المعرّف '$pkg' غير صالح.\nInvalid ID '$pkg'.\n\n⚠️ يجب أن يحتوي على نقطتين على الأقل (مثال: org.inkscape.Inkscape)\nMust contain at least 2 dots.\n\n🔍 جاري البحث عنه تلقائياً...\nSearching automatically..." \
                                    --width=500
                                search_and_install_flatpak "$pkg"
                            else
                                zenity --question --title="📦 GT-CLPM" \
                                    --text="$(get_msg "confirm_install")\n\n📦 $pkg" --width=420
                                [[ $? -eq 0 ]] && \
                                    show_terminal_box "📦 $(get_msg "installing") $pkg" \
                                    "flatpak install -y flathub \"$pkg\""
                            fi
                        fi
                        ;;
                esac
                ;;
            "$(get_msg "remove_flatpak")")
                local pkg
                pkg=$(zenity --entry --title="$(get_msg "remove_flatpak")" \
                    --text="$(get_msg "enter_appid")" --width=500)
                if [[ -n "$pkg" ]]; then
                    zenity --question --title="$(get_msg "remove_flatpak")" \
                        --text="$(get_msg "confirm_remove")\n\n$pkg" --width=400
                    [[ $? -eq 0 ]] && \
                        show_terminal_box "$(get_msg "removing") $pkg" \
                        "flatpak uninstall -y \"$pkg\""
                fi
                ;;
            "$(get_msg "smart_remove_flatpak")")
                smart_remove_flatpak ;;
            "$(get_msg "search_flatpak")")
                local q
                q=$(zenity --entry --title="$(get_msg "search_flatpak")" \
                    --text="$(get_msg "enter_package")" --width=400)
                [[ -n "$q" ]] && search_and_install_flatpak "$q"
                ;;
            "$(get_msg "update_flatpak")")
                show_terminal_box "$(get_msg "update_flatpak")" "flatpak update -y"
                ;;
            "$(get_msg "list_flatpak")")
                show_terminal_box "$(get_msg "list_flatpak")" "flatpak list"
                ;;
            "$(get_msg "add_flatpak_repo")")
                local repo
                repo=$(zenity --entry --title="$(get_msg "add_flatpak_repo")" \
                    --text="$(get_msg "enter_repo")" --width=500)
                [[ -n "$repo" ]] && \
                    show_terminal_box "$(get_msg "add_flatpak_repo")" \
                    "flatpak remote-add --if-not-exists custom \"$repo\""
                ;;
            "$(get_msg "refresh_flathub")")
                show_terminal_box "$(get_msg "refresh_flathub")" \
                    "flatpak remote-modify --enable flathub 2>/dev/null; flatpak update --appstream"
                ;;
        esac
    done
}

snap_menu() {
    check_snap || return
    while true; do
        local choice
        choice=$(zenity --list \
            --title="$(get_msg "snap_manager")" \
            --column="" \
            --width=$ZENITY_W --height=600 \
            "$(get_msg "install_snap")" \
            "$(get_msg "remove_snap")" \
            "$(get_msg "smart_remove_snap")" \
            "$(get_msg "search_snap")" \
            "$(get_msg "update_snap")" \
            "$(get_msg "list_snap")" \
            "$(get_msg "enable_snap")" \
            "$(get_msg "back")" 2>/dev/null)

        [[ -z "$choice" || "$choice" == "$(get_msg "back")" ]] && break

        case "$choice" in
            "$(get_msg "install_snap")")
                local pkg
                pkg=$(zenity --entry --title="$(get_msg "install_snap")" \
                    --text="$(get_msg "enter_package")" --width=400)
                if [[ -n "$pkg" ]]; then
                    local mode
                    mode=$(zenity --list --title="Install mode" --column="" \
                        --width=300 --height=200 "Normal" "Classic" "Devmode" 2>/dev/null)
                    local cmd="snap install \"$pkg\""
                    [[ "$mode" == "Classic" ]]  && cmd="snap install \"$pkg\" --classic"
                    [[ "$mode" == "Devmode" ]] && cmd="snap install \"$pkg\" --devmode"
                    show_terminal_box "$(get_msg "installing") $pkg (snap)" "$cmd"
                fi
                ;;
            "$(get_msg "remove_snap")")
                local pkg
                pkg=$(zenity --entry --title="$(get_msg "remove_snap")" \
                    --text="$(get_msg "enter_package")" --width=400)
                if [[ -n "$pkg" ]]; then
                    zenity --question --title="$(get_msg "remove_snap")" \
                        --text="$(get_msg "confirm_remove")\n\n$pkg" --width=400
                    [[ $? -eq 0 ]] && \
                        show_terminal_box "$(get_msg "removing") $pkg (snap)" \
                        "snap remove \"$pkg\""
                fi
                ;;
            "$(get_msg "smart_remove_snap")")
                smart_remove_snap ;;
            "$(get_msg "search_snap")")
                local q
                q=$(zenity --entry --title="$(get_msg "search_snap")" \
                    --text="$(get_msg "enter_package")" --width=400)
                [[ -n "$q" ]] && \
                    show_terminal_box "$(get_msg "searching") $q (snap)" \
                    "snap find \"$q\""
                ;;
            "$(get_msg "update_snap")")
                show_terminal_box "$(get_msg "update_snap")" "snap refresh"
                ;;
            "$(get_msg "list_snap")")
                show_terminal_box "$(get_msg "list_snap")" "snap list"
                ;;
            "$(get_msg "enable_snap")")
                show_terminal_box "$(get_msg "enable_snap")" \
                    "systemctl enable --now snapd.socket"
                ;;
        esac
    done
}

other_installers_menu() {
    while true; do
        local choice
        choice=$(zenity --list \
            --title="$(get_msg "other_installers")" \
            --column="" \
            --width=$ZENITY_W --height=700 \
            "$(get_msg "python_tools")" \
            "$(get_msg "nodejs_tools")" \
            "$(get_msg "ruby_tools")" \
            "$(get_msg "rust_tools")" \
            "$(get_msg "go_tools")" \
            "$(get_msg "java_tools")" \
            "$(get_msg "php_tools")" \
            "$(get_msg "haskell_tools")" \
            "$(get_msg "scientific_tools")" \
            "$(get_msg "back")" 2>/dev/null)

        [[ -z "$choice" || "$choice" == "$(get_msg "back")" ]] && break

        case "$choice" in
            "$(get_msg "python_tools")")    python_tools_gui ;;
            "$(get_msg "nodejs_tools")")    nodejs_tools_gui ;;
            "$(get_msg "ruby_tools")")      ruby_tools_gui ;;
            "$(get_msg "rust_tools")")      rust_tools_gui ;;
            "$(get_msg "go_tools")")        go_tools_gui ;;
            "$(get_msg "java_tools")")      java_tools_gui ;;
            "$(get_msg "php_tools")")       php_tools_gui ;;
            "$(get_msg "haskell_tools")")   haskell_tools_gui ;;
            "$(get_msg "scientific_tools")") scientific_tools_gui ;;
        esac
    done
}

system_tools_menu() {
    while true; do
        local choice
        choice=$(zenity --list \
            --title="$(get_msg "system_tools")" \
            --column="" \
            --width=$ZENITY_W --height=400 \
            "$(get_msg "backup_packages")" \
            "$(get_msg "restore_packages")" \
            "$(get_msg "system_info")" \
            "$(get_msg "disk_usage")" \
            "$(get_msg "back")" 2>/dev/null)

        [[ -z "$choice" || "$choice" == "$(get_msg "back")" ]] && break

        case "$choice" in
            "$(get_msg "backup_packages")")  backup_packages ;;
            "$(get_msg "restore_packages")") restore_packages ;;
            "$(get_msg "system_info")")      show_system_info ;;
            "$(get_msg "disk_usage")")       show_disk_usage ;;
        esac
    done
}

change_ui_tool() {
    local cur_label
    [[ "$UI_TOOL" == "zenity" ]] && cur_label="Zenity (GTK)" || cur_label="KDialog (Qt/KDE)"

    local choice
    choice=$(zenity --list \
        --title="$(get_msg "change_ui_tool")" \
        --column="" --width=450 --height=200 \
        "Zenity (GTK — GNOME/XFCE/...)" \
        "KDialog (Qt — KDE/...)" \
        "$(get_msg "back")" 2>/dev/null)

    [[ -z "$choice" || "$choice" == "$(get_msg "back")" ]] && return

    local new_tool=""
    case "$choice" in
        "Zenity"*)  new_tool="zenity"  ;;
        "KDialog"*) new_tool="kdialog" ;;
    esac

    # إن اختار المستخدم نفس الأداة الحالية لا داعي للتغيير
    if [[ "$new_tool" == "$UI_TOOL" ]]; then
        zenity --info --title="GT-CLPM" \
            --text="$(get_msg "ui_tool_changed")\n\n$choice $(get_msg "installed")" --width=400
        return
    fi

    echo "$new_tool" > "$UI_FILE"

    # سؤال إعادة التشغيل
    local restart_msg restart_q
    if [[ "$CURRENT_LANG" == "ar" ]]; then
        restart_msg="$(get_msg "ui_tool_changed")\n\nهل تريد إعادة تشغيل البرنامج الآن لتفعيل التغيير؟"
    else
        restart_msg="$(get_msg "ui_tool_changed")\n\nRestart the program now to apply the change?"
    fi

    zenity --question --title="GT-CLPM" --text="$restart_msg" --width=420
    if [[ $? -eq 0 ]]; then
        exec bash "$0" "$@"
    fi
}


# ─── فحص التحديثات ────────────────────────────────────────────────────────────
CURRENT_APP_VERSION="1.5.0"
VERSION_CHECK_URL="https://raw.githubusercontent.com/SalehGNUTUX/GT-CLPM/main/GT-CLPM/gt-clpm-gui.sh"
UNINSTALLER_LOCAL="$HOME/.local/share/gt-clpm/uninstall-gui.sh"
UNINSTALLER_REMOTE="https://raw.githubusercontent.com/SalehGNUTUX/GT-CLPM/main/uninstall-gui.sh"

check_for_updates() {
    local latest
    zenity --info --title="GT-CLPM" \
        --text="$(get_msg "check_update")..." --width=300 --timeout=1 2>/dev/null || true

    if command -v curl &>/dev/null; then
        latest=$(curl -fsSL --max-time 8 "$VERSION_CHECK_URL" 2>/dev/null \
            | grep -m1 "^# Version:" | sed 's/# Version: *//')
    elif command -v wget &>/dev/null; then
        latest=$(wget -qO- --timeout=8 "$VERSION_CHECK_URL" 2>/dev/null \
            | grep -m1 "^# Version:" | sed 's/# Version: *//')
    fi

    if [[ -z "$latest" ]]; then
        zenity --warning --title="GT-CLPM" \
            --text="$(get_msg "update_error")" --width=400
        return
    fi

    if [[ "$latest" == "$CURRENT_APP_VERSION" ]]; then
        zenity --info --title="GT-CLPM" \
            --text="$(get_msg "no_update")\n\nv${CURRENT_APP_VERSION}" --width=380
        return
    fi

    local msg
    if [[ "$CURRENT_LANG" == "ar" ]]; then
        msg="$(get_msg "update_available")\n\nالإصدار الحالي: v${CURRENT_APP_VERSION}\nالإصدار الجديد: v${latest}"
    else
        msg="$(get_msg "update_available")\n\nCurrent: v${CURRENT_APP_VERSION}\nNew:     v${latest}"
    fi

    zenity --question \
        --title="GT-CLPM" \
        --text="$msg" \
        --ok-label="$(get_msg "update_now")" \
        --cancel-label="$(get_msg "remind_later")" \
        --width=400 || return

    local tmp; tmp=$(mktemp /tmp/gt-clpm-install-XXXXXX.sh)
    if command -v curl &>/dev/null; then
        curl -fsSL "https://raw.githubusercontent.com/SalehGNUTUX/GT-CLPM/main/install-gui.sh" -o "$tmp" 2>/dev/null
    else
        wget -qO "$tmp" "https://raw.githubusercontent.com/SalehGNUTUX/GT-CLPM/main/install-gui.sh" 2>/dev/null
    fi
    if [[ -s "$tmp" ]]; then
        chmod +x "$tmp"
        show_terminal_box "GT-CLPM Update" "bash \"$tmp\""
    else
        zenity --error --title="GT-CLPM" --text="$(get_msg "update_error")" --width=400
    fi
    rm -f "$tmp"
}

uninstall_app() {
    zenity --question --title="GT-CLPM" \
        --text="$(get_msg "uninstall_confirm")" --width=420 || return

    local uninstaller=""
    [[ -f "$UNINSTALLER_LOCAL" && -x "$UNINSTALLER_LOCAL" ]] && uninstaller="$UNINSTALLER_LOCAL"

    if [[ -z "$uninstaller" ]]; then
        zenity --question --title="GT-CLPM" \
            --text="$(get_msg "uninstaller_missing")" --width=420 || return
        local tmp; tmp=$(mktemp /tmp/gt-clpm-uninstall-XXXXXX.sh)
        if command -v curl &>/dev/null; then
            curl -fsSL "$UNINSTALLER_REMOTE" -o "$tmp" 2>/dev/null
        else
            wget -qO "$tmp" "$UNINSTALLER_REMOTE" 2>/dev/null
        fi
        if [[ -s "$tmp" ]]; then
            chmod +x "$tmp"
            uninstaller="$tmp"
        else
            zenity --error --title="GT-CLPM" --text="$(get_msg "update_error")" --width=400
            rm -f "$tmp"
            return
        fi
    fi

    for term in x-terminal-emulator gnome-terminal konsole xterm; do
        if command -v "$term" &>/dev/null; then
            case "$term" in
                gnome-terminal) gnome-terminal -- bash -c "bash \"$uninstaller\"; read -p 'Press Enter...' " ;;
                konsole)        konsole -e bash -c "bash \"$uninstaller\"; read -p 'Press Enter...' " ;;
                xterm)          xterm -e bash -c "bash \"$uninstaller\"; read -p 'Press Enter...' " ;;
                *)              "$term" -e bash -c "bash \"$uninstaller\"; read -p 'Press Enter...' " ;;
            esac
            return
        fi
    done
    show_terminal_box "GT-CLPM Uninstall" "bash \"$uninstaller\""
}

settings_menu() {
    while true; do
        local choice
        choice=$(zenity --list \
            --title="$(get_msg "settings")" \
            --column="" \
            --width=420 --height=380 \
            "$(get_msg "change_lang")" \
            "$(get_msg "change_theme")" \
            "$(get_msg "change_ui_tool")" \
            "$(get_msg "check_update")" \
            "$(get_msg "uninstall_app")" \
            "$(get_msg "about")" \
            "$(get_msg "back")" 2>/dev/null)

        [[ -z "$choice" || "$choice" == "$(get_msg "back")" ]] && break

        case "$choice" in
            "$(get_msg "change_lang")")    change_language ;;
            "$(get_msg "change_theme")")   change_theme ;;
            "$(get_msg "change_ui_tool")") change_ui_tool ;;
            "$(get_msg "check_update")")   check_for_updates ;;
            "$(get_msg "uninstall_app")") uninstall_app ;;
            "$(get_msg "about")")          show_about ;;
        esac
    done
}

main_menu() {
    while true; do
        local pm; pm=$(detect_package_manager)
        local choice
        choice=$(zenity --list \
            --title="$(get_msg "main_menu") — GT-CLPM v1.5.0 [$pm]" \
            --column="" \
            --width=$ZENITY_W --height=$ZENITY_H \
            "$(get_msg "package_manager")" \
            "$(get_msg "flatpak_manager")" \
            "$(get_msg "snap_manager")" \
            "$(get_msg "other_installers")" \
            "$(get_msg "system_tools")" \
            "$(get_msg "settings")" \
            "$(get_msg "exit")" 2>/dev/null)

        [[ $? -ne 0 || -z "$choice" || "$choice" == "$(get_msg "exit")" ]] && {
            zenity --info --title="GT-CLPM" \
                --text="$(get_msg "exiting")" --width=400
            exit 0
        }

        case "$choice" in
            "$(get_msg "package_manager")")  package_manager_menu ;;
            "$(get_msg "flatpak_manager")")  flatpak_menu ;;
            "$(get_msg "snap_manager")")     snap_menu ;;
            "$(get_msg "other_installers")") other_installers_menu ;;
            "$(get_msg "system_tools")")     system_tools_menu ;;
            "$(get_msg "settings")")         settings_menu ;;
        esac
    done
}

# ─── فحص تلقائي للتحديثات (مرة واحدة يومياً) ────────────────────────────────
(
    _cache="$HOME/.cache/gt-clpm-update-check"
    _today=$(date +%Y%m%d)
    [[ -f "$_cache" && "$(cat "$_cache" 2>/dev/null)" == "$_today" ]] && exit 0
    echo "$_today" > "$_cache"
    sleep 3
    _latest=""
    if command -v curl &>/dev/null; then
        _latest=$(curl -fsSL --max-time 6 \
            "https://raw.githubusercontent.com/SalehGNUTUX/GT-CLPM/main/GT-CLPM/gt-clpm-gui.sh" \
            2>/dev/null | grep -m1 "^# Version:" | sed 's/# Version: *//')
    elif command -v wget &>/dev/null; then
        _latest=$(wget -qO- --timeout=6 \
            "https://raw.githubusercontent.com/SalehGNUTUX/GT-CLPM/main/GT-CLPM/gt-clpm-gui.sh" \
            2>/dev/null | grep -m1 "^# Version:" | sed 's/# Version: *//')
    fi
    [[ -z "$_latest" || "$_latest" == "1.5.0" ]] && exit 0
    if [[ "$CURRENT_LANG" == "ar" ]]; then
        _msg="🎉 يوجد تحديث متاح!\n\nالإصدار الجديد: v${_latest}\n\nيمكنك التحديث من: الإعدادات ← فحص التحديثات"
    else
        _msg="🎉 Update available!\n\nNew version: v${_latest}\n\nUpdate from: Settings → Check for updates"
    fi
    zenity --info --title="GT-CLPM — Update" --text="$_msg" --width=420 2>/dev/null || true
) &

main_menu
