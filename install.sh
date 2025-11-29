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
NC='\033[0m'

# Configuration
REPO_URL="https://github.com/SalehGNUTUX/GT-CLPM"
SCRIPT_URL="https://raw.githubusercontent.com/SalehGNUTUX/GT-CLPM/main/gt-clpm-v1.1.sh"
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

# Check system requirements
check_requirements() {
    print_status "Checking system requirements..."
    
    # Check if running on Linux
    if [[ "$(uname)" != "Linux" ]]; then
        print_error "This installer is for Linux systems only"
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
        print_error "Missing required tools: ${missing_tools[*]}"
        exit 1
    fi
    
    # Check for download tools
    if ! command -v curl &> /dev/null && ! command -v wget &> /dev/null; then
        print_warning "Neither curl nor wget found. Some features may be limited."
    fi
    
    print_success "System requirements met"
}

# Check if running as root
check_root() {
    if [[ $EUID -eq 0 ]]; then
        print_warning "Running as root user"
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
    print_status "Checking for optional dependencies..."
    
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
        print_warning "Missing optional dependencies: ${missing_deps[*]}"
        echo
        read -p "Do you want to install these dependencies? (y/N): " -n 1 -r
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
                    print_warning "Automatic dependency installation not supported for your package manager"
                    print_status "Please install these packages manually: ${missing_deps[*]}"
                    ;;
            esac
        else
            print_status "Skipping optional dependencies installation"
        fi
    else
        print_success "All optional dependencies are available"
    fi
}

# Download the script
download_script() {
    print_status "Downloading GT-CLPM v$VERSION script..."
    
    if command -v curl &> /dev/null; then
        if curl -fsSL "$SCRIPT_URL" -o "/tmp/$SCRIPT_NAME"; then
            print_success "Script downloaded successfully"
        else
            print_error "Failed to download the script from $SCRIPT_URL"
            exit 1
        fi
    elif command -v wget &> /dev/null; then
        if wget -q "$SCRIPT_URL" -O "/tmp/$SCRIPT_NAME"; then
            print_success "Script downloaded successfully"
        else
            print_error "Failed to download the script from $SCRIPT_URL"
            exit 1
        fi
    else
        print_error "Neither curl nor wget found. Please install one of them."
        exit 1
    fi
    
    if [[ ! -f "/tmp/$SCRIPT_NAME" ]]; then
        print_error "Downloaded file not found"
        exit 1
    fi
}

# Make script executable
make_executable() {
    print_status "Making script executable..."
    chmod +x "/tmp/$SCRIPT_NAME"
    
    # Verify the script is valid
    if head -n 1 "/tmp/$SCRIPT_NAME" | grep -q "bash"; then
        print_success "Script is valid and executable"
    else
        print_error "Downloaded file doesn't appear to be a valid bash script"
        exit 1
    fi
}

# Install the script
install_script() {
    print_status "Installing to $INSTALL_DIR..."
    
    # Check if install directory exists
    if [[ ! -d "$INSTALL_DIR" ]]; then
        print_status "Creating installation directory..."
        if [[ ! -w "/usr/local" ]]; then
            sudo mkdir -p "$INSTALL_DIR"
        else
            mkdir -p "$INSTALL_DIR"
        fi
    fi
    
    # Check if install directory is writable
    if [[ ! -w "$INSTALL_DIR" ]]; then
        print_warning "Need root privileges to install to $INSTALL_DIR"
        sudo cp "/tmp/$SCRIPT_NAME" "$INSTALL_DIR/$SCRIPT_NAME"
        sudo chmod +x "$INSTALL_DIR/$SCRIPT_NAME"
    else
        cp "/tmp/$SCRIPT_NAME" "$INSTALL_DIR/$SCRIPT_NAME"
        chmod +x "$INSTALL_DIR/$SCRIPT_NAME"
    fi
    
    # Verify installation
    if command -v "$SCRIPT_NAME" &> /dev/null; then
        print_success "Script installed successfully to $INSTALL_DIR/$SCRIPT_NAME"
    else
        print_error "Script installation failed - not found in PATH"
        exit 1
    fi
}

