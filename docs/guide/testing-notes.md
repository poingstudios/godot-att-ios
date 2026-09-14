# Testing & Gotchas

Working with Apple's App Tracking Transparency framework involves special platform restrictions.

---

## ⚠️ Important: The Dialog Appears Only Once Per App Install

Apple restricts the ATT authorization dialog to appear **only once per application installation**.

- **First Launch**: `ATT.request_tracking_authorization()` displays the native dialog. The status changes from `NOT_DETERMINED` to `AUTHORIZED` or `DENIED`.
- **Subsequent Launches**: Calling `ATT.request_tracking_authorization()` will **not** display a dialog. It immediately returns the previously recorded decision.

### How to Reset Tracking for Testing

To re-test the authorization dialog during development:
1. **Uninstall the App**: Delete the app completely from your iOS Simulator or physical iPhone/iPad.
2. **Rebuild & Run**: Install the app again via Xcode or Godot iOS one-click deploy.
3. **Alternative (Settings Toggle)**: Go to **iOS Settings > Privacy & Security > Tracking > [Your App]** to toggle permission on or off without reinstalling.

---

## Global System Restriction

If the user has disabled tracking globally on their device:
- **Settings > Privacy & Security > Tracking > Allow Apps to Request to Track** is turned **OFF**.
- In this state, `ATT.get_tracking_authorization_status()` returns `RESTRICTED` or `DENIED`.
- Calling `ATT.request_tracking_authorization()` will **never** display the prompt; iOS automatically denies the request.

---

## Desktop Editor Behavior

When running your Godot project directly on your Mac, Windows, or Linux desktop:
- The native iOS plugin is not loaded.
- The GDScript wrapper catches this condition and returns `ATT.Status.NOT_DETERMINED` while printing a non-fatal warning:
  ```
  [ATT] Native plugin 'ATT' is only supported on iOS.
  ```
- Your game continues running smoothly without crashing during desktop development.
