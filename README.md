`ssh-inhibit-sleep` pevents your Ubuntu + GNOME workstation from automatically suspending when you have active SSH connections.  It's a small utility that keeps your system awake *only* while you're actively using it remotely via SSH.  When no SSH connections are present, the standard GNOME power management settings (including auto-suspend) will function as normal.  This ensures your workstation is available when you need it remotely, but still saves power when idle.

# Installation

To install, clone the repository and run `make`:

```bash
git clone [https://github.com/sinkap/ssh-inhibit-sleep](https://github.com/sinkap/ssh-inhibit-sleep)
cd ssh-inhibit-sleep
sudo make install
```