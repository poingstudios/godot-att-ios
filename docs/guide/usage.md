# Usage & API Reference

All plugin functions are available through the global `ATT` class (`class_name ATT`).

---

## Requesting Authorization

Call `ATT.request_tracking_authorization()` to display the native Apple permission dialog to the user.

You can handle the user's decision in two ways: via a **Callable callback** or via a **Signal**.

### Method 1: Using Inline Callback (Recommended)

```gdscript
extends Control

func _ready() -> void:
    ATT.request_tracking_authorization(_on_tracking_authorized)

func _on_tracking_authorized(status: ATT.Status) -> void:
    match status:
        ATT.Status.AUTHORIZED:
            print("Tracking authorized by user!")
            _initialize_ad_networks()
        ATT.Status.DENIED:
            print("Tracking denied by user.")
        ATT.Status.RESTRICTED:
            print("Tracking restricted (e.g. child account or MDM profile).")
        ATT.Status.NOT_DETERMINED:
            print("Permission not determined.")
```

### Method 2: Using the Global Signal

```gdscript
extends Control

func _ready() -> void:
    ATT.request_tracking_authorization_complete.connect(_on_tracking_complete)
    ATT.request_tracking_authorization()

func _on_tracking_complete(status: ATT.Status) -> void:
    print("Authorization completed with status: ", status)
```

---

## Querying Current Status

You can check whether permission was already requested or determine the current state at any time without triggering a prompt:

```gdscript
var current_status := ATT.get_tracking_authorization_status()

if current_status == ATT.Status.AUTHORIZED:
    print("User already approved tracking")
elif current_status == ATT.Status.NOT_DETERMINED:
    print("User has not been prompted yet")
```

---

## Accessing the Native Plugin Instance

If you ever need direct access to the underlying native engine singleton:

```gdscript
var raw_singleton := ATT.get_singleton()
```
