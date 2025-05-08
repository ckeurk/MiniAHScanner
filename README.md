# MiniAHScanner

## Description
MiniAHScanner is a lightweight addon for World of Warcraft that scans the Auction House to record item prices and display them in tooltips. Inspired by Auctionator, this addon focuses solely on displaying prices in tooltips without the advanced features of Auctionator.

## Features
- Auction House scanning to record item prices
- Display of Auction House prices in item tooltips
- Display of vendor prices in tooltips
- Option for automatic scanning when opening the Auction House
- Minimap button for quick access to options and manual scanning
- Sound notification when scan completes
- Real-time timer display for the next available scan
- Progress bar showing scan status
- Multi-language support (English, French, German, Russian)
- Slash commands for controlling the addon

## Installation
1. Download the addon from CurseForge
2. Extract the contents to the `Interface\AddOns` folder of your World of Warcraft installation
3. Restart the game or use `/reload` to load the addon

## Usage
- Use `/mah` or `/miniahscanner` to display available commands
- Use `/mah scan` to start a manual scan of the Auction House
- Use `/mah options` to open the options panel

## Options
### General
- View addon information and statistics
- Start a manual scan

### Scan
- Enable/disable automatic scanning when opening the Auction House
- Set the interval between automatic scans (15-60 minutes)
- Enable/disable scan completion sound

### Display
- Configure tooltip display options
- Show/hide vendor prices
- Show/hide Auction House prices
- Customize price display format

### Advanced
- Configure data retention settings
- Clear scan data

## Dependencies
The addon uses the following libraries:
- LibStub
- LibDataBroker-1.1
- LibDBIcon-1.0

## Limitations
- The addon is designed to be lightweight and only scans items currently visible in the Auction House
- Complete scanning is limited to avoid server disconnection (15 minutes maximum)
- Prices are updated only when you browse the Auction House

## Compatibility
- Works with both Retail and Classic versions of World of Warcraft
- Compatible with ElvUI

## Localization
MiniAHScanner is available in the following languages:
- English
- French
- German
- Russian
- Spanish
- Italian
- Portuguese
- Korean
- Chinese (Simplified and Traditional)

## Version
1.1.0 for World of Warcraft 10.1.5+
