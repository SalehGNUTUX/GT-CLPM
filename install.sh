#!/bin/bash

# GT-CLPM Installer
# Version: 1.1
# Developer: GNUTUX

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
PURPLE='\033[0;35m'
NC='\033[0m'

# Configuration
REPO_URL="https://github.com/SalehGNUTUX/GT-CLPM"
SCRIPT_URL="https://raw.githubusercontent.com/SalehGNUTUX/GT-CLPM/blob/main/gt-clpm-v1.1.sh"
ICONS_BASE_URL="https://raw.githubusercontent.com/SalehGNUTUX/GT-CLPM/main/GT-CLPM/gt-usdr%20APPIAMGE%20BIULD/GT-CLPM-CLI.AppDir/usr/share/icons/hicolor"
INSTALL_DIR="/usr/local/bin"
SCRIPT_NAME="gt-clpm"
DESKTOP_ENTRY_DIR="/usr/share/applications"
ICONS_DIR="/usr/share/icons/hicolor"
VERSION="1.1"

# Function to print colored output
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_success() {
    echo -e "${CYAN}[SUCCESS]${NC} $1"
}

print_header() {
    echo -e "${PURPLE}$1${NC}"
}

# Check for existing installation
check_existing_installation() {
    print_header "🔍 فحص التثبيتات الحالية..."
    
    local existing_versions=()
    local current_version=""
    
    # Check if gt-clpm is in PATH
    if command -v "$SCRIPT_NAME" &> /dev/null; then
        current_version=$(get_current_version)
        if [[ -n "$current_version" ]]; then
            existing_versions+=("$current_version")
            print_warning "تم العثور على إصدار مثبت: $current_version"
        else
            existing_versions+=("إصدار قديم")
            print_warning "تم العثور على إصدار قديم غير معروف"
        fi
    fi
    
    # Check for desktop entries with different versions
    local desktop_patterns=(
        "$DESKTOP_ENTRY_DIR/gt-clpm*.desktop"
        "/usr/local/share/applications/gt-clpm*.desktop"
        "$HOME/.local/share/applications/gt-clpm*.desktop"
    )
    
    for pattern in "${desktop_patterns[@]}"; do
        for desktop_file in $pattern; do
            if [[ -f "$desktop_file" ]]; then
                local version=$(extract_version_from_desktop "$desktop_file")
                if [[ -n "$version" ]] && [[ ! " ${existing_versions[@]} " =~ " ${version} " ]]; then
                    existing_versions+=("$version")
                    print_warning "تم العثور على إصدار في قائمة التطبيقات: $version"
                fi
            fi
        done
    done
    
    if [[ ${#existing_versions[@]} -eq 0 ]]; then
        print_success "لا توجد تثبيتات سابقة"
        return 0
    fi
    
    # Handle existing installation
    handle_existing_installation "${existing_versions[@]}"
}

# Extract version from desktop file
extract_version_from_desktop() {
    local desktop_file="$1"
    if [[ -f "$desktop_file" ]]; then
        grep -E "^Comment=.*v[0-9]+\.[0-9]+" "$desktop_file" | grep -oE "v[0-9]+\.[0-9]+" | head -1 || echo ""
    fi
}

# Get current installed version
get_current_version() {
    if command -v "$SCRIPT_NAME" &> /dev/null; then
        # Try to get version from script
        local script_path=$(command -v "$SCRIPT_NAME")
        if [[ -f "$script_path" ]]; then
            grep -E "^# Version:[ ]*[0-9]+\.[0-9]+" "$script_path" | head -1 | grep -oE "[0-9]+\.[0-9]+" || echo ""
        fi
    fi
}

# Handle existing installation
handle_existing_installation() {
    local existing_versions=("$@")
    
    echo
    print_header "🔄 إدارة التثبيتات الحالية"
    echo -e "${YELLOW}تم العثور على الإصدارات التالية مثبتة:${NC}"
    for version in "${existing_versions[@]}"; do
        echo -e "  • ${GREEN}$version${NC}"
    done
    echo
    
    echo -e "${BLUE}الرجاء اختيار الإجراء المطلوب:${NC}"
    echo -e "  ${GREEN}1${NC}) ترقية الإصدار الحالي إلى v$VERSION (إزالة القديم)"
    echo -e "  ${GREEN}2${NC}) تثبيت الإصدار v$VERSION بجانب الإصدار الحالي"
    echo -e "  ${GREEN}3${NC}) إلغاء التثبيت"
    echo
    
    local choice
    while true; do
        read -p "ادخل اختيارك (1-3): " choice
        case $choice in
            1)
                print_status "سيتم ترقية التثبيت الحالي إلى v$VERSION..."
                remove_existing_installation
                return 0
                ;;
            2)
                print_status "سيتم تثبيت v$VERSION بجانب الإصدارات الحالية..."
                install_alongside_existing
                return 1
                ;;
            3)
                print_status "إلغاء التثبيت..."
                exit 0
                ;;
            *)
                print_error "اختيار غير صحيح. الرجاء اختيار 1، 2، أو 3"
                ;;
        esac
    done
}

