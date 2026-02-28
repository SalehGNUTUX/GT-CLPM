#!/bin/bash

# GT-CLPM Uninstaller
# Version: 1.2.2
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
INSTALL_DIR="/usr/local/bin"
SCRIPT_NAME="gt-clpm"
DESKTOP_ENTRY_DIR="/usr/share/applications"
ICONS_DIR="/usr/share/icons/hicolor"
LANG_FILE="$HOME/.gt-clpm-lang"
BACKUP_FILES="$HOME/gt-clpm-backup-*.txt"
VERSION="1.2.2"

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

# Remove installed script
remove_script() {
    print_status "Removing GT-CLPM script..."
    
    local script_paths=(
        "$INSTALL_DIR/$SCRIPT_NAME"
        "/usr/bin/$SCRIPT_NAME"
        "/bin/$SCRIPT_NAME"
    )
    
    local removed=false
    
    for script_path in "${script_paths[@]}"; do
        if [[ -f "$script_path" ]]; then
            if [[ ! -w "$(dirname "$script_path")" ]]; then
                sudo rm -f "$script_path"
            else
                rm -f "$script_path"
            fi
            print_success "Removed script: $script_path"
            removed=true
        fi
    done
    
    if [[ "$removed" == "false" ]]; then
        print_warning "GT-CLPM script not found in standard locations"
    fi
}

# Remove desktop entry
remove_desktop_entry() {
    local desktop_files=(
        "$DESKTOP_ENTRY_DIR/gt-clpm.desktop"
        "/usr/local/share/applications/gt-clpm.desktop"
        "$HOME/.local/share/applications/gt-clpm.desktop"
    )
    
    local removed=false
    
    for desktop_file in "${desktop_files[@]}"; do
        if [[ -f "$desktop_file" ]]; then
            if [[ ! -w "$(dirname "$desktop_file")" ]]; then
                sudo rm -f "$desktop_file"
            else
                rm -f "$desktop_file"
            fi
            print_success "Removed desktop entry: $desktop_file"
            removed=true
        fi
    done
    
    if [[ "$removed" == "false" ]]; then
        print_warning "No desktop entries found"
    fi
}

# Remove icons
remove_icons() {
    print_status "Removing application icons..."
    
    local icon_sizes=("16x16" "32x32" "48x48" "64x64" "128x128" "256x256" "512x512")
    local icon_names=("gt-clpm.png" "gt-clpm-cli-icon.png")
    local icons_removed=0
    
    for size in "${icon_sizes[@]}"; do
        for icon_name in "${icon_names[@]}"; do
            local icon_path="$ICONS_DIR/${size}/apps/$icon_name"
            if [[ -f "$icon_path" ]]; then
                if [[ ! -w "$ICONS_DIR" ]]; then
                    sudo rm -f "$icon_path"
                else
                    rm -f "$icon_path"
                fi
                ((icons_removed++))
                print_success "Removed ${size} icon: $icon_name"
                
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
    done
    
    if [[ $icons_removed -gt 0 ]]; then
        print_success "Removed $icons_removed icon files"
    else
        print_warning "No icons found to remove"
    fi
}

# Remove configuration files
remove_config_files() {
    print_status "Removing configuration and data files..."
    
    # Remove language file
    if [[ -f "$LANG_FILE" ]]; then
        rm -f "$LANG_FILE"
        print_success "Language file removed: $LANG_FILE"
    else
        print_warning "Language file not found"
    fi
    
    # Remove any cache files
    local cache_dir="$HOME/.cache/gt-clpm"
    if [[ -d "$cache_dir" ]]; then
        rm -rf "$cache_dir"
        print_success "Cache directory removed: $cache_dir"
    fi
    
    # Ask about backup files
    if ls $BACKUP_FILES 1> /dev/null 2>&1; then
        echo
        read -p "Do you want to remove GT-CLPM backup files? (y/N): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            rm -f $BACKUP_FILES
            print_success "Backup files removed"
        else
            print_status "Backup files kept in $HOME"
        fi
    else
        print_status "No backup files found"
    fi
    
    # Remove any temporary files
    local temp_files=(
        "/tmp/gt-clpm"
        "/tmp/$SCRIPT_NAME"
    )
    
    for temp_file in "${temp_files[@]}"; do
        if [[ -f "$temp_file" ]] || [[ -d "$temp_file" ]]; then
            rm -rf "$temp_file"
        fi
    done
}

