---
name: audio-routing
description: Route audio to USB microphone when connected, fall back to built-in
triggers:
  - type: usb
    match:
      productName: "Rode NT-USB"
    event: added
  - type: usb
    match:
      productName: "Rode NT-USB"
    event: removed
  - type: audio
    event: changed
---

## When my Rode NT-USB is connected

Always use the Rode NT-USB as the default audio input, even if I connect
Bluetooth headphones or other audio devices afterward.

Set the output volume to 50%.

## When my Rode NT-USB is disconnected

Fall back to "MacBook Pro Microphone" as the default audio input.

## When any audio device changes

If the Rode NT-USB is connected but is no longer the default input
(e.g. because a Bluetooth device took over), switch back to it.
