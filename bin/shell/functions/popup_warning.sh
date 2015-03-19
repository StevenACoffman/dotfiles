#!/bin/bash

function popupWarning() {

/usr/bin/osascript > /dev/null <<EOT
tell application "System Events"
	display dialog "Warning: $1"
end tell
EOT
}
