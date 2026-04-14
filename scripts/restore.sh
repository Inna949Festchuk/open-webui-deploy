#!/bin/bash
# Полное восстановление Open WebUI из архива
# Не забудьте сделать скрипты исполняемыми: chmod +x scripts/*.sh

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE} Восстановление полной резервной копии Open WebUI...${NC}"

# Ищем последний архив в папке backups
ARCHIVE=$(ls -t ./backups/*.tar.gz 2>/dev/null | head -n1)

# Если архива нет в backups, ищем в корне
if [ -z "$ARCHIVE" ] && [ -f ./open-webui-full.tar.gz ]; then
    ARCHIVE="./open-webui-full.tar.gz"
fi

if [ -z "$ARCHIVE" ]; then
    echo -e "${RED} Архив не найден!${NC}"
    echo -e "${YELLOW} Поместите архив .tar.gz в папку backups/ или в корень проекта.${NC}"
    echo -e "   Или запустите: $0 /путь/к/бэкапу.tar.gz"
    exit 1
fi

echo -e "${GREEN} Найден архив: ${ARCHIVE}${NC}"

# Создаём папку data
mkdir -p ./data

# Очищаем папку data перед восстановлением (с подтверждением)
if [ "$(ls -A ./data 2>/dev/null)" ]; then
    echo -e "${YELLOW}  Папка ./data не пуста.${NC}"
    read -p "Очистить папку перед восстановлением? [y/N] " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        rm -rf ./data/*
        echo -e "${YELLOW} Папка ./data очищена.${NC}"
    fi
fi

# Распаковываем архив
echo -e "${YELLOW} Распаковка данных...${NC}"
tar xzf "$ARCHIVE" -C ./data/

# Устанавливаем правильные права (для Linux/macOS)
if [[ "$OSTYPE" == "linux-gnu"* ]] || [[ "$OSTYPE" == "darwin"* ]]; then
    chmod -R 755 ./data/
    echo -e "${GREEN} Права доступа установлены${NC}"
fi

echo -e "${GREEN} Данные восстановлены в ./data/${NC}"
echo -e "${BLUE} Запуск Open WebUI...${NC}"

docker-compose up -d

echo -e "${GREEN} Open WebUI запущен! Доступен по адресу: http://localhost:3000${NC}"