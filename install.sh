#!/bin/bash

# GT-CLPM Installer
# Version: 1.2.2
# Developer: GNUTUX

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Configuration
VERSION="1.2.2"
REPO_URL="https://github.com/SalehGNUTUX/GT-CLPM"
SCRIPT_URL="https://raw.githubusercontent.com/SalehGNUTUX/GT-CLPM/main/GT-CLPM/gt-clpm.sh"
ICONS_BASE_URL="https://raw.githubusercontent.com/SalehGNUTUX/GT-CLPM/main/GT-CLPM/gt-usdr%20APPIAMGE%20BIULD/GT-CLPM-CLI.AppDir/usr/share/icons/hicolor"
INSTALL_DIR="/usr/local/bin"
SCRIPT_NAME="gt-clpm"
DESKTOP_ENTRY_DIR="/usr/share/applications"
ICONS_DIR="/usr/share/icons/hicolor"

# ─── Output helpers ───────────────────────────────────────────────────────────
print_status()  { echo -e "${GREEN}[INFO]${NC} $1"; }
print_warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
print_error()   { echo -e "${RED}[ERROR]${NC} $1"; }

# ─── Check root ───────────────────────────────────────────────────────────────
check_root() {
    if [[ $EUID -eq 0 ]]; then
        print_warning "Running as root user"
    fi
}

# ─── Download the main script ─────────────────────────────────────────────────
download_script() {
    print_status "Downloading GT-CLPM v${VERSION} script..."

    if command -v curl &>/dev/null; then
        curl -fsSL "$SCRIPT_URL" -o "/tmp/$SCRIPT_NAME"
    elif command -v wget &>/dev/null; then
        wget -q "$SCRIPT_URL" -O "/tmp/$SCRIPT_NAME"
    else
        print_error "Neither curl nor wget found. Please install one of them."
        exit 1
    fi

    if [[ ! -f "/tmp/$SCRIPT_NAME" ]]; then
        print_error "Failed to download the script"
        exit 1
    fi

    # Sanity-check: make sure we got a shell script, not an error page
    if ! head -1 "/tmp/$SCRIPT_NAME" | grep -q "^#!"; then
        print_error "Downloaded file does not look like a shell script."
        print_error "Check that $SCRIPT_URL is reachable."
        cat "/tmp/$SCRIPT_NAME" | head -5
        exit 1
    fi
}

# ─── Make executable ──────────────────────────────────────────────────────────
make_executable() {
    print_status "Making script executable..."
    chmod +x "/tmp/$SCRIPT_NAME"
}

# ─── Install the script ───────────────────────────────────────────────────────
install_script() {
    print_status "Installing to $INSTALL_DIR/$SCRIPT_NAME ..."

    if [[ ! -w "$INSTALL_DIR" ]]; then
        print_warning "Need root privileges to install to $INSTALL_DIR"
        sudo cp "/tmp/$SCRIPT_NAME" "$INSTALL_DIR/$SCRIPT_NAME"
        sudo chmod +x "$INSTALL_DIR/$SCRIPT_NAME"
    else
        cp "/tmp/$SCRIPT_NAME" "$INSTALL_DIR/$SCRIPT_NAME"
        chmod +x "$INSTALL_DIR/$SCRIPT_NAME"
    fi

    # Verify
    if command -v "$SCRIPT_NAME" &>/dev/null; then
        print_status "Script installed successfully at $(command -v $SCRIPT_NAME)"
    else
        print_error "Script installation failed — $INSTALL_DIR may not be in PATH"
        exit 1
    fi
}

