#!/bin/bash
# Полное резервное копирование Open WebUI (включая uploads, cache, vector_db)
# Не забудьте сделать скрипты исполняемыми: chmod +x scripts/*.sh

set -e

BACKUP_DIR="./backups"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP_NAME="open-webui-full-${TIMESTAMP}"

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${YELLOW}🔄 Создание полной резервной копии Open WebUI...${NC}"

mkdir -p "${BACKUP_DIR}"

# Проверяем, существует ли том open-webui
if ! docker volume inspect open-webui >/dev/null 2>&1; then
    echo -e "${RED} Том open-webui не найден!${NC}"
    echo -e "${YELLOW} Сначала запустите Open WebUI для создания тома.${NC}"
    exit 1
fi

# Создаём архив всего содержимого тома
docker run --rm \
    -v open-webui:/volume:ro \
    -v "$(pwd)/${BACKUP_DIR}":/backup \
    alpine \
    tar czf "/backup/${BACKUP_NAME}.tar.gz" -C /volume .

echo -e "${GREEN} Полный бэкап создан: ${BACKUP_DIR}/${BACKUP_NAME}.tar.gz${NC}"
echo -e "${GREEN} Размер архива: $(du -h ${BACKUP_DIR}/${BACKUP_NAME}.tar.gz | cut -f1)${NC}"