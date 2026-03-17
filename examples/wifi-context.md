---
name: wifi-context
description: Adjust settings based on WiFi network (home vs office vs other)
triggers:
  - type: wifi
    match:
      ssid: "MyHomeNetwork"
    event: changed
  - type: wifi
    match:
      ssid: "OfficeWiFi"
    event: changed
---

## When I connect to my home WiFi

Set the audio output volume to 30%.
Show a notification "Welcome home".

## When I connect to the office WiFi

Mute the audio output.
Show a notification "At the office — audio muted".

## When I disconnect from both

Set the volume to 0% for safety.
