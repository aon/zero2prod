check:
	@echo "Running multiple checks..."
	@echo
	@make format
	@echo
	@make lint
	@echo
	@make test

format:
	@echo "Formatting..."
	cargo fmt --all

lint:
	@echo "Linting..."
	cargo clippy --all-targets --all-features -- -D warnings

test:
	@echo "Testing..."
	cargo test --all