# ─── Download and install icons ───────────────────────────────────────────────
install_icons() {
    print_status "Installing application icons..."

    local temp_icons_dir="/tmp/gt-clpm-icons"
    mkdir -p "$temp_icons_dir"

    local icon_sizes=("16x16" "32x32" "48x48" "64x64" "128x128" "256x256" "512x512")
    local icon_name="gt-clpm-cli-icon.png"
    local installed_icon_name="gt-clpm.png"
    local icons_ok=0

    for size in "${icon_sizes[@]}"; do
        local icon_url="${ICONS_BASE_URL}/${size}/apps/${icon_name}"
        local icon_dir="$ICONS_DIR/${size}/apps"
        local tmp_file="$temp_icons_dir/gt-clpm-${size}.png"

        if command -v curl &>/dev/null; then
            curl -fsSL "$icon_url" -o "$tmp_file" 2>/dev/null || { print_warning "Skipping ${size} icon (download failed)"; continue; }
        else
            wget -q "$icon_url" -O "$tmp_file" 2>/dev/null || { print_warning "Skipping ${size} icon (download failed)"; continue; }
        fi

        # Verify it's actually an image (PNG magic bytes)
        if ! file "$tmp_file" 2>/dev/null | grep -qi "PNG\|image"; then
            print_warning "Skipping ${size} icon (not a valid image)"
            rm -f "$tmp_file"
            continue
        fi

        if [[ ! -w "$ICONS_DIR" ]]; then
            sudo mkdir -p "$icon_dir"
            sudo cp "$tmp_file" "$icon_dir/$installed_icon_name"
            sudo chmod 644 "$icon_dir/$installed_icon_name"
        else
            mkdir -p "$icon_dir"
            cp "$tmp_file" "$icon_dir/$installed_icon_name"
            chmod 644 "$icon_dir/$installed_icon_name"
        fi
        print_status "✓ ${size} icon installed"
        ((icons_ok++))
    done

    rm -rf "$temp_icons_dir"

    if [[ $icons_ok -eq 0 ]]; then
        print_warning "No icons were installed (repository icons may not be uploaded yet)"
    else
        print_status "$icons_ok icon size(s) installed"
    fi
}

# ─── Create desktop entry ─────────────────────────────────────────────────────
create_desktop_entry() {
    print_status "Creating desktop entry..."

    local desktop_entry="[Desktop Entry]
Version=${VERSION}
Type=Application
Name=GT-CLPM
GenericName=Package Manager
Comment=GNUTUX Command Line Package Manager v${VERSION}
Exec=gt-clpm
Icon=gt-clpm
Categories=System;PackageManager;
Terminal=true
StartupNotify=true
Keywords=package;manager;install;remove;update;system;linux;flatpak;snap;

# Arabic metadata
Name[ar]=GT-CLPM
Comment[ar]=مدير حزم سطر الأوامر من جنوتكس الإصدار ${VERSION}
GenericName[ar]=مدير الحزم
Keywords[ar]=حزم;مدير;تثبيت;إزالة;تحديث;نظام;لينكس;فلاتباك;سناب"

    if [[ ! -w "$DESKTOP_ENTRY_DIR" ]]; then
        echo "$desktop_entry" | sudo tee "$DESKTOP_ENTRY_DIR/gt-clpm.desktop" > /dev/null
        sudo chmod 644 "$DESKTOP_ENTRY_DIR/gt-clpm.desktop"
    else
        echo "$desktop_entry" > "$DESKTOP_ENTRY_DIR/gt-clpm.desktop"
        chmod 644 "$DESKTOP_ENTRY_DIR/gt-clpm.desktop"
    fi

    print_status "Desktop entry created at $DESKTOP_ENTRY_DIR/gt-clpm.desktop"
}

# ─── Update desktop/icon databases ────────────────────────────────────────────
update_desktop_database() {
    if command -v update-desktop-database &>/dev/null; then
        print_status "Updating desktop database..."
        if [[ ! -w "$DESKTOP_ENTRY_DIR" ]]; then
            sudo update-desktop-database "$DESKTOP_ENTRY_DIR" 2>/dev/null || true
        else
            update-desktop-database "$DESKTOP_ENTRY_DIR" 2>/dev/null || true
        fi
    fi

    if command -v gtk-update-icon-cache &>/dev/null && [[ -d "$ICONS_DIR" ]]; then
        print_status "Updating icon cache..."
        if [[ ! -w "$ICONS_DIR" ]]; then
            sudo gtk-update-icon-cache -f -t "$ICONS_DIR" 2>/dev/null || true
        else
            gtk-update-icon-cache -f -t "$ICONS_DIR" 2>/dev/null || true
        fi
    fi
}

