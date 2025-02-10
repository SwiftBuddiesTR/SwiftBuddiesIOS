if test -d "/opt/homebrew/bin/"; then
  PATH="/opt/homebrew/bin/:${PATH}"
fi

export PATH

SOURCES_PATH="SwiftBuddiesIOS/Targets"

if which swiftlint >/dev/null; then
    swiftlint --config .swiftlint.yml --quiet $SOURCES_PATH
else
    echo "warning: SwiftLint not installed, download from https://github.com/realm/SwiftLint"
fi
