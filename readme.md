# CensusPlusClassic
[![Download CensusPlusClassic Wow Addon](https://i.ibb.co/3RZG6vq/Censusplus-Classic.jpg)](https://github.com/christophrus/CensusPlusClassic/releases/latest/download/CensusPlusClassic.zip)

![Last release](https://img.shields.io/github/release-date/christophrus/CensusPlusClassic.svg) ![Current Version](https://img.shields.io/github/tag/christophrus/CensusPlusClassic.svg) [![Total Downloads](https://img.shields.io/github/downloads/christophrus/CensusPlusClassic/total.svg)]((https://github.com/christophrus/CensusPlusClassic/releases/latest/download/CensusPlusClassic.zip))  ![Code Size](https://img.shields.io/github/languages/code-size/christophrus/CensusPlusClassic.svg) ![License](https://img.shields.io/github/license/christophrus/CensusPlusClassic.svg?label=license) [![Discord](https://img.shields.io/discord/591950767640936500.svg)](https://discordapp.com/invite/MYPWGkv)

This is an interface addon for World of Warcraft: Classic which records details about characters currently online in your realms faction at the time of the polling. This is done with liberal use of the in-game /who command. The information is then stored in the CensusPlusClassic.lua in your account's SavedVariables folder, which can be uploaded to the aggregator website [Wow Classic Population](https://wowclassicpopulation). This site sorts all uploaded information and displays it in chart and graph form.

## Contribute 

These instructions will explain you how to install the addon and how you can participate in collecting census data.

### Prerequisites

Donwload the latest version of the addon: [CensusPlusClassic.zip](https://github.com/christophrus/CensusPlusClassic/releases/latest/download/CensusPlusClassic.zip)

### Installing the addon

- Use an unzipping propram like 7zip and extract the CensusPlusClassic folder to your addons directory
- The beta addon directory is usually located here:
-- `C:\Program Files\World of Warcraft\_classic_beta_\Interface\AddOns`
- When you log into the game the CensusPlusClassic addon automatically starts collecting data. You can watch the progress through the minimap icon.
- After the census is taken you get a message in chat how many characters were recorded
- Logout or do a /reload to force the addon to write its data into the *.lua file
- Navigate to `C:\Program Files\World of Warcraft\_classic_beta_\WTF\Account\1234567#1\SavedVariables\` and find the CensusPlusClassic.lua (1234567#1 is a different number for you or your account name)
- Upload the `CensusPlusClassic.lua` on [WowClassicpopulation.com](https://wowclassicpopulation.com/contribute)

<p align="center">
  <a href="https://wowclassicpopulation.com/"><img src="https://i.ibb.co/wrsLC9L/wow-classic-population-census-project.jpg" alt="Wow Classic Population census project"/></a>
</p>
