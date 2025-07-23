#!/bin/bash

# Version management script for HubSpot Project Actions

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to validate semantic version
validate_version() {
    local version=$1
    if [[ ! $version =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
        print_error "Version must be in semantic version format (e.g., 1.0.0)"
        exit 1
    fi
}

# Function to get current version from git tags
get_current_version() {
    local latest_tag=$(git describe --tags --abbrev=0 2>/dev/null || echo "v0.0.0")
    echo "${latest_tag#v}"
}

# Function to create a new version
create_version() {
    local version=$1
    local message=${2:-"Release v$version"}
    
    print_info "Creating version v$version..."
    
    # Validate version format
    validate_version "$version"
    
    # Check if tag already exists
    if git tag -l "v$version" | grep -q "v$version"; then
        print_error "Tag v$version already exists"
        exit 1
    fi
    
    # Create and push tag
    git tag -a "v$version" -m "$message"
    git push origin "v$version"
    
    print_info "✅ Successfully created and pushed tag v$version"
}

# Function to list all versions
list_versions() {
    print_info "Available versions:"
    git tag -l | sort -V | while read tag; do
        echo "  $tag"
    done
}

# Function to show version info
show_version_info() {
    local version=$1
    if [ -z "$version" ]; then
        version=$(get_current_version)
    fi
    
    print_info "Version: v$version"
    
    # Show commit info for this version
    if git tag -l "v$version" | grep -q "v$version"; then
        echo "  Commit: $(git rev-parse "v$version")"
        echo "  Date: $(git log -1 --format=%cd "v$version")"
        echo "  Message: $(git tag -l "v$version" -n999 | tail -n +2 | sed 's/^[[:space:]]*//')"
    else
        print_warning "Version v$version not found in tags"
    fi
}

# Main script logic
case "${1:-help}" in
    "create")
        if [ -z "$2" ]; then
            print_error "Version number required. Usage: $0 create <version> [message]"
            exit 1
        fi
        create_version "$2" "$3"
        ;;
    "list")
        list_versions
        ;;
    "info")
        show_version_info "$2"
        ;;
    "current")
        current_version=$(get_current_version)
        print_info "Current version: v$current_version"
        ;;
    "help"|*)
        echo "HubSpot Project Actions Version Manager"
        echo ""
        echo "Usage: $0 <command> [options]"
        echo ""
        echo "Commands:"
        echo "  create <version> [message]  Create a new version tag"
        echo "  list                        List all available versions"
        echo "  info [version]              Show information about a version"
        echo "  current                     Show current version"
        echo "  help                        Show this help message"
        echo ""
        echo "Examples:"
        echo "  $0 create 1.0.0"
        echo "  $0 create 1.1.0 'Add new features'"
        echo "  $0 list"
        echo "  $0 info 1.0.0"
        ;;
esac 