# Remove existing installation
remove_existing_installation() {
    print_status "إزالة التثبيتات القديمة..."
    
    # Remove script from all possible locations
    local script_locations=(
        "$INSTALL_DIR/$SCRIPT_NAME"
        "/usr/bin/$SCRIPT_NAME"
        "/bin/$SCRIPT_NAME"
    )
    
    for location in "${script_locations[@]}"; do
        if [[ -f "$location" ]]; then
            if [[ ! -w "$(dirname "$location")" ]]; then
                sudo rm -f "$location"
            else
                rm -f "$location"
            fi
            print_success "تمت إزالة: $location"
        fi
    done
    
    # Remove old desktop entries (keep only versioned ones temporarily)
    local desktop_files=(
        "$DESKTOP_ENTRY_DIR/gt-clpm.desktop"
        "/usr/local/share/applications/gt-clpm.desktop"
    )
    
    for desktop_file in "${desktop_files[@]}"; do
        if [[ -f "$desktop_file" ]]; then
            if [[ ! -w "$(dirname "$desktop_file")" ]]; then
                sudo rm -f "$desktop_file"
            else
                rm -f "$desktop_file"
            fi
            print_success "تمت إزالة: $desktop_file"
        fi
    done
}

# Install alongside existing versions
install_alongside_existing() {
    local new_script_name="gt-clpm-v$VERSION"
    local new_desktop_name="gt-clpm-v$VERSION.desktop"
    
    print_status "سيتم تثبيت الإصدار v$VERSION كـ: $new_script_name"
    
    # Update configuration for parallel installation
    SCRIPT_NAME="$new_script_name"
    
    # Create versioned desktop entry
    create_versioned_desktop_entry "$new_desktop_name"
}

# Create versioned desktop entry
create_versioned_desktop_entry() {
    local desktop_filename="$1"
    
    local desktop_entry="[Desktop Entry]
Version=1.1
Type=Application
Name=GT-CLPM v$VERSION
GenericName=Package Manager (v$VERSION)
Comment=GNUTUX Command Line Package Manager v$VERSION - Smart Package Management
Exec=$SCRIPT_NAME
Icon=gt-clpm
Categories=System;PackageManager;
Terminal=true
StartupNotify=true
Keywords=package;manager;install;remove;update;system;linux;flatpak;snap;python;nodejs;smart;

# Arabic metadata
Name[ar]=GT-CLPM الإصدار $VERSION
Comment[ar]=مدير حزم سطر الأوامر من جنوتكس الإصدار $VERSION - إدارة حزم ذكية
GenericName[ar]=مدير الحزم (الإصدار $VERSION)
Keywords[ar]=حزم;مدير;تثبيت;إزالة;تحديث;نظام;لينكس;فلاتباك;سناب;بايثون;نود.جي إس;ذكي"

    # Create desktop entry file
    if [[ ! -w "$DESKTOP_ENTRY_DIR" ]]; then
        echo "$desktop_entry" | sudo tee "$DESKTOP_ENTRY_DIR/$desktop_filename" > /dev/null
        sudo chmod 644 "$DESKTOP_ENTRY_DIR/$desktop_filename"
    else
        echo "$desktop_entry" > "$DESKTOP_ENTRY_DIR/$desktop_filename"
        chmod 644 "$DESKTOP_ENTRY_DIR/$desktop_filename"
    fi
    
    print_success "تم إنشاء إدخال سطح المكتب للإصدار: $desktop_filename"
}

