lsblk - для просмотра и нахождения названия вставленного диска
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
