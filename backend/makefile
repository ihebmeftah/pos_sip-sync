reset:
	docker compose down -v
	docker compose up --build --detach
	npm run start:dev

mig-g-tenant:
	@echo "Generating new tenant migration..."
	@mkdir -p migrations/tenant
	@NEXT_VERSION=$$(ls -d migrations/tenant/v* 2>/dev/null | sed 's/.*v//' | sort -n | tail -1 | awk '{print $$1+1}'); \
	if [ -z "$$NEXT_VERSION" ]; then NEXT_VERSION=1; fi; \
	echo "Next tenant version: v$$NEXT_VERSION"; \
	npm run migration:generate:tenant -- migrations/tenant/tenant_v$$NEXT_VERSION -- $(dbname); \
	echo "Tenant migration file created successfully at migrations/tenant/tenant_v$$NEXT_VERSION"

mig-r-tenant:
	npm run migration:run:tenant $(if $(dbname),$(dbname),all)

mig-g:
	@echo "Generating new migration..."
	@mkdir -p migrations
	@NEXT_VERSION=$$(ls -d migrations/v* 2>/dev/null | sed 's/.*v//' | sort -n | tail -1 | awk '{print $$1+1}'); \
	if [ -z "$$NEXT_VERSION" ]; then NEXT_VERSION=1; fi; \
	echo "Next version: v$$NEXT_VERSION"; \
	npm run migration:generate -- migrations/v$$NEXT_VERSION; \
	echo "Migration file created successfully at migrations/v$$NEXT_VERSION"

mig-r:
	npm run migration:run
