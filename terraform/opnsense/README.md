# Opnsense

## Overview
This describes custom firewall rules and settings for the Opnsense firewall.

These rules have been developed to pull in the latest threat intelligence from the following sources:

* [Blocklist.de](https://www.blocklist.de)
* [Emerging Threats](https://rules.emergingthreats.net)
* [Spamhaus](https://www.spamhaus.org)

## Requirements

```text
os-firewall
opnsense api key
```

This has been tested on:

* Opnsense 23.7.2

## Best Proctices

1. Create a new user
2. Generate a new extra long password for root
3. Disable root login

## API Key
You will need to create an API key for the Opnsense firewall.  This will be used to update the firewall rules.

Opnsense -> System -> Access -> Users -> Edit

## Opnsense Theme
Don't brun your eyes, use the dark theme.

Opnsense -> System -> Firmware -> Plugins

```text
os-theme-vicuna
```

Opnsense -> System -> Settings -> General -> Theme

## Maxmind GeoIP Settings
To setup GeoIP blocking you need to download the GeoIP database from Maxmind and install it on the Opnsense firewall.  The following steps will walk you through the process.

https://docs.opnsense.org/manual/how-tos/maxmind_geo_ip.html

## NextGen Firewall
You can download the ZenArmor NextGen Firewall by downloading the plugin at:

Opnsense -> System -> Firmware -> Plugins

```text
os-sensei
os-sensei-updater
os-sunnyvalley
```

## Crowdsec
You can download the Crowdsec plugin by downloading the plugin at:

Opnsense -> System -> Firmware -> Plugins

```text
os-crowdsec
```