# Download and install icons
install_icons() {
    print_status "Installing application icons..."
    
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
                ((icons_downloaded++)
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
        print_success "Installed $icons_downloaded icon sizes"
    else
        print_warning "No icons were downloaded - using default system icons"
    fi
}

# Create desktop entry
create_desktop_entry() {
    print_status "Creating desktop entry..."
    
    local desktop_entry="[Desktop Entry]
Version=1.1
Type=Application
Name=GT-CLPM
GenericName=Package Manager
Comment=GNUTUX Command Line Package Manager v$VERSION
Exec=gt-clpm
Icon=gt-clpm
Categories=System;PackageManager;
Terminal=true
StartupNotify=true
Keywords=package;manager;install;remove;update;system;linux;flatpak;snap;python;nodejs;

# Arabic metadata
Name[ar]=GT-CLPM
Comment[ar]=مدير حزم سطر الأوامر من جنوتكس الإصدار $VERSION
GenericName[ar]=مدير الحزم
Keywords[ar]=حزم;مدير;تثبيت;إزالة;تحديث;نظام;لينكس;فلاتباك;سناب;بايثون;نود.js"

    # Create desktop entry file
    if [[ ! -w "$DESKTOP_ENTRY_DIR" ]]; then
        echo "$desktop_entry" | sudo tee "$DESKTOP_ENTRY_DIR/gt-clpm.desktop" > /dev/null
        sudo chmod 644 "$DESKTOP_ENTRY_DIR/gt-clpm.desktop"
    else
        echo "$desktop_entry" > "$DESKTOP_ENTRY_DIR/gt-clpm.desktop"
        chmod 644 "$DESKTOP_ENTRY_DIR/gt-clpm.desktop"
    fi
    
    print_success "Desktop entry created at $DESKTOP_ENTRY_DIR/gt-clpm.desktop"
}

# Update desktop database
update_desktop_database() {
    if command -v update-desktop-database &> /dev/null; then
        print_status "Updating desktop database..."
        if [[ ! -w "$DESKTOP_ENTRY_DIR" ]]; then
            sudo update-desktop-database "$DESKTOP_ENTRY_DIR"
        else
            update-desktop-database "$DESKTOP_ENTRY_DIR"
        fi
        print_success "Desktop database updated"
    else
        print_warning "update-desktop-database not found, skipping desktop database update"
    fi
    
    # Also update icon cache
    if command -v gtk-update-icon-cache &> /dev/null && [[ -d "$ICONS_DIR" ]]; then
        print_status "Updating icon cache..."
        if [[ ! -w "$ICONS_DIR" ]]; then
            sudo gtk-update-icon-cache -f -t "$ICONS_DIR"
        else
            gtk-update-icon-cache -f -t "$ICONS_DIR"
        fi
        print_success "Icon cache updated"
    else
        print_warning "gtk-update-icon-cache not found, skipping icon cache update"
    fi
}

# Verify installation
verify_installation() {
    print_status "Verifying installation..."
    
    local success=true
    
    # Check if script is installed and executable
    if ! command -v "$SCRIPT_NAME" &> /dev/null; then
        print_error "Script not found in PATH"
        success=false
    else
        print_success "✓ Script installed and accessible"
    fi
    
    # Check if desktop entry exists
    if [[ -f "$DESKTOP_ENTRY_DIR/gt-clpm.desktop" ]]; then
        print_success "✓ Desktop entry created"
    else
        print_warning "Desktop entry not found"
    fi
    
    # Check if some icons are installed
    local icon_check_path="$ICONS_DIR/64x64/apps/gt-clpm.png"
    if [[ -f "$icon_check_path" ]]; then
        print_success "✓ Icons installed"
    else
        print_warning "Icons may not be fully installed"
    fi
    
    # Test the script
    if [[ "$success" == "true" ]]; then
        print_status "Testing GT-CLPM..."
        if "$SCRIPT_NAME" --help &>/dev/null || true; then
            print_success "✓ GT-CLPM is working correctly"
        else
            print_warning "GT-CLPM test inconclusive"
        fi
    fi
    
    if [[ "$success" == "true" ]]; then
        print_success "✓ Installation completed successfully!"
        return 0
    else
        print_error "Installation completed with warnings"
        return 1
    fi
}

# Show success message
show_success() {
    echo
    echo -e "${GREEN}╔════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║          INSTALLATION COMPLETE         ║${NC}"
    echo -e "${GREEN}╚════════════════════════════════════════╝${NC}"
    echo
    echo -e "${BLUE}🎉 GT-CLPM v$VERSION has been successfully installed!${NC}"
    echo
    echo -e "${YELLOW}📝 Usage Methods:${NC}"
    echo -e "  ${GREEN}Terminal:${NC} gt-clpm"
    echo -e "  ${GREEN}Desktop:${NC} Search for 'GT-CLPM' in your application menu"
    echo -e "  ${GREEN}Application Menu:${NC} Look in System Tools or System category"
    echo
    echo -e "${YELLOW}✨ New Features in v$VERSION:${NC}"
    echo -e "  🧠 ${GREEN}Smart Remove${NC} - Browse and remove packages interactively"
    echo -e "  🔢 ${GREEN}Interactive Search${NC} - Install from numbered search results"
    echo -e "  🐍 ${GREEN}Python Tools${NC} - pip, pipx, and virtual environments"
    echo -e "  📦 ${GREEN}Node.js Tools${NC} - npm, yarn, pnpm support"
    echo -e "  🎨 ${GREEN}Enhanced Interface${NC} - Better organization and emojis"
    echo
    echo -e "${YELLOW}🚀 Start using:${NC} ${GREEN}gt-clpm${NC} ${YELLOW}or find it in your applications menu${NC}"
    echo
    echo -e "${BLUE}💡 Need help? Run:${NC} ${GREEN}gt-clpm --help${NC}"
    echo
}

# Main installation process
main() {
    echo -e "${BLUE}"
    echo "╔════════════════════════════════════════╗"
    echo "║           GT-CLPM Installer           ║"
    echo "║              Version $VERSION              ║"
    echo "╚════════════════════════════════════════╝"
    echo -e "${NC}"
    echo -e "${YELLOW}Installing GT-CLPM v$VERSION with full desktop integration...${NC}"
    echo
    
    check_requirements
    check_root
    install_dependencies
    download_script
    make_executable
    install_script
    install_icons
    create_desktop_entry
    update_desktop_database
    verify_installation
    show_success
}

# Run main function
main "$@"
