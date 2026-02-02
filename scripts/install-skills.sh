#!/bin/bash

# Neural Claude Code - Skills Installer v1.0.0
# Interactive installer for skills from the plugin repository

set -e  # Exit on error

# ============================================================================
# CONSTANTS & CONFIGURATION
# ============================================================================

VERSION="1.0.0"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PLUGIN_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
REGISTRY_FILE="$PLUGIN_ROOT/.claude/skills-registry.json"
LOG_DIR="$HOME/.claude/setup/logs"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
LOG_FILE="$LOG_DIR/install-${TIMESTAMP}.json"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
RESET='\033[0m'

# Installation scope options
SCOPE_PROJECT="project"
SCOPE_GLOBAL="global"
SCOPE_BOTH="both"

# Selected values (globals)
declare -a SELECTED_SKILLS=()
SELECTED_SCOPE=""
DRY_RUN=false
AUTO_COMMIT=false

# ============================================================================
# UTILITY FUNCTIONS
# ============================================================================

log() {
    echo -e "${CYAN}[$(date +'%H:%M:%S')]${RESET} $*"
}

success() {
    echo -e "${GREEN}✓${RESET} $*"
}

error() {
    echo -e "${RED}✗${RESET} $*" >&2
}

warning() {
    echo -e "${YELLOW}⚠${RESET} $*"
}

info() {
    echo -e "${BLUE}ℹ${RESET} $*"
}

header() {
    echo ""
    echo -e "${BOLD}═══════════════════════════════════════════════════════════${RESET}"
    echo -e "${BOLD}  $*${RESET}"
    echo -e "${BOLD}═══════════════════════════════════════════════════════════${RESET}"
    echo ""
}

box() {
    local content="$1"
    local width=60
    echo "╔$(printf '═%.0s' $(seq 1 $width))╗"
    printf "║ %-${width}s ║\n" "$content"
    echo "╚$(printf '═%.0s' $(seq 1 $width))╝"
}

# ============================================================================
# PREREQUISITES CHECK
# ============================================================================

