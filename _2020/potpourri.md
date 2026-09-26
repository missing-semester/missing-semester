---
layout: lecture
title: "Potpourri"
description: >
  Keyboard remapping, daemons, backups, APIs အပါအဝင် အသုံးဝင်သော ခေါင်းစဉ် အမျိုးအစားများစွာ အကြောင်း လေ့လာပါ။
thumbnail: /static/assets/thumbnails/2020/lec10.png
date: 2020-01-29
ready: true
video:
  aspect: 56.25
  id: JZDt-PRq0uo
special: true
---

## Table of Contents

- [Keyboard remapping](#keyboard-remapping)
- [Daemons](#daemons)
- [FUSE](#fuse)
- [Backups](#backups)
- [APIs](#apis)
- [Common command-line flags/patterns](#common-command-line-flagspatterns)
- [Window managers](#window-managers)
- [VPNs](#vpns)
- [Markdown](#markdown)
- [Hammerspoon (desktop automation on macOS)](#hammerspoon-desktop-automation-on-macos)
- [Booting + Live USBs](#booting--live-usbs)
- [Docker, Vagrant, VMs, Cloud, OpenStack](#docker-vagrant-vms-cloud-openstack)
- [Notebook programming](#notebook-programming)
- [GitHub](#github)

## Keyboard remapping

Programmer တစ်ယောက်အဖြစ် သင်၏ ကီးဘုတ်သည် အဓိက Input နည်းလမ်း ဖြစ်ပါသည်။ ကွန်ပျူတာရှိ အရာအားလုံးကဲ့သို့ပင် ယင်းကို စိတ်ကြိုက် ပြင်ဆင်ဖန်တီးနိုင်ပါသည် (ပြင်ဆင်ရန်လည်း ထိုက်တန်ပါသည်)။

အခြေခံကျသော အပြောင်းအလဲမှာ ခလုတ်များကို ပြန်လည် သတ်မှတ်ခြင်း (remap) ဖြစ်ပါသည်။
ဤသည်မှာ သီးခြား ခလုတ်တစ်ခုကို နှိပ်လိုက်သည့်အခါ ယင်းကို ဖမ်းယူပြီး အခြား ခလုတ်တစ်ခုဖြင့် အစားထိုးပေးသည့် Software ဖြင့် ပြုလုပ်လေ့ ရှိသည်။ ဥပမာ -
- Caps Lock ကို Ctrl သို့မဟုတ် Escape သို့ Remap ပြုလုပ်ခြင်း။ Caps Lock သည် အဆင်ပြေသော နေရာတွင် ရှိသော်လည်း မကြာခဏ မသုံးသောကြောင့် ဤသို့ သတ်မှတ်ရန် အလွန် အကြံပြုပါသည်။
- PrtSc ကို သီချင်း Play/Pause သို့ Remap ပြုလုပ်ခြင်း။
- Ctrl နှင့် Meta (Windows သို့မဟုတ် Command) ခလုတ်များကို လဲလှယ်ခြင်း။

ထို့အပြင် ခလုတ်များကို မိမိ စိတ်ကြိုက် Command များသို့လည်း တွဲဆက်နိုင်ပါသည်။
- Terminal သို့မဟုတ် Browser window အသစ် ဖွင့်ခြင်း။
- သီးခြား စာသားများ ရိုက်နှိပ်ပေးခြင်း (ဥပမာ သင်၏ Email လိပ်စာ သို့မဟုတ် ကျောင်းသား ID နံပါတ်)။
- ကွန်ပျူတာ သို့မဟုတ် မျက်နှာပြင်ကို Sleep ပြုလုပ်ခြင်း။

ပိုမို ရှုပ်ထွေးသော ပြင်ဆင်မှုများလည်း ပြုလုပ်နိုင်ပါသည် -
- Shift ကို ၅ ကြိမ် နှိပ်ပါက Caps Lock ဖွင့်/ပိတ် ပြုလုပ်ခြင်း။
- ခလုတ်ကို မြန်မြန် နှိပ်ခြင်း (tap) နှင့် ဖိထားခြင်း (hold) အပေါ် မူတည်၍ Remap ပြုလုပ်ခြင်း (ဥပမာ Caps Lock ကို မြန်မြန် နှိပ်ပါက Esc ဖြစ်ပြီး ဖိထားပါက Ctrl ဖြစ်စေခြင်း)။

လေ့လာရန် Software အချို့ -
- macOS - [karabiner-elements](https://karabiner-elements.pqrs.org/), [skhd](https://github.com/koekeishiya/skhd) သို့မဟုတ် [BetterTouchTool](https://folivora.ai/)
- Linux - [xmodmap](https://wiki.archlinux.org/index.php/Xmodmap) သို့မဟုတ် [Autokey](https://github.com/autokey/autokey)
- Windows - Control Panel တွင် မူလပါရှိသည်၊ [AutoHotkey](https://www.autohotkey.com/) သို့မဟုတ် [SharpKeys](https://www.randyrants.com/category/sharpkeys/)
- QMK - ကီးဘုတ်က Custom firmware ကို ထောက်ပံ့ပါက [QMK](https://docs.qmk.fm/) ကို သုံး၍ Hardware ပေါ်တွင် တိုက်ရိုက် သတ်မှတ်နိုင်ပါသည်။

## Daemons

Daemons အယူအဆကို စာလုံးသစ် ဖြစ်နေသည့်တိုင် သတိပြုမိပေမည်။
ကွန်ပျူတာ အများစုတွင် User က စတင် ရန်းသည်ကို မစောင့်ဘဲ Background တွင် အမြဲတမ်း ရန်းနေသော Process အစဉ်လိုက်များ ရှိကြပါသည်။
ဤ Process များကို Daemons ဟု ခေါ်ဆိုပြီး ရန်းနေသော ပရိုဂရမ် အမည်များသည် အဆုံးတွင် `d` ဖြင့် ဆုံးလေ့ ရှိကြသည်။
ဥပမာ SSH daemon ဖြစ်သော `sshd` သည် SSH request များကို နားထောင်ပြီး Remote user တွင် လော့ဂ်အင် ဝင်ရန် Credentials ရှိမရှိ စစ်ဆေးပေးသော ပရိုဂရမ် ဖြစ်ပါသည်။

Linux တွင် `systemd` (system daemon) သည် Daemon process များကို စီမံရန် အသုံးအများဆုံး ဖြေရှင်းချက် ဖြစ်သည်။
ရန်းနေသော Daemon စာရင်းကို ကြည့်ရန် `systemctl status` ကို ရန်းနိုင်ပါသည်။
`systemctl` command ဖြင့် Service များကို `enable`, `disable`, `start`, `stop`, `restart` သို့မဟုတ် `status` စစ်ဆေးနိုင်ပါသည်။

`systemd` တွင် Daemon အသစ်များ ပြင်ဆင်သတ်မှတ်ရန် လွယ်ကူသော Interface ရှိပါသည်။ အောက်တွင် Python app အတွက် Daemon နမူနာ ဖြစ်ပါသည် -

```ini
# /etc/systemd/system/myapp.service
[Unit]
Description=My Custom App
After=network.target

[Service]
User=foo
Group=foo
WorkingDirectory=/home/foo/projects/mydaemon
ExecStart=/usr/bin/local/python3.7 app.py
Restart=on-failure

[Install]
WantedBy=multi-user.target
```

သီးခြား ကြိမ်နှုန်းဖြင့် ပရိုဂရမ် ရန်းလိုပါက Daemon အသစ် ဖန်တီးစရာ မလိုဘဲ စနစ်တွင် ပါဝင်ပြီးသား ဖြစ်သော [`cron`](https://www.man7.org/linux/man-pages/man8/cron.8.html) ကို သုံးနိုင်ပါသည်။

## FUSE

ခေတ်မီ Software စနစ်များကို အစိတ်အပိုင်း အသေးများဖြင့် ပေါင်းစပ် ဖွဲ့စည်းထားပါသည်။
သင်၏ Operating system တွင် Filesystem မတူညီသည်များကို သုံးနိုင်ခြင်းမှာ သုံးစွဲနိုင်သော Operation များအတွက် တူညီသော ဘာသာစကား ရှိသောကြောင့် ဖြစ်သည်။

[FUSE](https://en.wikipedia.org/wiki/Filesystem_in_Userspace) (Filesystem in User Space) သည် Filesystem များကို User program ဖြင့် အကောင်အထည်ဖော်ခွင့် ပြုပါသည်။
အလက်တွေ့တွင် User သည် စိတ်ကြိုက် လုပ်ဆောင်ချက်များကို Filesystem တွင် ရေးသားနိုင်ပါသည်။

FUSE Filesystem ၏ စိတ်ဝင်စားဖွယ် နမူနာများမှာ -
- [sshfs](https://github.com/libfuse/sshfs) - SSH မှတဆင့် Remote ဖိုင်များကို Local တွင် ဖွင့်ခြင်း။
- [rclone](https://rclone.org/commands/rclone_mount/) - Dropbox, GDrive, Amazon S3, Google Cloud Storage တို့ကို Local တွင် Mount လုပ်ခြင်း။
- [gocryptfs](https://nuetzlich.net/gocryptfs/) - Encrypted overlay system။
- [kbfs](https://keybase.io/docs/kbfs) - End-to-end encryption ပါသော Distributed filesystem။
- [borgbackup](https://borgbackup.readthedocs.io/en/stable/usage/mount.html) - Encrypted backup များကို လွယ်ကူစွာ ကြည့်နိုင်ရန် Mount လုပ်ခြင်း။

## Backups

Backup မလုပ်ထားသော Data မည်သည့်အရာမဆို မည်သည့်အချိန်မဆို ထာဝစဉ် ပျောက်ကွယ်သွားနိုင်ပါသည်။
Data ကူးယူရသည်မှာ လွယ်ကူသော်လည်း ယုံကြည်စိတ်ချရသော Backup ထားရှိရန် ခက်ခဲပါသည်။

ပထမဦးစွာ Disc တစ်ခုတည်းတွင် Copy ကူးထားခြင်းသည် Backup မဟုတ်ပါ၊ အကြောင်းမှာ Disc ပျက်စီးပါက Data အားလုံး ပျောက်ကွယ်နိုင်သောကြောင့် ဖြစ်သည်။ အလားတူ အပြင်ဘက် Disc ကို အိမ်တွင် ထားခြင်းသည်လည်း မီးလောင်ခြင်း/အခိုးခံရခြင်းတို့ ကြုံနိုင်သဖြင့် အိမ်ပြင်ပ (off-site) တွင် Backup ထားရှိရန် အကြံပြုပါသည်။

Sync လုပ်သော နည်းလမ်းများ (Dropbox/GDrive) သို့မဟုတ် Disc mirroring (RAID) တို့သည် Backup မဟုတ်ပါ။ Data ဖျက်မိပါက သို့မဟုတ် Ransomware ထိပါက Synchronize ဖြစ်သွားမည် ဖြစ်သည်။

ကောင်းမွန်သော Backup ၏ အဓိက အင်္ဂါရပ်များမှာ Versioning, Deduplication နှင့် Security တို့ ဖြစ်ကြသည်။
အသေးစိတ်အတွက် 2019 ခုနှစ်၏ [Backups သင်ခန်းစာ](/2019/backups) ကို ကြည့်ပါ။

## APIs

အွန်လိုင်းရှိ ဝဘ်ဆိုက်/Service အများစုတွင် ယင်းတို့၏ Data များကို ပရိုဂရမ် နည်းလမ်းဖြင့် ဝင်ရောက် ကြည့်ရှုနိုင်သော "APIs" များ ရှိကြပါသည်။

API အများစုသည် သပ်ရပ်သော URL ပုံစံ ရှိကြပြီး၊ အများအားဖြင့် `api.service.com` တွင် တည်ရှိကြပါသည်။ တုံ့ပြန်မှုများကို JSON ဖြင့် Format ပြုလုပ်ထားလေ့ရှိပြီး [`jq`](https://stedolan.github.io/jq/) ကဲ့သို့သော Tool ဖြင့် Parse ပြုလုပ်နိုင်ပါသည်။

အချို့သော API များသည် Authentication လိုအပ်ပြီး Secret _token_ ပါဝင်ရသည်။ "[OAuth](https://www.oauth.com/)" Protocol ကို အသုံးများပါသည်။

[IFTTT](https://ifttt.com/) သည် API များကို ဗဟိုပြုထားသော ဝဘ်ဆိုက် ဖြစ်ပြီး ဝဘ်ဆိုက်များစွာ၏ ဖြစ်ရပ်များကို ချိတ်ဆက်ပေးသည်။

## Common command-line flags/patterns

Command-line tool မျာတွင် အသုံးများသော Flag များမှာ -

 - `--help`: အတိုချုပ် ညွှန်ကြားချက်များ ပြရန်။
 - "dry run" flag: ပြောင်းလဲမည့် အရာများကို ရန်းမထားဘဲ ပြသပေးရန်။
 - `--version` သို့မဟုတ် `-V`: Version နံပါတ် ပြရန်။
 - `--verbose` သို့မဟုတ် `-v`: အသေးစိတ် Output များ ပြရန်။
 - `-`: File name နေရာတွင် standard input သို့မဟုတ် standard output အဖြစ် သတ်မှတ်ရန်။
 - `--`: Special argument ဖြစ်ပြီး ၎င်းနောက်မှ လာသော `-` ပါသော အရာများကို Flag အဖြစ် မသတ်မှတ်တော့ဘဲ မူလ Argument အဖြစ် သတ်မှတ်ပေးရန် (ဥပမာ `rm -- -r`)။

## Window managers

"floating" window manager များအပြင် အခြား အမျိုးအစားတစ်ခုမှာ "tiling" window manager ဖြစ်ပါသည်။ Tiling window manager တွင် Window များသည် တစ်ခုပေါ်တစ်ခု ထပ်မနေဘဲ Screen ပေါ်တွင် Tiles များအဖြစ် စီတန်းနေမည် ဖြစ်သည်။

## VPNs

VPN သည် သင်၏ ISP အစား VPN Provider ထံသို့ ယုံကြည်မှုကို ပြောင်းလဲလိုက်ခြင်း ဖြစ်ပါသည်။ အကျိုးကျေးဇူး ရှိမရှိ သေချာစွာ စိစစ်ပါ။ အသုံးများသော WireGuard အတွက် [WireGuard](https://www.wireguard.com/) ကို ကြည့်ပါ၊ MIT ကျောင်းသားများအတွက် [MIT VPN](https://ist.mit.edu/vpn) ရှိသည်။

## Markdown

[Markdown](https://commonmark.org/help/) သည် ရိုးရှင်းသော စာသားများ ရေးသားရန်အတွက် Lightweight markup language ဖြစ်ပါသည်။
- `*italic*`
- `**bold**`
- `# Heading`
- `- list item`
- `` `code` ``
- `[name](url)`

ဤသင်ခန်းစာ Document များ အားလုံးကို Markdown ဖြင့် ရေးသားထားခြင်း ဖြစ်သည်။

## Hammerspoon (desktop automation on macOS)

[Hammerspoon](https://www.hammerspoon.org/) သည် macOS အတွက် Desktop automation framework ဖြစ်ပါသည်။ Lua script များ ရေးသား၍ စနစ်ကို စီမံနိုင်ပါသည်။

## Booting + Live USBs

[BIOS](https://en.wikipedia.org/wiki/BIOS)/[UEFI](https://en.wikipedia.org/wiki/Unified_Extensible_Firmware_Interface) သည် ကွန်ပျူတာ စတင်ချိန်တွင် စနစ်ကို စတင်ပေးသည်။ Boot Menu မှတဆင့် Alternate device မှ Boot တက်နိုင်သည်။

[Live USBs](https://en.wikipedia.org/wiki/Live_USB) တွင် Operating system ပါရှိပြီး၊ [UNetbootin](https://unetbootin.github.io/) ကဲ့သို့သော Tool ဖြင့် ဖန်တီးနိုင်သည်။

## Docker, Vagrant, VMs, Cloud, OpenStack

[Virtual machines](https://en.wikipedia.org/wiki/Virtual_machine) နှင့် Containers များသည် စနစ်တစ်ခုလုံးကို အတုယူ ဖန်တီးပေးသည်။ [Vagrant](https://www.vagrantup.com/)၊ [Docker](https://www.docker.com/)၊ Cloud Provider များ ([AWS](https://aws.amazon.com/), [Google Cloud](https://cloud.google.com/), [Azure](https://azure.microsoft.com/), [DigitalOcean](https://www.digitalocean.com/))။

MIT CSAIL ကျောင်းသားများအတွက် [CSAIL OpenStack](https://tig.csail.mit.edu/shared-computing/open-stack/) တွင် အခမဲ့ သုံးနိုင်သည်။

## Notebook programming

[Jupyter](https://jupyter.org/) (Python) သို့မဟုတ် [Wolfram Mathematica](https://www.wolfram.com/mathematica/) တို့သည် Notebook programming အတွက် အသုံးများပါသည်။

## GitHub

[GitHub](https://github.com/) တွင် Open-source ပရောဂျက်များစွာ ရှိသည်။
- Issue တင်ခြင်း
- Pull request တင်ခြင်း
