#!/bin/bash
function clean_quarantine() {
    DIRECTORY_TO_CLEAN="${1:-$PWD}"
    sudo xattr -dr com.apple.quarantine "${DIRECTORY_TO_CLEAN}"
}
