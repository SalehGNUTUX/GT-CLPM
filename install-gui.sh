#!/bin/bash

# GT-CLPM GUI Installer
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
REPO_URL="https://github.com/SalehGNUTUX/GT-CLPM"
SCRIPT_URL="https://raw.githubusercontent.com/SalehGNUTUX/GT-CLPM/main/GT-CLPM/gt-clpm-gui.sh"
ICONS_BASE_URL="https://raw.githubusercontent.com/SalehGNUTUX/GT-CLPM/main/GT-CLPM/gt-usdr%20APPIAMGE%20BIULD/GT-CLPM-GUI.AppDir/usr/share/icons/hicolor"
INSTALL_DIR="/usr/local/bin"
SCRIPT_NAME="gt-clpm-gui"
DESKTOP_ENTRY_DIR="/usr/share/applications"
ICONS_DIR="/usr/share/icons/hicolor"
ICON_NAME="gt-clpm-gui-icon.png"
INSTALLED_ICON_NAME="gt-clpm-gui.png"

# ─── Output helpers ───────────────────────────────────────────────────────────
print_status()  { echo -e "${GREEN}[INFO]${NC} $1"; }
print_warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
print_error()   { echo -e "${RED}[ERROR]${NC} $1"; }
print_success() { echo -e "${CYAN}[SUCCESS]${NC} $1"; }

# ─── Check root ───────────────────────────────────────────────────────────────
check_root() {
    if [[ $EUID -eq 0 ]]; then
        print_warning "Running as root user"
    fi
}

