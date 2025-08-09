
<p align="center">Ubuntu in termux source (wahasa) modified by alxzy</br><b>
---
## Ubuntu on Termux Android

---
• Install Apps on Android
- [x] [Termux](https://play.google.com/store/apps/details?id=com.termux)
- [x] [Vnc Viewer](https://play.google.com/store/apps/details?id=com.realvnc.viewer.android)

## Installation

Copy and paste this command to Termux :
> pkg update

<details><summary><b><code>Install Ubuntu</code></b></summary>

#### Ubuntu 24.10 (Pre-release)
Rootfs : Armhf, Arm64, Amd64
```
pkg install wget -y ; wget https://raw.githubusercontent.com/alands-offc/Ubuntu/main/Install/ubuntu24.10.sh ; chmod +x ubuntu24.10.sh ; ./ubuntu24.10.sh
```

#### Ubuntu 24.04 (Noble Numbat)
Rootfs : Armhf, Arm64, Amd64
```
pkg install wget -y ; wget https://raw.githubusercontent.com/alands-offc/Ubuntu/main/Install/ubuntu24.04.sh ; chmod +x ubuntu24.04.sh ; ./ubuntu24.04.sh
```

#### List Ubuntu | [Click Hare >](https://github.com/alands-offc/Ubuntu/tree/main/Install)
</details>

---
* Start Ubuntu
```
ubuntu
```

* Stop Ubuntu
```
exit
```

* Remove Ubuntu
```
rm -rf ubuntu-fs .ubuntu $PREFIX/bin/ubuntu
```

---
Basic commands Ubuntu
> apt update : Update list package.</br>
> apt upgrade : Upgrade package.</br>
> apt search (pkg) : Search package.</br>
> apt install (pkg) : Install package.</br>
> apt autoremove (pkg) : Delete package.</br>
> apt -h : Help all commands.

---
## Desktop Environment

In Ubuntu, run this command :
> apt update ; apt upgrade

<details></br>
<summary><b><code>Install Desktop Xfce</code></b></summary>

</details>

---
Feature
- [x] Fixed Sound
- [x] Access to Sdcard
- [x] Fixed Browser Crash
- [x] Install Applications | [Click Here >](https://github.com/alands-offc/Ubuntu/tree/main/Apps)

Visit problems now in : [Issues](https://github.com/alands-offc/Ubuntu/issues)

---
## VNC Viewer

* Start VNC Server

In Ubuntu, run this command to start :
```
vnc-start
```

* Open Vnc Viewer

Add (+) VNC Client to connect, fill with :

Address
```
localhost:1
```

Name
```
Ubuntu Desktop
```

To disconnect VNC Client, click (X) on the right.

* Stop VNC Server

In Ubuntu, run this command to stop :
```
vnc-stop
```
</br>

---
<p align="center">Good Luck</p>

---
