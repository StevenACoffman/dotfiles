#!/bin/bash
function clean_quarantine() {
    DIRECTORY_TO_CLEAN="${1:-$PWD}"
    xattr -dr com.apple.quarantine "${DIRECTORY_TO_CLEAN}"
}