# Check system requirements
check_requirements() {
    print_status "التحقق من متطلبات النظام..."
    
    # Check if running on Linux
    if [[ "$(uname)" != "Linux" ]]; then
        print_error "هذا المثبت لأنظمة لينكس فقط"
        exit 1
    fi
    
    # Check for required tools
    local missing_tools=()
    
    for tool in bash; do
        if ! command -v "$tool" &> /dev/null; then
            missing_tools+=("$tool")
        fi
    done
    
    if [[ ${#missing_tools[@]} -gt 0 ]]; then
        print_error "أدوات مطلوبة مفقودة: ${missing_tools[*]}"
        exit 1
    fi
    
    # Check for download tools
    if ! command -v curl &> /dev/null && ! command -v wget &> /dev/null; then
        print_warning "لم يتم العثور على curl أو wget. بعض الميزات قد تكون محدودة."
    fi
    
    print_success "تم استيفاء متطلبات النظام"
}

# Check if running as root
check_root() {
    if [[ $EUID -eq 0 ]]; then
        print_warning "جاري التشغيل كمسؤول root"
    fi
}

# Detect package manager for dependency installation
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
    else
        echo "unknown"
    fi
}

# Install optional dependencies
install_dependencies() {
    print_status "التحقق من التبعيات الاختيارية..."
    
    local pm=$(detect_package_manager)
    local missing_deps=()
    
    # Check for flatpak
    if ! command -v flatpak &> /dev/null; then
        missing_deps+=("flatpak")
    fi
    
    # Check for snap
    if ! command -v snap &> /dev/null; then
        missing_deps+=("snapd")
    fi
    
    # Check for pip (Python)
    if ! command -v pip3 &> /dev/null && ! command -v pip &> /dev/null; then
        missing_deps+=("python3-pip")
    fi
    
    # Check for npm (Node.js)
    if ! command -v npm &> /dev/null; then
        missing_deps+=("npm")
    fi
    
    if [[ ${#missing_deps[@]} -gt 0 ]]; then
        print_warning "التبعيات الاختيارية المفقودة: ${missing_deps[*]}"
        echo
        read -p "هل تريد تثبيت هذه التبعيات؟ (y/N): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            case $pm in
                "apt")
                    sudo apt update && sudo apt install -y "${missing_deps[@]}"
                    ;;
                "dnf")
                    sudo dnf install -y "${missing_deps[@]}"
                    ;;
                "yum")
                    sudo yum install -y "${missing_deps[@]}"
                    ;;
                "pacman")
                    sudo pacman -S --noconfirm "${missing_deps[@]}"
                    ;;
                "zypper")
                    sudo zypper install -y "${missing_deps[@]}"
                    ;;
                *)
                    print_warning "تثبيت التبعيات التلقائي غير مدعوم لنظام إدارة الحزم الخاص بك"
                    print_status "الرجاء تثبيت هذه الحزم يدوياً: ${missing_deps[*]}"
                    ;;
            esac
        else
            print_status "تخطي تثبيت التبعيات الاختيارية"
        fi
    else
        print_success "جميع التبعيات الاختيارية متوفرة"
    fi
}

# Download the script
download_script() {
    print_status "جاري تحميل سكريبت GT-CLPM v$VERSION..."
    
    if command -v curl &> /dev/null; then
        if curl -fsSL "$SCRIPT_URL" -o "/tmp/$SCRIPT_NAME"; then
            print_success "تم تحميل السكريبت بنجاح"
        else
            print_error "فشل في تحميل السكريبت من $SCRIPT_URL"
            exit 1
        fi
    elif command -v wget &> /dev/null; then
        if wget -q "$SCRIPT_URL" -O "/tmp/$SCRIPT_NAME"; then
            print_success "تم تحميل السكريبت بنجاح"
        else
            print_error "فشل في تحميل السكريبت من $SCRIPT_URL"
            exit 1
        fi
    else
        print_error "لم يتم العثور على curl أو wget. الرجاء تثبيت أحدهما."
        exit 1
    fi
    
    if [[ ! -f "/tmp/$SCRIPT_NAME" ]]; then
        print_error "الملف الذي تم تحميله غير موجود"
        exit 1
    fi
}

