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
INSTALL_DIR="/usr/local/bin"
SCRIPT_NAME="gt-clpm"
DESKTOP_ENTRY_DIR="/usr/share/applications"

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
        print_status "Installation completed successfully!"
    else
        print_error "Installation failed - script not found in PATH"
        exit 1
    fi
}

# Create desktop entry (optional)
create_desktop_entry() {
    if [[ -d "$DESKTOP_ENTRY_DIR" ]]; then
        print_status "Creating desktop entry..."
        
        local desktop_entry="[Desktop Entry]
Version=1.0
Type=Application
Name=GT-CLPM
Comment=GNUTUX Command Line Package Manager
Exec=gnome-terminal -- bash -c 'gt-clpm; exec bash'
Icon=utilities-terminal
Terminal=false
Categories=System;PackageManager;
StartupNotify=true"

        if [[ ! -w "$DESKTOP_ENTRY_DIR" ]]; then
            echo "$desktop_entry" | sudo tee "$DESKTOP_ENTRY_DIR/gt-clpm.desktop" > /dev/null
            sudo chmod +x "$DESKTOP_ENTRY_DIR/gt-clpm.desktop"
        else
            echo "$desktop_entry" > "$DESKTOP_ENTRY_DIR/gt-clpm.desktop"
            chmod +x "$DESKTOP_ENTRY_DIR/gt-clpm.desktop"
        fi
    fi
}

# Update desktop database
update_desktop_database() {
    if command -v update-desktop-database &> /dev/null; then
        print_status "Updating desktop database..."
        if [[ ! -w "$DESKTOP_ENTRY_DIR" ]]; then
            sudo update-desktop-database
        else
            update-desktop-database
        fi
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
    echo -e "${YELLOW}Usage:${NC}"
    echo -e "  ${GREEN}gt-clpm${NC} - Launch the package manager"
    echo
    echo -e "${YELLOW}Features:${NC}"
    echo -e "  📦 Support for multiple package managers"
    echo -e "  📱 Flatpak and Snap integration"
    echo -e "  ⚙️  System tools and utilities"
    echo -e "  🌐 Multi-language support"
    echo
    echo -e "${BLUE}Start using:${NC} ${GREEN}gt-clpm${NC}"
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
    create_desktop_entry
    update_desktop_database
    show_success
}

# Run main function
main "$@"
