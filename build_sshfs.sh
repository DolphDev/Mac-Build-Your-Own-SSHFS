#!/bin/bash

# Default values
OUTPUTDIR="$(pwd)"
REBUILD=0

# Parse input arguments
while getopts "o:r:" opt; do
  case $opt in
    o)
      OUTPUTDIR="$OPTARG"  # Set output directory
      ;;
    r)
      REBUILD="$OPTARG"  # Set rebuild flag
      ;;
    *)
      echo "Usage: $0 [-o outputdir] [-r rebuild]"
      exit 1
      ;;
  esac
done

# Define the SSHFS directory and build directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SSHFS_DIR="${SCRIPT_DIR}/sshfs-2.10"
BUILD_DIR="${SSHFS_DIR}/_build"
BINARY="${BUILD_DIR}/sshfs"

# Function to build SSHFS
build_sshfs() {
  echo "Building SSHFS..."

  # Navigate to sshfs-2.10 directory
  cd "$SSHFS_DIR" || { echo "Failed to navigate to $SSHFS_DIR"; exit 1; }

  # If rebuild is requested, remove _build directory
  if [ "$REBUILD" -eq 1 ]; then
    echo "Rebuilding from scratch. Removing _build directory..."
    rm -rf "$BUILD_DIR"
  fi

  # Create build directory if it doesn't exist
  mkdir -p "$BUILD_DIR"
  cd "$BUILD_DIR" || { echo "Failed to navigate to build directory $BUILD_DIR"; exit 1; }

  # Run meson setup for the initial configuration
  if [ "$REBUILD" -eq 1 ] || [ ! -f "build.ninja" ]; then
    meson setup .. || { echo "Meson setup failed"; exit 1; }
  else
    meson setup .. --reconfigure || { echo "Meson reconfiguration failed"; exit 1; }
  fi

  # Build the project with ninja
  ninja || { echo "Ninja build failed"; exit 1; }
  
  # Check if sshfs binary exists
  if [ ! -f "$BINARY" ]; then
    echo "Build failed, no sshfs binary found!"
    exit 1
  fi

  # Return to the original directory
  cd - || exit 1
}

# Build SSHFS if necessary
if [ ! -f "$BINARY" ] || [ "$REBUILD" -eq 1 ]; then
  build_sshfs
else
  echo "SSHFS is already built. Skipping build."
fi

# Copy sshfs binary to the output directory
echo "Copying sshfs binary to $OUTPUTDIR..."
cp "$BINARY" "$OUTPUTDIR"

echo "SSHFS has been built and copied to $OUTPUTDIR"
