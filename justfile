default:
    just --list

format:
    uv run ruff format src/ tests/
    uv run ruff check --select I --fix src/ tests/

lint:
    uv run ruff check src/ tests/
    uv run mypy src/ --ignore-missing-imports

test:
    uv run pytest tests/ -v --cov=src/scholarimpact --cov-report=term-missing

install:
    uv sync

clean:
    rm -rf build/ dist/ *.egg-info src/*.egg-info
    find . -type d -name __pycache__ -exec rm -rf {} + 2>/dev/null || true
    find . -type f -name "*.pyc" -o -name "*.pyo" -o -name ".coverage" | xargs rm -f 2>/dev/null || true
    find . -type d -name ".pytest_cache" -o -name ".mypy_cache" -o -name ".ruff_cache" | xargs rm -rf 2>/dev/null || true

build: clean
    uv build

publish: build
    uv publish

check: format lint test
