VERSION="1.0"
DOWNLOAD_URI="https://github.com/kittinunf/RealmBrowser-Plugin/releases/download/$VERSION/RealmBrowser.xcplugin.zip"
PLUGINS_DIR="${HOME}/Library/Application Support/Developer/Shared/Xcode/Plug-ins"

mkdir -p "${PLUGINS_DIR}"
curl -L $DOWNLOAD_URI | tar xvz -C "${PLUGINS_DIR}"

echo "RealmBrowser-Plugin is installed successfully"

