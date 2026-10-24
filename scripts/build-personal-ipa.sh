#!/bin/bash
set -euo pipefail
cd "$(dirname "$0")/.."
mkdir -p build
xcodebuild -version
xcodebuild \
  -project "Clash Dash.xcodeproj" \
  -scheme "Clash Dash" \
  -configuration Release \
  -destination 'generic/platform=iOS' \
  -archivePath "$PWD/build/ClashDash.xcarchive" \
  -derivedDataPath "$PWD/build/DerivedData" \
  CODE_SIGN_IDENTITY='' \
  CODE_SIGNING_REQUIRED=NO \
  CODE_SIGNING_ALLOWED=NO \
  DEVELOPMENT_TEAM='' \
  archive 2>&1 | tee build/build.log

python3 - <<'PY'
import pathlib
import plistlib
import shutil

root = pathlib.Path('build')
apps = list((root / 'ClashDash.xcarchive/Products/Applications').glob('*.app'))
if len(apps) != 1:
    raise RuntimeError(f'Expected one archived app, found {len(apps)}')
with (apps[0] / 'Info.plist').open('rb') as f:
    info = plistlib.load(f)
assert info['CFBundleSupportedPlatforms'] == ['iPhoneOS'], info
print('Bundle:', info['CFBundleIdentifier'])
print('Minimum iOS:', info.get('MinimumOSVersion'))
payload = root / 'package/Payload'
payload.mkdir(parents=True, exist_ok=True)
target = payload / apps[0].name
if target.exists():
    raise RuntimeError('Use a fresh build directory to avoid stale package files')
shutil.copytree(apps[0], target, symlinks=True)
PY
(cd build/package && /usr/bin/ditto -c -k --sequesterRsrc --keepParent Payload ../Clash-Dash-TrollStore.ipa)
unzip -t build/Clash-Dash-TrollStore.ipa
(cd build && shasum -a 256 Clash-Dash-TrollStore.ipa > SHA256SUMS)