# ─── Handle existing installation ─────────────────────────────────────────────
check_existing() {
    if command -v "$SCRIPT_NAME" &>/dev/null; then
        local existing_path
        existing_path=$(command -v "$SCRIPT_NAME")
        print_warning "GT-CLPM is already installed at: $existing_path"
        echo -e "${YELLOW}Upgrading to v${VERSION}...${NC}"
    fi
}

# ─── Verify installation ──────────────────────────────────────────────────────
verify_installation() {
    print_status "Verifying installation..."

    local success=true

    if ! command -v "$SCRIPT_NAME" &>/dev/null; then
        print_error "Script not found in PATH"
        success=false
    else
        print_status "✓ Script installed: $(command -v $SCRIPT_NAME)"
    fi

    if [[ -f "$DESKTOP_ENTRY_DIR/gt-clpm.desktop" ]]; then
        print_status "✓ Desktop entry created"
    else
        print_warning "Desktop entry not found"
    fi

    local icon_check_path="$ICONS_DIR/64x64/apps/gt-clpm.png"
    if [[ -f "$icon_check_path" ]]; then
        print_status "✓ Icons installed"
    else
        print_warning "Icons may not be fully installed (non-critical)"
    fi

    if [[ "$success" == "true" ]]; then
        print_status "✓ Installation of GT-CLPM v${VERSION} completed successfully!"
        return 0
    else
        print_error "Installation completed with errors"
        return 1
    fi
}

# ─── Success banner ───────────────────────────────────────────────────────────
show_success() {
    echo
    echo -e "${GREEN}╔════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║          INSTALLATION COMPLETE         ║${NC}"
    echo -e "${GREEN}╚════════════════════════════════════════╝${NC}"
    echo
    echo -e "${BLUE}🎉 GT-CLPM v${VERSION} has been successfully installed!${NC}"
    echo
    echo -e "${YELLOW}📝 Usage:${NC}"
    echo -e "  ${GREEN}Terminal:${NC}          gt-clpm"
    echo -e "  ${GREEN}Application menu:${NC}  Search for 'GT-CLPM' → System Tools"
    echo
    echo -e "${YELLOW}✨ What was installed:${NC}"
    echo -e "  📦 Main script       → /usr/local/bin/gt-clpm"
    echo -e "  🖼️  Icons (7 sizes)   → /usr/share/icons/hicolor/"
    echo -e "  🖥️  Desktop entry     → /usr/share/applications/gt-clpm.desktop"
    echo
    echo -e "${YELLOW}🆕 New in v${VERSION}:${NC}"
    echo -e "  🔍 Fixed Flatpak search (no more missing results)"
    echo -e "  📄 Paginated results (n/p to navigate)"
    echo -e "  🛠️  All language tool menus fully implemented"
    echo -e "  ➕ Repository/PPA management"
    echo
    echo -e "${BLUE}🚀 Run now:${NC} ${GREEN}gt-clpm${NC}"
    echo
}

# ─── Main ─────────────────────────────────────────────────────────────────────
main() {
    echo -e "${BLUE}"
    echo "╔════════════════════════════════════════╗"
    echo "║           GT-CLPM Installer            ║"
    echo "║            Version ${VERSION}            ║"
    echo "╚════════════════════════════════════════╝"
    echo -e "${NC}"
    echo -e "${YELLOW}Installing GT-CLPM v${VERSION} with full desktop integration...${NC}"
    echo

    check_root
    check_existing
    download_script
    make_executable
    install_script
    install_icons
    create_desktop_entry
    update_desktop_database
    verify_installation
    show_success
}

main "$@"
