#!/bin/bash

# Установка пакетов необходимых для настройки репозитория Docker
sudo dnf -y install dnf-plugins-core

# Добавление репозитория Docker в список репозиториев DNF
sudo dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo

# Установка пакетов Docker и Docker Compose
sudo dnf install -y docker-ce docker-ce-cli containerd.io docker-compose

# Создание группы "docker" и добавление текущего пользователя в эту группу
sudo groupadd docker
sudo usermod -a -G docker $USER

echo '!-----! Need to logout or reboot system !-----!'

# Перезапуск сессии текущего пользователя, чтобы изменения в группах пользователя вступили в силу
newgrp docker

#Создает каталог докер
mkdir ~/.docker
sudo mkdir /root/.docker
sudo chown root:root /root/.docker

# Включение автозапуска сервисов Docker и Containerd
sudo systemctl enable docker.service
sudo systemctl enable containerd.service

# Запуск сервиса Docker
sudo systemctl start docker

# Запуск тестового контейнера
docker run hello-world

echo 'Docker installed and started successfully!!'




