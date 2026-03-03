#!/bin/bash

# GT-CLPM GUI Uninstaller
# Version: 1.5.0
# Developer: GNUTUX

set -e

# ─── Colors ───────────────────────────────────────────────────────────────────
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# ─── Configuration ────────────────────────────────────────────────────────────
VERSION="1.5.0"
INSTALL_DIR="/usr/local/bin"
SCRIPT_NAME="gt-clpm-gui"
DESKTOP_ENTRY_DIR="/usr/share/applications"
ICONS_DIR="/usr/share/icons/hicolor"
INSTALLED_ICON_NAME="gt-clpm-gui.png"

# User config files
LANG_FILE="$HOME/.gt-clpm-lang"
MODE_FILE="$HOME/.gt-clpm-mode"
UI_FILE="$HOME/.gt-clpm-ui"
BACKUP_FILES="$HOME/gt-clpm-backup-*.txt"

# ─── Output helpers ───────────────────────────────────────────────────────────
print_status()  { echo -e "${GREEN}[INFO]${NC} $1"; }
print_warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
print_error()   { echo -e "${RED}[ERROR]${NC} $1"; }
print_success() { echo -e "${CYAN}[SUCCESS]${NC} $1"; }

# ─── Remove installed script ──────────────────────────────────────────────────
remove_script() {
    print_status "Removing GT-CLPM GUI script..."

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
        print_warning "GT-CLPM GUI script not found in standard locations"
    fi
}