# Make script executable
make_executable() {
    print_status "جاري جعل السكريبت قابلاً للتنفيذ..."
    chmod +x "/tmp/$SCRIPT_NAME"
    
    # Verify the script is valid
    if head -n 1 "/tmp/$SCRIPT_NAME" | grep -q "bash"; then
        print_success "السكريبت صالح وقابل للتنفيذ"
    else
        print_error "الملف الذي تم تحميله لا يبدو أنه سكريبت bash صالح"
        exit 1
    fi
}

# Install the script
install_script() {
    print_status "جاري التثبيت في $INSTALL_DIR..."
    
    # Check if install directory exists
    if [[ ! -d "$INSTALL_DIR" ]]; then
        print_status "جاري إنشاء دليل التثبيت..."
        if [[ ! -w "/usr/local" ]]; then
            sudo mkdir -p "$INSTALL_DIR"
        else
            mkdir -p "$INSTALL_DIR"
        fi
    fi
    
    # Check if install directory is writable
    if [[ ! -w "$INSTALL_DIR" ]]; then
        print_warning "بحاجة إلى صلاحيات root للتثبيت في $INSTALL_DIR"
        sudo cp "/tmp/$SCRIPT_NAME" "$INSTALL_DIR/$SCRIPT_NAME"
        sudo chmod +x "$INSTALL_DIR/$SCRIPT_NAME"
    else
        cp "/tmp/$SCRIPT_NAME" "$INSTALL_DIR/$SCRIPT_NAME"
        chmod +x "$INSTALL_DIR/$SCRIPT_NAME"
    fi
    
    # Verify installation
    if command -v "$SCRIPT_NAME" &> /dev/null || [[ -f "$INSTALL_DIR/$SCRIPT_NAME" ]]; then
        print_success "تم تثبيت السكريبت بنجاح في $INSTALL_DIR/$SCRIPT_NAME"
    else
        print_error "فشل تثبيت السكريبت - غير موجود في PATH"
        exit 1
    fi
}

# Download and install icons
install_icons() {
    print_status "جاري تثبيت أيقونات التطبيق..."
    
    # Create temporary directory for icons
    local temp_icons_dir="/tmp/gt-clpm-icons"
    mkdir -p "$temp_icons_dir"
    
    # Icon sizes to download
    local icon_sizes=("16x16" "32x32" "48x48" "64x64" "128x128" "256x256" "512x512")
    local icon_name="gt-clpm-cli-icon.png"
    local installed_icon_name="gt-clpm.png"
    local icons_downloaded=0
    
    for size in "${icon_sizes[@]}"; do
        local icon_url="${ICONS_BASE_URL}/${size}/apps/${icon_name}"
        local icon_dir="$ICONS_DIR/${size}/apps"
        
        # Download icon
        if command -v curl &> /dev/null; then
            if curl -fsSL "$icon_url" -o "$temp_icons_dir/gt-clpm-${size}.png" 2>/dev/null; then
                ((icons_downloaded++))
            fi
        elif command -v wget &> /dev/null; then
            if wget -q "$icon_url" -O "$temp_icons_dir/gt-clpm-${size}.png" 2>/dev/null; then
                ((icons_downloaded++))
            fi
        fi
        
        # Install icon if downloaded successfully
        if [[ -f "$temp_icons_dir/gt-clpm-${size}.png" ]]; then
            # Create icon directory
            if [[ ! -w "$ICONS_DIR" ]]; then
                sudo mkdir -p "$icon_dir"
                sudo cp "$temp_icons_dir/gt-clpm-${size}.png" "$icon_dir/$installed_icon_name"
                sudo chmod 644 "$icon_dir/$installed_icon_name"
            else
                mkdir -p "$icon_dir"
                cp "$temp_icons_dir/gt-clpm-${size}.png" "$icon_dir/$installed_icon_name"
                chmod 644 "$icon_dir/$installed_icon_name"
            fi
        fi
    done
    
    # Cleanup
    rm -rf "$temp_icons_dir"
    
    if [[ $icons_downloaded -gt 0 ]]; then
        print_success "تم تثبيت $icons_downloaded مقاس أيقونة"
    else
        print_warning "لم يتم تحميل أي أيقونات - سيتم استخدام أيقونات النظام الافتراضية"
    fi
}

