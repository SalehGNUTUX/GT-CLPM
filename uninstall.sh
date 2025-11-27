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
ICONS_DIR="/usr/share/icons/hicolor"
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
        print_status "Desktop entry removed"
    else
        print_warning "Desktop entry not found"
    fi
}

# Remove icons
remove_icons() {
    print_status "Removing icons..."
    
    local icon_sizes=("16x16" "32x32" "48x48" "64x64" "128x128" "256x256" "512x512")
    local icon_name="gt-clpm.png"
    local icons_removed=0
    
    for size in "${icon_sizes[@]}"; do
        local icon_path="$ICONS_DIR/${size}/apps/$icon_name"
        if [[ -f "$icon_path" ]]; then
            if [[ ! -w "$ICONS_DIR" ]]; then
                sudo rm -f "$icon_path"
            else
                rm -f "$icon_path"
            fi
            ((icons_removed++))
            print_status "Removed ${size} icon"
            
            # Remove empty directories
            local apps_dir="$ICONS_DIR/${size}/apps"
            local size_dir="$ICONS_DIR/${size}"
            
            if [[ -d "$apps_dir" ]] && [[ -z "$(ls -A "$apps_dir" 2>/dev/null)" ]]; then
                if [[ ! -w "$ICONS_DIR" ]]; then
                    sudo rmdir "$apps_dir" 2>/dev/null || true
                else
                    rmdir "$apps_dir" 2>/dev/null || true
                fi
            fi
            
            if [[ -d "$size_dir" ]] && [[ -z "$(ls -A "$size_dir" 2>/dev/null)" ]]; then
                if [[ ! -w "$ICONS_DIR" ]]; then
                    sudo rmdir "$size_dir" 2>/dev/null || true
                else
                    rmdir "$size_dir" 2>/dev/null || true
                fi
            fi
        fi
    done
    
    if [[ $icons_removed -gt 0 ]]; then
        print_status "Removed $icons_removed icon files"
    else
        print_warning "No icons found to remove"
    fi
}

# Remove configuration files
remove_config_files() {
    print_status "Removing configuration files..."
    
    # Remove language file
    if [[ -f "$LANG_FILE" ]]; then
        rm -f "$LANG_FILE"
        print_status "Language file removed"
    else
        print_warning "Language file not found"
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
    else
        print_status "No backup files found"
    fi
}

# Update desktop database and icon cache
update_system_databases() {
    # Update desktop database
    if command -v update-desktop-database &> /dev/null && [[ -d "$DESKTOP_ENTRY_DIR" ]]; then
        print_status "Updating desktop database..."
        if [[ ! -w "$DESKTOP_ENTRY_DIR" ]]; then
            sudo update-desktop-database "$DESKTOP_ENTRY_DIR"
        else
            update-desktop-database "$DESKTOP_ENTRY_DIR"
        fi
    else
        print_warning "update-desktop-database not found, skipping"
    fi
    
    # Update icon cache
    if command -v gtk-update-icon-cache &> /dev/null && [[ -d "$ICONS_DIR" ]]; then
        print_status "Updating icon cache..."
        if [[ ! -w "$ICONS_DIR" ]]; then
            sudo gtk-update-icon-cache -f -t "$ICONS_DIR"
        else
            gtk-update-icon-cache -f -t "$ICONS_DIR"
        fi
    else
        print_warning "gtk-update-icon-cache not found, skipping"
    fi
}

# Verify uninstallation
verify_uninstallation() {
    print_status "Verifying uninstallation..."
    
    local success=true
    
    if command -v "$SCRIPT_NAME" &> /dev/null; then
        print_error "Script still found in PATH"
        success=false
    else
        print_status "✓ Script removed from PATH"
    fi
    
    if [[ -f "$DESKTOP_ENTRY_DIR/gt-clpm.desktop" ]]; then
        print_error "Desktop entry still exists"
        success=false
    else
        print_status "✓ Desktop entry removed"
    fi
    
    # Check if main icon is removed
    local icon_check_path="$ICONS_DIR/64x64/apps/gt-clpm.png"
    if [[ -f "$icon_check_path" ]]; then
        print_error "Some icons still exist"
        success=false
    else
        print_status "✓ Icons removed"
    fi
    
    if [[ "$success" == "true" ]]; then
        print_status "✓ GT-CLPM successfully uninstalled!"
        return 0
    else
        print_error "Uninstallation may not be complete"
        return 1
    fi
}

# Show completion message
show_completion() {
    echo
    echo -e "${GREEN}╔════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║         UNINSTALLATION COMPLETE        ║${NC}"
    echo -e "${GREEN}╚════════════════════════════════════════╝${NC}"
    echo
    echo -e "${BLUE}🗑️  GT-CLPM has been completely removed from your system!${NC}"
    echo
    echo -e "${YELLOW}📝 What was removed:${NC}"
    echo -e "  • Program executable from $INSTALL_DIR"
    echo -e "  • Desktop application entry"
    echo -e "  • Application icons (7 sizes)"
    echo -e "  • User configuration files"
    echo
    echo -e "${GREEN}💡 You can reinstall anytime using:${NC}"
    echo -e "  curl -fsSL https://raw.githubusercontent.com/SalehGNUTUX/GT-CLPM/main/install.sh | bash"
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
    echo -e "${YELLOW}This will completely remove GT-CLPM from your system.${NC}"
    echo -e "${YELLOW}This includes:${NC}"
    echo -e "  • Program executable from $INSTALL_DIR"
    echo -e "  • Desktop menu entry"
    echo -e "  • Application icons (all sizes)"
    echo -e "  • Configuration files"
    echo
    read -p "Are you sure you want to continue? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_status "Uninstallation cancelled"
        exit 0
    fi
    
    remove_script
    remove_desktop_entry
    remove_icons
    remove_config_files
    update_system_databases
    verify_uninstallation
    show_completion
}

# Run main function
main "$@"
