Kanat lsblk - для просмотра и нахождения названия вставленного диска
sudo mkfs.ext4 /dev/sdb
sudo mkdir -p /mnt/data
sudo mount /dev/sdb /mnt/data - временно монтируем для проверки
sudo blkid - для просмотра UID
sudo blkid | sed -n '4p' - для просмотра , что именно та строка с необходимым UID
sudo blkid | sed -n '4p' | sudo tee -a /etc/fstab - добавление в конец файла
sudo vim /etc/fstab - для окончательного редактирования к виду:
UUID=123e4567-e89b-12d3-a456-426614174000 /mnt/data ext4 defaults 0 2
sudo mount -a - проверка что норм


sudo apt update 
sudo apt install samba

для проверки создаем временную директорию
sudo mkdir -p /mnt/data/shared
sudo chown -R nobody:nogroup /mnt/data/shared - рекурсивно на все подпапки владельца
sudo chmod -R 0777 /mnt/data/shared
sudo nano /etc/samba/smb.conf
добавляем:
path = /mnt/data/shared
browseable = yes
read only = no
guest ok = yes
sudo systemctl restart smbd
sudo systemctl enable smbd

С windows машины проверяем 
\\YOUR_IP\Shared

для работы по пользователям
sudo chown -R root:storage /mnt/data/shared
sudo chmod -R 2770 /mnt/data/shared
создаем пользователей в Linux:
sudo adduser aizhan
sudo adduser ashat
создаем группу storage
sudo groupadd storage
sudo usermod -aG storage aizhan
sudo usermod -aG storage ashat
sudo groups ashat
sudo groups aizhan
создаем пользователей в samba:
sudo smbpasswd -a ashat
sudo smbpasswd -a aizhan
sudo pdbedit -L

sudo systemctl restart smbd
sudo smbclient //localhost/shared -U aizhan
sudo -u aizhan touch /mnt/data/shared/test_file
sudo tail -f /var/log/samba/log.smbd
sudo nano /etc/samba/smb.conf
добавить строки:
[global]
workgroup = WQRKGROUP
security = user
ntlm auth = yes
server min protocol = SMB2
server max protocol = SMB3

map to guest = never
usershare allow guests = yes
[Shared]
path = /mnt/data/shared
browseable = yes
writable = yes
valid users = @storage
create mask = 0660
directory mask = 2770
read only = no
guest ok = no


На windows в cmd
net use * /delete
net use Z: \\192.168.40.1\shared /user:192.168.40.1\aizhan Q88kU267 /persistent:yes
