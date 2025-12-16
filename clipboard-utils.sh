# clipboard-utils.sh: Portable clipboard utilities for pbcopy/pbpaste
# Detects OS and sets up aliases if pbcopy/pbpaste are not available

# Function to create dummy aliases that do nothing
create_dummy_aliases() {
    alias pbcopy=':'
    alias pbpaste='echo ""'
}

# Detect OS and set clipboard commands
case "$(uname -s)" in
    Darwin)
        # macOS: pbcopy/pbpaste are native, do nothing
        ;;
    Linux)
        if command -v wl-copy >/dev/null 2>&1 && command -v wl-paste >/dev/null 2>&1; then
            # Wayland
            CLIPBOARD_COPY_CMD="wl-copy"
            CLIPBOARD_PASTE_CMD="wl-paste"
        elif command -v xclip >/dev/null 2>&1; then
            # X11
            CLIPBOARD_COPY_CMD="xclip -selection clipboard"
            CLIPBOARD_PASTE_CMD="xclip -selection clipboard -o"
        else
            # No tools available, create dummies
            create_dummy_aliases
            return
        fi
        ;;
    MINGW*)
        # Windows (Git Bash with PowerShell)
        CLIPBOARD_COPY_CMD="clip.exe"
        CLIPBOARD_PASTE_CMD='powershell.exe -command "Get-Clipboard"'
        ;;
    *)
        # Unknown OS, create dummies
        create_dummy_aliases
        return
        ;;
esac

# If pbcopy doesn't exist, create aliases
if ! command -v pbcopy >/dev/null 2>&1; then
    alias pbcopy="$CLIPBOARD_COPY_CMD"
fi

# If pbpaste doesn't exist, create aliases
if ! command -v pbpaste >/dev/null 2>&1; then
    alias pbpaste="$CLIPBOARD_PASTE_CMD"
fi