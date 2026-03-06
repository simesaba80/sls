COMMAND_NAME = sls

.PHONY: releaselinux
releaselinux:
	docker compose up -d
	sudo cp .build/release/sls /usr/local/bin/sls

.PHONY: release
release:
	swift build -c release
	sudo cp .build/release/sls /usr/local/bin/sls
