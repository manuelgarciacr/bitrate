# 🛠️ tpm installation

1. ### Copy the plugin inside the tmux2k plugins folder
```bash
wget -nH -O ~/.tmux/plugins/tmux2k/plugins/bitrate.sh https://raw.githubusercontent.com/manuelgarciacr/bitrate/refs/heads/main/bitrate.sh
```
2. ### Add permissions
```bash
chmod u+x ~/.tmux/plugins/tmux2k/plugins/bitrate.sh
```
3. ### Update .tmux.conf with the desired configuration

    ### 📑 .tmux.conf
```bash
# ...

# tmux2k
set -g @tmux2k-bandwidth-network-name "eno1"
set -g @tmux2k-right-plugins "bandwidth"
set -g @tmux2k-left-plugins "network bitrate"            # bitrate plugin
set -g @tmux2k-bitrate-colors "light_orange black"       # bitrate color. You can also change directly by editing the main.sh file of the tmux2k plugin
set -g @tmux2k-bitrate-devices "eno1 wlp3s0 unknown"     # If not set, all devices with data are shown. Otherwise, only configured devices with data are shown
# set -g @tmux2k-bitrate-ethernet-icon                  # ethernet icon. Default 󰈀
# set -g @tmux2k-bitrate-wifi-icon 󰖩                     # wifi icon. Default 
# set -g @tmux2k-bitrate-essid true                      # If true, the ESSID is displayed
# set -g @tmux2k-bitrate-no-names true                   # If true, the names are not displayed
set -g @plugin '2kabhishek/tmux2k'

# ...
```
4. ### Refresh the configuration with tmux source ~/.tmux.conf

