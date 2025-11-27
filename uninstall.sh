#!/bin/bash

# GT-CLPM Uninstaller
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
INSTALL_DIR="/usr/local/bin"
SCRIPT_NAME="gt-clpm"
DESKTOP_ENTRY_DIR="/usr/share/applications"
LANG_FILE="$HOME/.gt-clpm-lang"
BACKUP_FILES="$HOME/gt-clpm-backup-*.txt"

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

# Remove installed script
remove_script() {
    print_status "Removing GT-CLPM script..."
    
    if [[ -f "$INSTALL_DIR/$SCRIPT_NAME" ]]; then
        if [[ ! -w "$INSTALL_DIR" ]]; then
            sudo rm -f "$INSTALL_DIR/$SCRIPT_NAME"
        else
            rm -f "$INSTALL_DIR/$SCRIPT_NAME"
        fi
        print_status "Script removed from $INSTALL_DIR"
    else
        print_warning "Script not found in $INSTALL_DIR"
    fi
}

# Remove desktop entry
remove_desktop_entry() {
    if [[ -f "$DESKTOP_ENTRY_DIR/gt-clpm.desktop" ]]; then
        print_status "Removing desktop entry..."
        
        if [[ ! -w "$DESKTOP_ENTRY_DIR" ]]; then
            sudo rm -f "$DESKTOP_ENTRY_DIR/gt-clpm.desktop"
        else
            rm -f "$DESKTOP_ENTRY_DIR/gt-clpm.desktop"
        fi
    fi
}

# Remove configuration files
remove_config_files() {
    print_status "Removing configuration files..."
    
    # Remove language file
    if [[ -f "$LANG_FILE" ]]; then
        rm -f "$LANG_FILE"
        print_status "Language file removed"
    fi
    
    # Ask about backup files
    if ls $BACKUP_FILES 1> /dev/null 2>&1; then
        echo
        read -p "Do you want to remove GT-CLPM backup files? (y/N): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            rm -f $BACKUP_FILES
            print_status "Backup files removed"
        else
            print_status "Backup files kept in $HOME"
        fi
    fi
}

# Update desktop database
update_desktop_database() {
    if command -v update-desktop-database &> /dev/null && [[ -d "$DESKTOP_ENTRY_DIR" ]]; then
        print_status "Updating desktop database..."
        if [[ ! -w "$DESKTOP_ENTRY_DIR" ]]; then
            sudo update-desktop-database
        else
            update-desktop-database
        fi
    fi
}

# Verify uninstallation
verify_uninstallation() {
    if ! command -v "$SCRIPT_NAME" &> /dev/null; then
        print_status "GT-CLPM successfully uninstalled!"
    else
        print_error "Uninstallation may not be complete"
        exit 1
    fi
}

# Show completion message
show_completion() {
    echo
    echo -e "${GREEN}╔════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║         UNINSTALLATION COMPLETE        ║${NC}"
    echo -e "${GREEN}╚════════════════════════════════════════╝${NC}"
    echo
    echo -e "${BLUE}🗑️  GT-CLPM has been successfully removed!${NC}"
    echo
    echo -e "${YELLOW}Note:${NC}"
    echo -e "  • The program has been removed from your system"
    echo -e "  • Configuration files have been cleaned up"
    echo -e "  • You can reinstall anytime using the install script"
    echo
}

# Main uninstallation process
main() {
    echo -e "${BLUE}"
    echo "╔════════════════════════════════════════╗"
    echo "║           GT-CLPM Uninstaller         ║"
    echo "║              Version 1.0              ║"
    echo "╚════════════════════════════════════════╝"
    echo -e "${NC}"
    
    # Confirm uninstallation
    echo -e "${YELLOW}This will remove GT-CLPM from your system.${NC}"
    read -p "Are you sure you want to continue? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_status "Uninstallation cancelled"
        exit 0
    fi
    
    remove_script
    remove_desktop_entry
    remove_config_files
    update_desktop_database
    verify_uninstallation
    show_completion
}

# Run main function
main "$@"
