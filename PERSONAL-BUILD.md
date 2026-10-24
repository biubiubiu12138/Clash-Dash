# Personal source build

Based on nowubh/Clash-Dash at upstream commit 4a3bfa2. Original copyright notices and AGPL-3.0 license are retained.

The inspected public Swift sources contain no in-app purchase or trial-expiry implementation. StoreKit in RateAppView is used for ratings, not purchases. This build therefore does not patch purchase validation or claim to contain the latest App Store features.

Run the **Personal TrollStore IPA** GitHub Actions workflow, then download the **Clash-Dash-TrollStore** artifact. It contains an unsigned iPhoneOS IPA, SHA-256 checksum, and the license. Source remains available in the fork.

The app, shared framework, and widget currently target iOS 16.0. Do not assume it works on iOS 15 merely because TrollStore can install it. iCloud and widget functionality also require on-device testing; an unsigned build is not automatically a fully functional Apple-service signed build.

Local builds require full Xcode with the iPhoneOS SDK. Run `bash scripts/build-personal-ipa.sh` from a fresh checkout. Build output is saved under `build/`.