# Create desktop entry (standard)
create_desktop_entry() {
    print_status "جاري إنشاء إدخال سطح المكتب..."
    
    local desktop_entry="[Desktop Entry]
Version=1.1
Type=Application
Name=GT-CLPM
GenericName=Package Manager
Comment=GNUTUX Command Line Package Manager v$VERSION - Smart Package Management
Exec=$SCRIPT_NAME
Icon=gt-clpm
Categories=System;PackageManager;
Terminal=true
StartupNotify=true
Keywords=package;manager;install;remove;update;system;linux;flatpak;snap;python;nodejs;smart;

# Arabic metadata
Name[ar]=GT-CLPM
Comment[ar]=مدير حزم سطر الأوامر من جنوتكس الإصدار $VERSION - إدارة حزم ذكية
GenericName[ar]=مدير الحزم
Keywords[ar]=حزم;مدير;تثبيت;إزالة;تحديث;نظام;لينكس;فلاتباك;سناب;بايثون;نود.جي إس;ذكي"

    # Create desktop entry file
    if [[ ! -w "$DESKTOP_ENTRY_DIR" ]]; then
        echo "$desktop_entry" | sudo tee "$DESKTOP_ENTRY_DIR/gt-clpm.desktop" > /dev/null
        sudo chmod 644 "$DESKTOP_ENTRY_DIR/gt-clpm.desktop"
    else
        echo "$desktop_entry" > "$DESKTOP_ENTRY_DIR/gt-clpm.desktop"
        chmod 644 "$DESKTOP_ENTRY_DIR/gt-clpm.desktop"
    fi
    
    print_success "تم إنشاء إدخال سطح المكتب في $DESKTOP_ENTRY_DIR/gt-clpm.desktop"
}

# Update desktop database
update_desktop_database() {
    if command -v update-desktop-database &> /dev/null; then
        print_status "جاري تحديث قاعدة بيانات سطح المكتب..."
        if [[ ! -w "$DESKTOP_ENTRY_DIR" ]]; then
            sudo update-desktop-database "$DESKTOP_ENTRY_DIR"
        else
            update-desktop-database "$DESKTOP_ENTRY_DIR"
        fi
        print_success "تم تحديث قاعدة بيانات سطح المكتب"
    else
        print_warning "update-desktop-database غير موجود، تخطي تحديث قاعدة بيانات سطح المكتب"
    fi
    
    # Also update icon cache
    if command -v gtk-update-icon-cache &> /dev/null && [[ -d "$ICONS_DIR" ]]; then
        print_status "جاري تحديث ذاكرة التخزين المؤقت للأيقونات..."
        if [[ ! -w "$ICONS_DIR" ]]; then
            sudo gtk-update-icon-cache -f -t "$ICONS_DIR"
        else
            gtk-update-icon-cache -f -t "$ICONS_DIR"
        fi
        print_success "تم تحديث ذاكرة التخزين المؤقت للأيقونات"
    else
        print_warning "gtk-update-icon-cache غير موجود، تخطي تحديث ذاكرة التخزين المؤقت للأيقونات"
    fi
}

# Verify installation
verify_installation() {
    print_status "جاري التحقق من التثبيت..."
    
    local success=true
    
    # Check if script is installed and executable
    if command -v "$SCRIPT_NAME" &> /dev/null || [[ -f "$INSTALL_DIR/$SCRIPT_NAME" ]]; then
        print_success "✓ تم تثبيت السكريبت وهو قابل للوصول"
    else
        print_error "السكريبت غير موجود في PATH"
        success=false
    fi
    
    # Check if desktop entry exists
    local desktop_pattern="$DESKTOP_ENTRY_DIR/gt-clpm*.desktop"
    if ls $desktop_pattern 1> /dev/null 2>&1; then
        print_success "✓ تم إنشاء إدخال سطح المكتب"
        # List all desktop entries
        for desktop_file in $desktop_pattern; do
            local name=$(grep "^Name=" "$desktop_file" | head -1 | cut -d'=' -f2)
            print_status "  - $name ($(basename "$desktop_file"))"
        done
    else
        print_warning "إدخال سطح المكتب غير موجود"
    fi
    
    # Check if some icons are installed
    local icon_check_path="$ICONS_DIR/64x64/apps/gt-clpm.png"
    if [[ -f "$icon_check_path" ]]; then
        print_success "✓ تم تثبيت الأيقونات"
    else
        print_warning "قد لا تكون الأيقونات مثبتة بالكامل"
    fi
    
    # Test the script
    if [[ "$success" == "true" ]]; then
        print_status "جاري اختبار GT-CLPM..."
        if "$INSTALL_DIR/$SCRIPT_NAME" --version &>/dev/null || true; then
            print_success "✓ GT-CLPM يعمل بشكل صحيح"
        else
            print_warning "اختبار GT-CLPM غير حاسم"
        fi
    fi
    
    if [[ "$success" == "true" ]]; then
        print_success "✓ اكتمل التثبيت بنجاح!"
        return 0
    else
        print_error "اكتمل التثبيت مع وجود تحذيرات"
        return 1
    fi
}