# Update desktop database and icon cache
update_system_databases() {
    # Update desktop database
    if command -v update-desktop-database &> /dev/null; then
        print_status "Updating desktop database..."
        local desktop_dirs=("$DESKTOP_ENTRY_DIR" "/usr/local/share/applications")
        
        for dir in "${desktop_dirs[@]}"; do
            if [[ -d "$dir" ]]; then
                if [[ ! -w "$dir" ]]; then
                    sudo update-desktop-database "$dir"
                else
                    update-desktop-database "$dir"
                fi
            fi
        done
        print_success "Desktop database updated"
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
        print_success "Icon cache updated"
    else
        print_warning "gtk-update-icon-cache not found, skipping"
    fi
}

# Verify uninstallation
verify_uninstallation() {
    print_status "Verifying uninstallation..."
    
    local success=true
    
    # Check if script is removed from PATH
    if command -v "$SCRIPT_NAME" &> /dev/null; then
        print_error "Script still found in PATH"
        success=false
    else
        print_success "✓ Script removed from PATH"
    fi
    
    # Check if desktop entries are removed
    local desktop_check_paths=(
        "$DESKTOP_ENTRY_DIR/gt-clpm.desktop"
        "/usr/local/share/applications/gt-clpm.desktop"
    )
    
    local desktop_removed=true
    for path in "${desktop_check_paths[@]}"; do
        if [[ -f "$path" ]]; then
            desktop_removed=false
            break
        fi
    done
    
    if [[ "$desktop_removed" == "true" ]]; then
        print_success "✓ Desktop entries removed"
    else
        print_error "Some desktop entries still exist"
        success=false
    fi
    
    # Check if main icon is removed
    local icon_check_path="$ICONS_DIR/64x64/apps/gt-clpm.png"
    if [[ -f "$icon_check_path" ]]; then
        print_error "Some icons still exist"
        success=false
    else
        print_success "✓ Icons removed"
    fi
    
    if [[ "$success" == "true" ]]; then
        print_success "✓ GT-CLPM v$VERSION successfully uninstalled!"
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
    echo -e "${BLUE}🗑️  GT-CLPM v$VERSION has been completely removed from your system!${NC}"
    echo
    echo -e "${YELLOW}📝 What was removed:${NC}"
    echo -e "  📦 ${GREEN}Program executable${NC} from system PATH"
    echo -e "  🖥️  ${GREEN}Desktop application entries${NC} from menu"
    echo -e "  🖼️  ${GREEN}Application icons${NC} (all sizes)"
    echo -e "  ⚙️  ${GREEN}User configuration${NC} and cache files"
    echo -e "  💾 ${GREEN}Backup files${NC} (if selected)"
    echo
    echo -e "${GREEN}💡 You can reinstall anytime using:${NC}"
    echo -e "  ${CYAN}curl -fsSL https://raw.githubusercontent.com/SalehGNUTUX/GT-CLPM/main/install.sh | bash${NC}"
    echo
    echo -e "${YELLOW}🙏 Thank you for using GT-CLPM!${NC}"
    echo
}

# Main uninstallation process
main() {
    echo -e "${BLUE}"
    echo "╔════════════════════════════════════════╗"
    echo "║           GT-CLPM Uninstaller         ║"
    echo "║              Version $VERSION              ║"
    echo "╚════════════════════════════════════════╝"
    echo -e "${NC}"
    
    # Confirm uninstallation
    echo -e "${YELLOW}This will completely remove GT-CLPM v$VERSION from your system.${NC}"
    echo -e "${YELLOW}This includes:${NC}"
    echo -e "  📦 ${GREEN}Program executable${NC} from $INSTALL_DIR and other locations"
    echo -e "  🖥️  ${GREEN}Desktop menu entries${NC} from all locations"
    echo -e "  🖼️  ${GREEN}Application icons${NC} (all sizes and resolutions)"
    echo -e "  ⚙️  ${GREEN}Configuration files${NC} and user data"
    echo -e "  💾 ${GREEN}Backup files${NC} (optional)"
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