# ─── Check GUI dependencies (zenity required) ─────────────────────────────────
check_dependencies() {
    print_status "Checking GUI dependencies..."

    local missing=()

    # zenity (required — واجهة افتراضية)
    if ! command -v zenity &>/dev/null; then
        missing+=("zenity")
    fi

    if [[ ${#missing[@]} -gt 0 ]]; then
        print_warning "Missing dependencies: ${missing[*]}"
        print_status "Attempting to install missing dependencies..."

        if command -v apt &>/dev/null; then
            sudo apt install -y "${missing[@]}"
        elif command -v dnf &>/dev/null; then
            sudo dnf install -y "${missing[@]}"
        elif command -v pacman &>/dev/null; then
            sudo pacman -S --noconfirm "${missing[@]}"
        elif command -v zypper &>/dev/null; then
            sudo zypper install -y "${missing[@]}"
        elif command -v eopkg &>/dev/null; then
            sudo eopkg install "${missing[@]}"
        else
            print_error "Could not install dependencies automatically."
            print_error "Please install manually: ${missing[*]}"
            exit 1
        fi

        # Verify after install
        for dep in "${missing[@]}"; do
            if ! command -v "$dep" &>/dev/null; then
                print_error "Failed to install: $dep"
                exit 1
            fi
        done
        print_success "All dependencies installed successfully"
    else
        print_success "All required dependencies are present"
    fi

    # kdialog (optional — اختياري لبيئة KDE)
    if ! command -v kdialog &>/dev/null; then
        print_warning "kdialog not found (optional — needed only for KDE UI mode)"
        print_warning "Install with: apt install kdialog  |  pacman -S kdialog  |  dnf install kdialog"
    else
        print_success "kdialog found (optional KDE UI available)"
    fi
}

# ─── Check existing installation ──────────────────────────────────────────────
check_existing() {
    if command -v "$SCRIPT_NAME" &>/dev/null; then
        local existing_path
        existing_path=$(command -v "$SCRIPT_NAME")
        print_warning "GT-CLPM GUI is already installed at: $existing_path"
        echo -e "${YELLOW}Upgrading to v${VERSION}...${NC}"
    fi
}

# ─── Download the main script ─────────────────────────────────────────────────
download_script() {
    print_status "Downloading GT-CLPM GUI v${VERSION} script..."

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

    # Sanity check — make sure it's a shell script
    if ! head -1 "/tmp/$SCRIPT_NAME" | grep -q "^#!"; then
        print_error "Downloaded file does not look like a shell script."
        print_error "Check that $SCRIPT_URL is reachable."
        head -5 "/tmp/$SCRIPT_NAME"
        exit 1
    fi

    print_success "Script downloaded successfully"
}

# ─── Make executable ──────────────────────────────────────────────────────────
make_executable() {
    print_status "Setting executable permissions..."
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

    if command -v "$SCRIPT_NAME" &>/dev/null; then
        print_success "Script installed at $(command -v $SCRIPT_NAME)"
    else
        print_error "Script installation failed — $INSTALL_DIR may not be in PATH"
        exit 1
    fi
}

# ─── Download and install icons ───────────────────────────────────────────────
install_icons() {
    print_status "Installing application icons..."

    local temp_icons_dir="/tmp/gt-clpm-gui-icons"
    mkdir -p "$temp_icons_dir"

    local icon_sizes=("16x16" "32x32" "48x48" "64x64" "128x128" "256x256" "512x512")
    local icons_ok=0

    for size in "${icon_sizes[@]}"; do
        local icon_url="${ICONS_BASE_URL}/${size}/apps/${ICON_NAME}"
        local icon_dir="$ICONS_DIR/${size}/apps"
        local tmp_file="$temp_icons_dir/gt-clpm-gui-${size}.png"

        if command -v curl &>/dev/null; then
            curl -fsSL "$icon_url" -o "$tmp_file" 2>/dev/null || { print_warning "Skipping ${size} icon (download failed)"; continue; }
        else
            wget -q "$icon_url" -O "$tmp_file" 2>/dev/null || { print_warning "Skipping ${size} icon (download failed)"; continue; }
        fi

        # Verify it is a valid PNG (non-empty file)
        if [[ ! -s "$tmp_file" ]]; then
            print_warning "Skipping ${size} icon (empty file)"
            rm -f "$tmp_file"
            continue
        fi

        if [[ ! -w "$ICONS_DIR" ]]; then
            sudo mkdir -p "$icon_dir"
            sudo cp "$tmp_file" "$icon_dir/$INSTALLED_ICON_NAME"
            sudo chmod 644 "$icon_dir/$INSTALLED_ICON_NAME"
        else
            mkdir -p "$icon_dir"
            cp "$tmp_file" "$icon_dir/$INSTALLED_ICON_NAME"
            chmod 644 "$icon_dir/$INSTALLED_ICON_NAME"
        fi
        print_status "✓ ${size} icon installed"
        icons_ok=$((icons_ok + 1))
    done

    rm -rf "$temp_icons_dir"

    if [[ $icons_ok -eq 0 ]]; then
        print_warning "No icons were installed (check repository icon paths)"
    else
        print_success "$icons_ok icon size(s) installed"
    fi
}

# ─── Create desktop entry ─────────────────────────────────────────────────────
create_desktop_entry() {
    print_status "Creating desktop entry..."

    local desktop_entry="[Desktop Entry]
Version=${VERSION}
Type=Application
Name=GT-CLPM GUI
GenericName=Package Manager
Comment=GNUTUX Command Line Package Manager (GUI) v${VERSION}
Exec=gt-clpm-gui
Icon=gt-clpm-gui
Categories=System;PackageManager;
Terminal=false
StartupNotify=true
Keywords=package;manager;install;remove;update;system;linux;flatpak;snap;zenity;gui;

# Arabic metadata
Name[ar]=GT-CLPM الواجهة الرسومية
Comment[ar]=مدير حزم سطر الأوامر من جنوتكس (واجهة رسومية) الإصدار ${VERSION}
GenericName[ar]=مدير الحزم
Keywords[ar]=حزم;مدير;تثبيت;إزالة;تحديث;نظام;لينكس;فلاتباك;سناب;واجهة;"

    if [[ ! -w "$DESKTOP_ENTRY_DIR" ]]; then
        echo "$desktop_entry" | sudo tee "$DESKTOP_ENTRY_DIR/gt-clpm-gui.desktop" > /dev/null
        sudo chmod 644 "$DESKTOP_ENTRY_DIR/gt-clpm-gui.desktop"
    else
        echo "$desktop_entry" > "$DESKTOP_ENTRY_DIR/gt-clpm-gui.desktop"
        chmod 644 "$DESKTOP_ENTRY_DIR/gt-clpm-gui.desktop"
    fi

    print_success "Desktop entry created at $DESKTOP_ENTRY_DIR/gt-clpm-gui.desktop"
}

# ─── Update desktop/icon databases ────────────────────────────────────────────
update_desktop_database() {
    local desktop_file="$DESKTOP_ENTRY_DIR/gt-clpm-gui.desktop"

    # ── xdg-desktop-menu (standard — GTK and KDE) ──
    if command -v xdg-desktop-menu &>/dev/null; then
        print_status "Registering application via xdg-desktop-menu..."
        xdg-desktop-menu install --novendor "$desktop_file" 2>/dev/null || true
        print_success "Application registered via xdg-desktop-menu"
    fi

    # ── update-desktop-database (GNOME / GTK) ──
    if command -v update-desktop-database &>/dev/null; then
        print_status "Updating desktop database..."
        if [[ ! -w "$DESKTOP_ENTRY_DIR" ]]; then
            sudo update-desktop-database "$DESKTOP_ENTRY_DIR" 2>/dev/null || true
        else
            update-desktop-database "$DESKTOP_ENTRY_DIR" 2>/dev/null || true
        fi
        print_success "Desktop database updated"
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

# ─── Verify installation ──────────────────────────────────────────────────────
verify_installation() {
    print_status "Verifying installation..."

    local success=true

    if ! command -v "$SCRIPT_NAME" &>/dev/null; then
        print_error "Script not found in PATH"
        success=false
    else
        print_success "✓ Script installed: $(command -v $SCRIPT_NAME)"
    fi

    if [[ -f "$DESKTOP_ENTRY_DIR/gt-clpm-gui.desktop" ]]; then
        print_success "✓ Desktop entry created"
    else
        print_warning "Desktop entry not found (non-critical)"
    fi

    local icon_check="$ICONS_DIR/64x64/apps/$INSTALLED_ICON_NAME"
    if [[ -f "$icon_check" ]]; then
        print_success "✓ Icons installed"
    else
        print_warning "Icons may not be fully installed (non-critical)"
    fi

    if [[ "$success" == "true" ]]; then
        print_success "✓ Installation of GT-CLPM GUI v${VERSION} completed successfully!"
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
    echo -e "${BLUE}🎉 GT-CLPM GUI v${VERSION} has been successfully installed!${NC}"
    echo
    echo -e "${YELLOW}📝 Usage:${NC}"
    echo -e "  ${GREEN}Terminal:${NC}          gt-clpm-gui"
    echo -e "  ${GREEN}Application menu:${NC}  Search for 'GT-CLPM GUI' → System Tools"
    echo
    echo -e "${YELLOW}✨ What was installed:${NC}"
    echo -e "  📦 Main script       → /usr/local/bin/gt-clpm-gui"
    echo -e "  🖼️  Icons (7 sizes)   → /usr/share/icons/hicolor/"
    echo -e "  🖥️  Desktop entry     → /usr/share/applications/gt-clpm-gui.desktop"
    echo
    echo -e "${YELLOW}🆕 New in v${VERSION}:${NC}"
    echo -e "  🔍 Fixed Flatpak search with --print-column (correct App IDs)"
    echo -e "  ⏳ Progress bar during package search"
    echo -e "  🎨 zenity as universal default UI (all desktops)"
    echo -e "  🖼️  Optional KDialog support for KDE users"
    echo -e "  😊 Emoji icons across all menus and dialogs"
    echo -e "  🗂️  View current repositories option"
    echo -e "  ⬆️  Dist-upgrade as separate sub-menu option"
    echo
    echo -e "${BLUE}🚀 Run now:${NC} ${GREEN}gt-clpm-gui${NC}"
    echo
}

# ─── Main ─────────────────────────────────────────────────────────────────────
main() {
    echo -e "${BLUE}"
    echo "╔════════════════════════════════════════╗"
    echo "║        GT-CLPM GUI Installer           ║"
    echo "║           Version ${VERSION}             ║"
    echo "╚════════════════════════════════════════╝"
    echo -e "${NC}"
    echo -e "${YELLOW}Installing GT-CLPM GUI v${VERSION} with full desktop integration...${NC}"
    echo

    check_root
    check_existing
    check_dependencies
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