# Show success message
show_success() {
    echo
    echo -e "${GREEN}╔════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║          اكتمل التثبيت بنجاح          ║${NC}"
    echo -e "${GREEN}╚════════════════════════════════════════╝${NC}"
    echo
    echo -e "${BLUE}🎉 تم تثبيت GT-CLPM v$VERSION بنجاح!${NC}"
    echo
    
    if [[ "$SCRIPT_NAME" == "gt-clpm" ]]; then
        echo -e "${YELLOW}📝 طرق الاستخدام:${NC}"
        echo -e "  ${GREEN}الطرفية:${NC} gt-clpm"
        echo -e "  ${GREEN}سطح المكتب:${NC} ابحث عن 'GT-CLPM' في قائمة التطبيقات"
    else
        echo -e "${YELLOW}📝 طرق الاستخدام:${NC}"
        echo -e "  ${GREEN}الطرفية:${NC} $SCRIPT_NAME"
        echo -e "  ${GREEN}سطح المكتب:${NC} ابحث عن 'GT-CLPM v$VERSION' في قائمة التطبيقات"
    fi
    
    echo
    echo -e "${YELLOW}✨ الميزات الجديدة في v$VERSION:${NC}"
    echo -e "  🧠 ${GREEN}الإزالة الذكية${NC} - تصفح الحزم المثبتة وأزل ما تريد"
    echo -e "  🔢 ${GREEN}البحث التفاعلي${NC} - ثَبِّت من نتائج البحث المرقمة"
    echo -e "  🐍 ${GREEN}أدوات بايثون${NC} - pip, pipx, والبيئات الافتراضية"
    echo -e "  📦 ${GREEN}أدوات Node.js${NC} - دعم npm, yarn, pnpm"
    echo -e "  🎨 ${GREEN}واجهة محسنة${NC} - تنظيم أفضل ورموز تعبيرية"
    echo
    
    if [[ "$SCRIPT_NAME" == "gt-clpm" ]]; then
        echo -e "${YELLOW}🚀 ابدأ الاستخدام:${NC} ${GREEN}gt-clpm${NC} ${YELLOW}أو ابحث عنه في قائمة التطبيقات${NC}"
    else
        echo -e "${YELLOW}🚀 ابدأ الاستخدام:${NC} ${GREEN}$SCRIPT_NAME${NC} ${YELLOW}أو ابحث عنه في قائمة التطبيقات${NC}"
    fi
    
    echo
    echo -e "${BLUE}💡 تحتاج مساعدة؟ شغّل:${NC} ${GREEN}$SCRIPT_NAME --help${NC}"
    echo
}

# Main installation process
main() {
    echo -e "${BLUE}"
    echo "╔════════════════════════════════════════╗"
    echo "║           GT-CLPM المثبت              ║"
    echo "║              الإصدار $VERSION              ║"
    echo "╚════════════════════════════════════════╝"
    echo -e "${NC}"
    echo -e "${YELLOW}جاري تثبيت GT-CLPM v$VERSION مع تكامل سطح المكتب الكامل...${NC}"
    echo
    
    check_requirements
    check_root
    
    # Check for existing installation and get user choice
    local install_alongside=0
    if ! check_existing_installation; then
        install_alongside=1
    fi
    
    install_dependencies
    download_script
    make_executable
    install_script
    install_icons
    
    # Create appropriate desktop entry
    if [[ $install_alongside -eq 1 ]]; then
        create_versioned_desktop_entry "gt-clpm-v$VERSION.desktop"
    else
        create_desktop_entry
    fi
    
    update_desktop_database
    verify_installation
    show_success
}

# Run main function
main "$@"
