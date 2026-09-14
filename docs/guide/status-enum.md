# Status Enum Reference

The plugin defines `ATT.Status`, mapping 1:1 to Apple's native `ATTrackingManager.AuthorizationStatus`.

```gdscript
enum Status {
    NOT_DETERMINED = 0,
    RESTRICTED = 1,
    DENIED = 2,
    AUTHORIZED = 3,
}
```

---

## Detailed Status Descriptions

| Enum Value | Raw Integer | Native Apple Equivalent | Description |
| :--- | :--- | :--- | :--- |
| `ATT.Status.NOT_DETERMINED` | `0` | `.notDetermined` | The user has not yet received an authorization request prompt. |
| `ATT.Status.RESTRICTED` | `1` | `.restricted` | Authorization is denied due to device restrictions (e.g., parental controls, enterprise profile, or age under 18). Calling `request_tracking_authorization()` will **not** display a dialog. |
| `ATT.Status.DENIED` | `2` | `.denied` | The user tapped "Ask App not to Track" in the prompt, or tracking is globally disabled in iOS Settings (**Settings > Privacy & Security > Tracking**). |
| `ATT.Status.AUTHORIZED` | `3` | `.authorized` | The user tapped "Allow" in the tracking prompt. The application can read the IDFA (`ASIdentifierManager.advertisingIdentifier`). |

---

## Best Practices for Ad Networks

When integrating AdMob, AppLovin, Unity Ads, or ironSource:
1. Call `ATT.request_tracking_authorization()` **before** initializing your ad networks.
2. Wait for the `request_tracking_authorization_complete` signal or callback before loading consent forms (UMP) or requesting initial ad impressions.
3. If the status is `DENIED` or `RESTRICTED`, ad networks will still serve ads, but they will be non-personalized (contextual only).
