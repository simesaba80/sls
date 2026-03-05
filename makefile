COMMAND_NAME = sls

.PHONY: release
release:
	docker compose up
	sudo cp .build/release/sls /usr/local/bin/sls
