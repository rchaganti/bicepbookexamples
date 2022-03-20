#!/bin/bash
# Download bicep binary
curl -Lo bicep https://github.com/Azure/bicep/releases/latest/download/bicep-osx-x64

# Change execute bit
chmod +x ./bicep

# Add Gatekeeper exception
sudo spctl --add ./bicep

# Add bicep to PATH
sudo mv ./bicep /usr/local/bin/bicep

# print bicep version
bicep --version