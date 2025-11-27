#!/bin/bash

# GT-CLPM Installer
# Version: 1.0
# Developer: GNUTUX

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Configuration
REPO_URL="https://github.com/SalehGNUTUX/GT-CLPM"
SCRIPT_URL="https://raw.githubusercontent.com/SalehGNUTUX/GT-CLPM/main/GT-CLPM/gt-clpm.sh"
ICONS_URL="https://github.com/SalehGNUTUX/GT-CLPM/raw/main/GT-CLPM/gt-usdr%20APPIAMGE%20BIULD/GT-CLPM-CLI.AppDir/usr/share/icons/hicolor"
INSTALL_DIR="/usr/local/bin"
SCRIPT_NAME="gt-clpm"
DESKTOP_ENTRY_DIR="/usr/share/applications"
ICONS_DIR="/usr/share/icons/hicolor"
DESKTOP_ENTRY_URL="https://raw.githubusercontent.com/SalehGNUTUX/GT-CLPM/main/GT-CLPM/gt-usdr%20APPIAMGE%20BIULD/GT-CLPM-CLI.AppDir/usr/share/applications/gt-clpm-cli.desktop"

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

# Check if running as root
check_root() {
    if [[ $EUID -eq 0 ]]; then
        print_warning "Running as root user"
    fi
}

# Download the script
download_script() {
    print_status "Downloading GT-CLPM script..."
    
    if command -v curl &> /dev/null; then
        curl -fsSL "$SCRIPT_URL" -o "/tmp/$SCRIPT_NAME"
    elif command -v wget &> /dev/null; then
        wget -q "$SCRIPT_URL" -O "/tmp/$SCRIPT_NAME"
    else
        print_error "Neither curl nor wget found. Please install one of them."
        exit 1
    fi
    
    if [[ ! -f "/tmp/$SCRIPT_NAME" ]]; then
        print_error "Failed to download the script"
        exit 1
    fi
}

# Make script executable
make_executable() {
    print_status "Making script executable..."
    chmod +x "/tmp/$SCRIPT_NAME"
}

# Install the script
install_script() {
    print_status "Installing to $INSTALL_DIR..."
    
    # Check if install directory exists and is writable
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
        print_status "Script installed successfully!"
    else
        print_error "Script installation failed"
        exit 1
    fi
}

# Download and install icons
install_icons() {
    print_status "Installing icons..."
    
    # Create temporary directory for icons
    local temp_icons_dir="/tmp/gt-clpm-icons"
    mkdir -p "$temp_icons_dir"
    
    # Icon sizes to download
    local icon_sizes=("16x16" "32x32" "48x48" "64x64" "128x128" "256x256" "512x512")
    
    for size in "${icon_sizes[@]}"; do
        local icon_url="${ICONS_URL}/${size}/apps/gt-clpm-cli.png"
        local icon_dir="$ICONS_DIR/${size}/apps"
        
        # Download icon
        if command -v curl &> /dev/null; then
            curl -fsSL "$icon_url" -o "$temp_icons_dir/gt-clpm-${size}.png" 2>/dev/null || true
        elif command -v wget &> /dev/null; then
            wget -q "$icon_url" -O "$temp_icons_dir/gt-clpm-${size}.png" 2>/dev/null || true
        fi
        
        # Install icon if downloaded successfully
        if [[ -f "$temp_icons_dir/gt-clpm-${size}.png" ]]; then
            # Create icon directory
            if [[ ! -w "$ICONS_DIR" ]]; then
                sudo mkdir -p "$icon_dir"
                sudo cp "$temp_icons_dir/gt-clpm-${size}.png" "$icon_dir/gt-clpm.png"
            else
                mkdir -p "$icon_dir"
                cp "$temp_icons_dir/gt-clpm-${size}.png" "$icon_dir/gt-clpm.png"
            fi
            print_status "Installed ${size} icon"
        else
            print_warning "Icon for size ${size} not available"
        fi
    done
    
    # Cleanup
    rm -rf "$temp_icons_dir"
}

# Create desktop entry
create_desktop_entry() {
    print_status "Creating desktop entry..."
    
    local desktop_entry="[Desktop Entry]
Version=1.0
Type=Application
Name=GT-CLPM
GenericName=Package Manager
Comment=GNUTUX Command Line Package Manager
Exec=gnome-terminal -- bash -c 'gt-clpm; exec bash'
Icon=gt-clpm
Categories=System;PackageManager;
Terminal=true
StartupNotify=true
Keywords=package;manager;install;remove;update;system;

# Arabic metadata
Name[ar]=جي تي-سي إل بي إم
Comment[ar]=مدير حزم سطر الأوامر من جنوتكس
GenericName[ar]=مدير الحزم"

    # Create desktop entry file
    if [[ ! -w "$DESKTOP_ENTRY_DIR" ]]; then
        echo "$desktop_entry" | sudo tee "$DESKTOP_ENTRY_DIR/gt-clpm.desktop" > /dev/null
        sudo chmod +x "$DESKTOP_ENTRY_DIR/gt-clpm.desktop"
    else
        echo "$desktop_entry" > "$DESKTOP_ENTRY_DIR/gt-clpm.desktop"
        chmod +x "$DESKTOP_ENTRY_DIR/gt-clpm.desktop"
    fi
    
    print_status "Desktop entry created successfully!"
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
    fi
    
    # Also update icon cache
    if command -v gtk-update-icon-cache &> /dev/null && [[ -d "$ICONS_DIR" ]]; then
        print_status "Updating icon cache..."
        if [[ ! -w "$ICONS_DIR" ]]; then
            sudo gtk-update-icon-cache -f -t "$ICONS_DIR"
        else
            gtk-update-icon-cache -f -t "$ICONS_DIR"
        fi
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
    fi
    
    # Check if desktop entry exists
    if [[ ! -f "$DESKTOP_ENTRY_DIR/gt-clpm.desktop" ]]; then
        print_warning "Desktop entry not found"
    fi
    
    if [[ "$success" == "true" ]]; then
        print_status "Installation completed successfully!"
    else
        print_error "Installation completed with warnings"
    fi
}

# Show success message
show_success() {
    echo
    echo -e "${GREEN}╔════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║          INSTALLATION COMPLETE         ║${NC}"
    echo -e "${GREEN}╚════════════════════════════════════════╝${NC}"
    echo
    echo -e "${BLUE}🎉 GT-CLPM has been successfully installed!${NC}"
    echo
    echo -e "${YELLOW}📝 Usage:${NC}"
    echo -e "  ${GREEN}Terminal:${NC} gt-clpm"
    echo -e "  ${GREEN}Desktop:${NC} Search for 'GT-CLPM' in your application menu"
    echo
    echo -e "${YELLOW}✨ Features:${NC}"
    echo -e "  📦 Support for 12+ package managers"
    echo -e "  📱 Flatpak and Snap integration"
    echo -e "  ⚙️  System tools and utilities"
    echo -e "  🌐 Multi-language support (Arabic/English)"
    echo
    echo -e "${BLUE}🚀 Start using:${NC} ${GREEN}gt-clpm${NC}"
    echo
}

# Main installation process
main() {
    echo -e "${BLUE}"
    echo "╔════════════════════════════════════════╗"
    echo "║           GT-CLPM Installer           ║"
    echo "║              Version 1.0              ║"
    echo "╚════════════════════════════════════════╝"
    echo -e "${NC}"
    
    check_root
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