check_prerequisites() {
    log "Checking prerequisites..."

    local missing=()

    # Check bash version (need 4.0+ for associative arrays)
    if [ "${BASH_VERSINFO[0]}" -lt 4 ]; then
        missing+=("bash 4.0+")
    fi

    # Check jq for JSON parsing
    if ! command -v jq &> /dev/null; then
        missing+=("jq")
    fi

    # Check python3
    if ! command -v python3 &> /dev/null; then
        missing+=("python3")
    fi

    if [ ${#missing[@]} -gt 0 ]; then
        error "Missing prerequisites: ${missing[*]}"
        info "Install with: brew install ${missing[*]}"
        exit 1
    fi

    success "All prerequisites met"
}

# ============================================================================
# REGISTRY MANAGEMENT
# ============================================================================

load_registry() {
    if [ ! -f "$REGISTRY_FILE" ]; then
        error "Skills registry not found: $REGISTRY_FILE"
        exit 1
    fi

    # Validate JSON
    if ! jq empty "$REGISTRY_FILE" 2>/dev/null; then
        error "Invalid JSON in registry file"
        exit 1
    fi

    success "Loaded skills registry"
}

get_categories() {
    jq -r '.categories | keys[]' "$REGISTRY_FILE"
}

get_category_label() {
    local category="$1"
    jq -r ".categories.${category}.label" "$REGISTRY_FILE"
}

get_category_description() {
    local category="$1"
    jq -r ".categories.${category}.description" "$REGISTRY_FILE"
}

get_skills_in_category() {
    local category="$1"
    jq -r ".categories.${category}.skills[].id" "$REGISTRY_FILE"
}

get_skill_info() {
    local skill_id="$1"
    local field="$2"

    # Search all categories for the skill
    for category in $(get_categories); do
        local result=$(jq -r ".categories.${category}.skills[] | select(.id == \"${skill_id}\") | .${field}" "$REGISTRY_FILE" 2>/dev/null)
        if [ -n "$result" ] && [ "$result" != "null" ]; then
            echo "$result"
            return
        fi
    done

    echo ""
}

count_skills_in_category() {
    local category="$1"
    jq -r ".categories.${category}.skills | length" "$REGISTRY_FILE"
}

is_skill_installed() {
    local skill_id="$1"
    local scope="$2"  # "project" or "global"

    local installed=$(jq -r ".installed.${scope}[] | select(. == \"${skill_id}\")" "$REGISTRY_FILE" 2>/dev/null)
    [ -n "$installed" ]
}

mark_skill_installed() {
    local skill_id="$1"
    local scope="$2"

    # Add to registry
    local tmp_file=$(mktemp)
    jq ".installed.${scope} += [\"${skill_id}\"] | .installed.${scope} |= unique" "$REGISTRY_FILE" > "$tmp_file"
    mv "$tmp_file" "$REGISTRY_FILE"
}

# ============================================================================
# MENU FUNCTIONS
# ============================================================================

show_category_menu() {
    header "Neural Claude Code - Skills Installer v${VERSION}"

    echo "Select component category:"
    echo ""

    local categories=($(get_categories))
    local options=()
    local idx=1

    for category in "${categories[@]}"; do
        local label=$(get_category_label "$category")
        local count=$(count_skills_in_category "$category")
        options+=("$label ($count skills)")
        echo "  $idx) $label ($count skills)"
        ((idx++))
    done

    echo "  $idx) Install Recommended Bundle"
    options+=("Install Recommended Bundle")
    ((idx++))

    echo "  $idx) View Installation Status"
    options+=("View Installation Status")
    ((idx++))

    echo "  $idx) Cancel"
    options+=("Cancel")

    echo ""
    read -p "Select option [1-$idx]: " choice

    if [ "$choice" -eq ${#categories[@]} ]; then
        # Recommended bundle
        install_recommended_bundle
        return
    elif [ "$choice" -eq $((${#categories[@]} + 1)) ]; then
        # View status
        show_installation_status
        return
    elif [ "$choice" -eq $idx ]; then
        # Cancel
        log "Installation cancelled"
        exit 0
    elif [ "$choice" -ge 1 ] && [ "$choice" -le ${#categories[@]} ]; then
        # Category selected
        local selected_category="${categories[$((choice-1))]}"
        show_skill_selection "$selected_category"
    else
        error "Invalid selection"
        exit 1
    fi
}

show_skill_selection() {
    local category="$1"
    local category_label=$(get_category_label "$category")

    header "$category_label - Select Skills"

    local skills=($(get_skills_in_category "$category"))

    echo "Use numbers to toggle selection, then:"
    echo "  [i] Install selected"
    echo "  [s] Change scope"
    echo "  [a] Select all"
    echo "  [n] Select none"
    echo "  [b] Back"
    echo "  [q] Quit"
    echo ""

    # Default scope
    SELECTED_SCOPE="$SCOPE_PROJECT"

    # Track selections
    local -A selected_map
    for skill in "${skills[@]}"; do
        selected_map[$skill]=0
    done

    while true; do
        # Display skills
        local idx=1
        for skill in "${skills[@]}"; do
            local name=$(get_skill_info "$skill" "name")
            local desc=$(get_skill_info "$skill" "description")
            local is_installed=""

            if is_skill_installed "$skill" "project"; then
                is_installed=" ${GREEN}[project]${RESET}"
            elif is_skill_installed "$skill" "global"; then
                is_installed=" ${GREEN}[global]${RESET}"
            fi

            local checkbox="[ ]"
            if [ "${selected_map[$skill]}" -eq 1 ]; then
                checkbox="[${GREEN}✓${RESET}]"
            fi

            echo -e "  $idx) $checkbox $name - $desc$is_installed"
            ((idx++))
        done

        echo ""
        echo -e "Install to: ${BOLD}${SELECTED_SCOPE}${RESET} (./.claude/skills/ or ~/.claude/skills/)"
        echo ""
        read -p "Action: " action

        case "$action" in
            [0-9]*)
                # Toggle selection
                if [ "$action" -ge 1 ] && [ "$action" -le ${#skills[@]} ]; then
                    local skill="${skills[$((action-1))]}"
                    if [ "${selected_map[$skill]}" -eq 0 ]; then
                        selected_map[$skill]=1
                    else
                        selected_map[$skill]=0
                    fi
                fi
                ;;
            i|I)
                # Install
                SELECTED_SKILLS=()
                for skill in "${skills[@]}"; do
                    if [ "${selected_map[$skill]}" -eq 1 ]; then
                        SELECTED_SKILLS+=("$skill")
                    fi
                done

                if [ ${#SELECTED_SKILLS[@]} -eq 0 ]; then
                    warning "No skills selected"
                else
                    install_selected_skills
                    return
                fi
                ;;
            s|S)
                # Change scope
                show_scope_menu
                ;;
            a|A)
                # Select all
                for skill in "${skills[@]}"; do
                    selected_map[$skill]=1
                done
                ;;
            n|N)
                # Select none
                for skill in "${skills[@]}"; do
                    selected_map[$skill]=0
                done
                ;;
            b|B)
                # Back
                show_category_menu
                return
                ;;
            q|Q)
                # Quit
                log "Installation cancelled"
                exit 0
                ;;
            *)
                error "Invalid action"
                ;;
        esac

        # Clear screen and redraw
        clear
        header "$category_label - Select Skills"
        echo "Use numbers to toggle selection, then:"
        echo "  [i] Install selected  [s] Change scope  [a] Select all"
        echo "  [n] Select none  [b] Back  [q] Quit"
        echo ""
    done
}

show_scope_menu() {
    echo ""
    echo "Select installation scope:"
    echo "  1) Project (./.claude/skills/)"
    echo "  2) Global (~/.claude/skills/)"
    echo "  3) Both"
    echo ""
    read -p "Select [1-3]: " choice

    case "$choice" in
        1)
            SELECTED_SCOPE="$SCOPE_PROJECT"
            ;;
        2)
            SELECTED_SCOPE="$SCOPE_GLOBAL"
            ;;
        3)
            SELECTED_SCOPE="$SCOPE_BOTH"
            ;;
        *)
            error "Invalid selection"
            ;;
    esac
}

# ============================================================================
# INSTALLATION FUNCTIONS
# ============================================================================

install_selected_skills() {
    header "Installing ${#SELECTED_SKILLS[@]} Skills"

    log "Scope: $SELECTED_SCOPE"
    log "Skills: ${SELECTED_SKILLS[*]}"

    # Resolve dependencies
    resolve_dependencies

    # Confirm
    echo ""
    read -p "Proceed with installation? [y/N]: " confirm
    if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
        warning "Installation cancelled"
        exit 0
    fi

    # Create log directory
    mkdir -p "$LOG_DIR"

    # Install each skill
    local installed_count=0
    local failed_count=0

    for skill in "${SELECTED_SKILLS[@]}"; do
        if install_skill "$skill"; then
            ((installed_count++))
        else
            ((failed_count++))
        fi
    done

    # Summary
    echo ""
    success "Installation complete!"
    success "Installed: $installed_count"
    if [ $failed_count -gt 0 ]; then
        error "Failed: $failed_count"
    fi

    # Show usage
    show_usage_examples
}

install_skill() {
    local skill_id="$1"

    log "Installing skill: $skill_id"

    local source=$(get_skill_info "$skill_id" "source")
    local has_references=$(get_skill_info "$skill_id" "has_references")

    if [ -z "$source" ]; then
        error "Skill source not found: $skill_id"
        return 1
    fi

    # Determine target directories
    local targets=()
    if [ "$SELECTED_SCOPE" == "$SCOPE_PROJECT" ] || [ "$SELECTED_SCOPE" == "$SCOPE_BOTH" ]; then
        targets+=("./.claude/skills/$skill_id")
    fi
    if [ "$SELECTED_SCOPE" == "$SCOPE_GLOBAL" ] || [ "$SELECTED_SCOPE" == "$SCOPE_BOTH" ]; then
        targets+=("$HOME/.claude/skills/$skill_id")
    fi

    # Install to each target
    for target in "${targets[@]}"; do
        if [ "$DRY_RUN" = true ]; then
            info "[DRY RUN] Would install to: $target"
            continue
        fi

        mkdir -p "$target"

        # Copy skill.md
        if [ -f "$PLUGIN_ROOT/$source" ]; then
            cp "$PLUGIN_ROOT/$source" "$target/skill.md"
            success "Copied skill.md to $target"
        elif [ -d "$PLUGIN_ROOT/$source" ]; then
            cp "$PLUGIN_ROOT/$source/skill.md" "$target/skill.md"
            success "Copied skill.md to $target"

            # Copy references if they exist
            if [ "$has_references" == "true" ] && [ -d "$PLUGIN_ROOT/$source/references" ]; then
                mkdir -p "$target/references"
                cp -r "$PLUGIN_ROOT/$source/references/"* "$target/references/"
                success "Copied references to $target/references"
            fi
        else
            error "Source not found: $PLUGIN_ROOT/$source"
            return 1
        fi

        # Mark as installed
        local scope_name=$(basename "$(dirname "$target")")
        if [[ "$target" == "$HOME/.claude"* ]]; then
            mark_skill_installed "$skill_id" "global"
        else
            mark_skill_installed "$skill_id" "project"
        fi
    done

    return 0
}

resolve_dependencies() {
    log "Resolving dependencies..."

    local all_deps=()

    for skill in "${SELECTED_SKILLS[@]}"; do
        local deps=$(get_skill_info "$skill" "dependencies")
        if [ -n "$deps" ] && [ "$deps" != "null" ] && [ "$deps" != "[]" ]; then
            # Parse JSON array
            local dep_list=$(echo "$deps" | jq -r '.[]' 2>/dev/null)
            while IFS= read -r dep; do
                if [ -n "$dep" ]; then
                    all_deps+=("$dep")
                fi
            done <<< "$dep_list"
        fi
    done

    # Add dependencies to selected skills
    local added_deps=()
    for dep in "${all_deps[@]}"; do
        if [[ ! " ${SELECTED_SKILLS[@]} " =~ " ${dep} " ]]; then
            SELECTED_SKILLS+=("$dep")
            added_deps+=("$dep")
        fi
    done

    if [ ${#added_deps[@]} -gt 0 ]; then
        info "Added dependencies: ${added_deps[*]}"
    else
        success "No additional dependencies needed"
    fi
}

install_recommended_bundle() {
    header "Installing Recommended Bundle"

    SELECTED_SKILLS=()

    # Collect all recommended skills
    for category in $(get_categories); do
        local skills=($(get_skills_in_category "$category"))
        for skill in "${skills[@]}"; do
            local is_recommended=$(get_skill_info "$skill" "recommended")
            if [ "$is_recommended" == "true" ]; then
                SELECTED_SKILLS+=("$skill")
            fi
        done
    done

    log "Recommended skills: ${SELECTED_SKILLS[*]}"

    # Select scope
    show_scope_menu

    # Install
    install_selected_skills
}

# ============================================================================
# STATUS & REPORTING
# ============================================================================

show_installation_status() {
    header "Installation Status"

    echo -e "${BOLD}Project-Installed Skills:${RESET}"
    local project_skills=$(jq -r '.installed.project[]' "$REGISTRY_FILE" 2>/dev/null)
    if [ -z "$project_skills" ]; then
        echo "  (none)"
    else
        while IFS= read -r skill; do
            echo "  - $skill"
        done <<< "$project_skills"
    fi

    echo ""
    echo -e "${BOLD}Globally-Installed Skills:${RESET}"
    local global_skills=$(jq -r '.installed.global[]' "$REGISTRY_FILE" 2>/dev/null)
    if [ -z "$global_skills" ]; then
        echo "  (none)"
    else
        while IFS= read -r skill; do
            echo "  - $skill"
        done <<< "$global_skills"
    fi

    echo ""
    read -p "Press Enter to continue..." dummy
    show_category_menu
}

show_usage_examples() {
    header "Usage Examples"

    for skill in "${SELECTED_SKILLS[@]}"; do
        local name=$(get_skill_info "$skill" "name")
        local trigger=$(get_skill_info "$skill" "trigger")

        if [[ "$trigger" == /* ]]; then
            echo "  $trigger  # $name"
        else
            echo "  # $name triggers on: $trigger"
        fi
    done

    echo ""
    info "Skills are now available in your project!"
}

# ============================================================================
# MAIN ENTRY POINT
# ============================================================================

main() {
    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --dry-run)
                DRY_RUN=true
                shift
                ;;
            --commit)
                AUTO_COMMIT=true
                shift
                ;;
            --help|-h)
                echo "Neural Claude Code - Skills Installer v${VERSION}"
                echo ""
                echo "Usage: $0 [OPTIONS]"
                echo ""
                echo "Options:"
                echo "  --dry-run    Preview installation without making changes"
                echo "  --commit     Auto-commit installed skills"
                echo "  --help       Show this help message"
                exit 0
                ;;
            *)
                error "Unknown option: $1"
                exit 1
                ;;
        esac
    done

    # Run installer
    check_prerequisites
    load_registry
    show_category_menu
}

# Run main if executed directly
if [ "${BASH_SOURCE[0]}" == "${0}" ]; then
    main "$@"
fi
