.PHONY: up down logs backup restore clean

up:     ## Запустить сервис
	docker-compose up -d
	@echo " Open WebUI запущен: http://localhost:3000"

down:   ## Остановить сервис
	docker-compose down

logs:   ## Показать логи
	docker-compose logs -f

backup: ## Создать полный бэкап (архив .tar.gz)
	@./scripts/backup.sh

restore: ## Восстановить из последнего бэкапа и запустить
	@./scripts/restore.sh

clean:  ## Очистить все данные (ТРЕБУЕТ ПОДТВЕРЖДЕНИЯ)
	@echo "  ВНИМАНИЕ: Это удалит ВСЕ данные Open WebUI!"
	@read -p "Вы уверены? [y/N] " -n 1 -r; \
	echo ""; \
	if [[ $$REPLY =~ ^[Yy]$$ ]]; then \
		docker-compose down -v 2>/dev/null || true; \
		rm -rf ./data/*; \
		echo " Данные удалены"; \
	else \
		echo " Операция отменена"; \
	fi