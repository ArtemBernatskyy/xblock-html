.PHONY: help \

.DEFAULT_GOAL := help


help: ## Display this help message
	@echo "Please use \`make <target>' where <target> is one of"
	@perl -nle'print $& if m{^[a-zA-Z_-]+:.*?## .*$$}' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m  %-25s\033[0m %s\n", $$1, $$2}'

clean: ## Remove generated byte code, coverage reports, and build artifacts
	find . -name '__pycache__' -exec rm -rf {} +
	find . -name '*.pyc' -exec rm -f {} +
	find . -name '*.pyo' -exec rm -f {} +
	find . -name '*~' -exec rm -f {} +
	coverage erase
	rm -fr build/
	rm -fr dist/
	rm -fr *.egg-info

diff_cover: test ## find diff lines that need test coverage
	diff-cover coverage.xml

selfcheck: ## check that the Makefile is well-formed
	@echo "The Makefile is well-formed."

requirements:
	pip install -q -r requirements.txt --exists-action w
	pip install -e .
	@echo "Finished installing requirements."

quality:
	pep8 html_xblock --max-line-length=120
	pylint html_xblock

test: quality ## Run tests in the current virtualenv