# ─── Remove desktop entry ─────────────────────────────────────────────────────
remove_desktop_entry() {
    print_status "Removing desktop entries..."

    local desktop_files=(
        "$DESKTOP_ENTRY_DIR/gt-clpm-gui.desktop"
        "/usr/local/share/applications/gt-clpm-gui.desktop"
        "$HOME/.local/share/applications/gt-clpm-gui.desktop"
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

# ─── Remove icons ─────────────────────────────────────────────────────────────
remove_icons() {
    print_status "Removing application icons..."

    local icon_sizes=("16x16" "32x32" "48x48" "64x64" "128x128" "256x256" "512x512")
    local icons_removed=0

    for size in "${icon_sizes[@]}"; do
        local icon_path="$ICONS_DIR/${size}/apps/$INSTALLED_ICON_NAME"
        if [[ -f "$icon_path" ]]; then
            if [[ ! -w "$ICONS_DIR" ]]; then
                sudo rm -f "$icon_path"
            else
                rm -f "$icon_path"
            fi
            icons_removed=$((icons_removed + 1))
            print_success "Removed ${size} icon"

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
        print_success "Removed $icons_removed icon file(s)"
    else
        print_warning "No icons found to remove"
    fi
}

# ─── Remove configuration and data files ──────────────────────────────────────
remove_config_files() {
    print_status "Removing configuration and data files..."

    # Language preference
    if [[ -f "$LANG_FILE" ]]; then
        rm -f "$LANG_FILE"
        print_success "Removed language file: $LANG_FILE"
    else
        print_warning "Language file not found: $LANG_FILE"
    fi

    # Theme mode (dark/light)
    if [[ -f "$MODE_FILE" ]]; then
        rm -f "$MODE_FILE"
        print_success "Removed theme mode file: $MODE_FILE"
    else
        print_warning "Theme mode file not found: $MODE_FILE"
    fi

    # UI tool selection (zenity/kdialog)
    if [[ -f "$UI_FILE" ]]; then
        rm -f "$UI_FILE"
        print_success "Removed UI tool config: $UI_FILE"
    else
        print_warning "UI tool config not found: $UI_FILE"
    fi

    # Cache directory
    local cache_dir="$HOME/.cache/gt-clpm"
    if [[ -d "$cache_dir" ]]; then
        rm -rf "$cache_dir"
        print_success "Removed cache directory: $cache_dir"
    fi

    # Temporary files left by the app
    rm -f /tmp/gtclpm-*.* /tmp/gt-clpm-askpass-*.sh 2>/dev/null || true

    # Backup files (ask user)
    if ls $BACKUP_FILES 1>/dev/null 2>&1; then
        echo
        read -p "Do you want to remove GT-CLPM backup files (gt-clpm-backup-*.txt)? (y/N): " -n 1 -r
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
}

# ─── Update desktop database and icon cache ───────────────────────────────────
update_system_databases() {
    local desktop_file="$DESKTOP_ENTRY_DIR/gt-clpm-gui.desktop"

    # ── xdg-desktop-menu uninstall (standard — GTK and KDE) ──
    if command -v xdg-desktop-menu &>/dev/null; then
        print_status "Unregistering application via xdg-desktop-menu..."
        xdg-desktop-menu uninstall --novendor "$desktop_file" 2>/dev/null || true
        print_success "Application unregistered via xdg-desktop-menu"
    fi

    # ── update-desktop-database (GNOME / GTK) ──
    if command -v update-desktop-database &>/dev/null; then
        print_status "Updating desktop database..."
        local desktop_dirs=("$DESKTOP_ENTRY_DIR" "/usr/local/share/applications")
        for dir in "${desktop_dirs[@]}"; do
            if [[ -d "$dir" ]]; then
                if [[ ! -w "$dir" ]]; then
                    sudo update-desktop-database "$dir" 2>/dev/null || true
                else
                    update-desktop-database "$dir" 2>/dev/null || true
                fi
            fi
        done
        print_success "Desktop database updated"
    else
        print_warning "update-desktop-database not found, skipping"
    fi

    # ── gtk-update-icon-cache (GTK icon theme) ──
    if command -v gtk-update-icon-cache &>/dev/null && [[ -d "$ICONS_DIR" ]]; then
        print_status "Updating GTK icon cache..."
        if [[ ! -w "$ICONS_DIR" ]]; then
            sudo gtk-update-icon-cache -f -t "$ICONS_DIR" 2>/dev/null || true
        else
            gtk-update-icon-cache -f -t "$ICONS_DIR" 2>/dev/null || true
        fi
        print_success "GTK icon cache updated"
    else
        print_warning "gtk-update-icon-cache not found, skipping"
    fi

    # ── xdg-icon-resource forceupdate ──
    if command -v xdg-icon-resource &>/dev/null; then
        xdg-icon-resource forceupdate 2>/dev/null || true
    fi

    # ── KDE: kbuildsycoca (rebuilds KDE app menu cache) ──
    for kbuild in kbuildsycoca6 kbuildsycoca5 kbuildsycoca; do
        if command -v "$kbuild" &>/dev/null; then
            print_status "Updating KDE application cache ($kbuild)..."
            "$kbuild" --noincremental 2>/dev/null || true
            print_success "KDE application cache updated"
            break
        fi
    done
}

# ─── Verify uninstallation ────────────────────────────────────────────────────
verify_uninstallation() {
    print_status "Verifying uninstallation..."

    local success=true

    if command -v "$SCRIPT_NAME" &>/dev/null; then
        print_error "Script still found in PATH: $(command -v $SCRIPT_NAME)"
        success=false
    else
        print_success "✓ Script removed from PATH"
    fi

    local desktop_found=false
    for path in "$DESKTOP_ENTRY_DIR/gt-clpm-gui.desktop" \
                "/usr/local/share/applications/gt-clpm-gui.desktop"; do
        [[ -f "$path" ]] && desktop_found=true && break
    done

    if [[ "$desktop_found" == "false" ]]; then
        print_success "✓ Desktop entries removed"
    else
        print_error "Some desktop entries still exist"
        success=false
    fi

    local icon_check="$ICONS_DIR/64x64/apps/$INSTALLED_ICON_NAME"
    if [[ ! -f "$icon_check" ]]; then
        print_success "✓ Icons removed"
    else
        print_error "Some icons still exist"
        success=false
    fi

    if [[ "$success" == "true" ]]; then
        print_success "✓ GT-CLPM GUI v$VERSION successfully uninstalled!"
        return 0
    else
        print_error "Uninstallation may not be complete"
        return 1
    fi
}

# ─── Completion message ───────────────────────────────────────────────────────
show_completion() {
    echo
    echo -e "${GREEN}╔════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║         UNINSTALLATION COMPLETE        ║${NC}"
    echo -e "${GREEN}╚════════════════════════════════════════╝${NC}"
    echo
    echo -e "${BLUE}🗑️  GT-CLPM GUI v$VERSION has been completely removed from your system!${NC}"
    echo
    echo -e "${YELLOW}📝 What was removed:${NC}"
    echo -e "  📦 ${GREEN}Program executable${NC}        → /usr/local/bin/gt-clpm-gui"
    echo -e "  🖥️  ${GREEN}Desktop application entry${NC} → /usr/share/applications/"
    echo -e "  🖼️  ${GREEN}Application icons${NC}         → /usr/share/icons/hicolor/"
    echo -e "  ⚙️  ${GREEN}User configuration${NC}        → ~/.gt-clpm-lang / mode / ui"
    echo -e "  💾 ${GREEN}Backup files${NC}              (if selected)"
    echo
    echo -e "${GREEN}💡 You can reinstall anytime using:${NC}"
    echo -e "  ${CYAN}curl -fsSL https://raw.githubusercontent.com/SalehGNUTUX/GT-CLPM/main/install-gui.sh | bash${NC}"
    echo
    echo -e "${YELLOW}🙏 Thank you for using GT-CLPM GUI!${NC}"
    echo
}

# ─── Main ─────────────────────────────────────────────────────────────────────
main() {
    echo -e "${BLUE}"
    echo "╔════════════════════════════════════════╗"
    echo "║        GT-CLPM GUI Uninstaller         ║"
    echo "║            Version ${VERSION}             ║"
    echo "╚════════════════════════════════════════╝"
    echo -e "${NC}"

    echo -e "${YELLOW}This will completely remove GT-CLPM GUI v${VERSION} from your system.${NC}"
    echo -e "${YELLOW}This includes:${NC}"
    echo -e "  📦 ${GREEN}Program executable${NC}        from $INSTALL_DIR and other locations"
    echo -e "  🖥️  ${GREEN}Desktop menu entry${NC}        from all locations"
    echo -e "  🖼️  ${GREEN}Application icons${NC}         (all sizes)"
    echo -e "  ⚙️  ${GREEN}Configuration files${NC}       (language, theme, UI tool)"
    echo -e "  💾 ${GREEN}Backup files${NC}              (optional)"
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

main "$@"
