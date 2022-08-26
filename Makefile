PYENV := ./env
PYTHON := $(PYENV)/bin/python

PIP := $(PYENV)/bin/pip
PIP_FLAGS := --quiet --no-cache-dir

FABRIC := $(PYENV)/bin/fab
FABRIC_FLAGS := -H 10.0.0.18

.PHONY: all
all: $(FABRIC) run

$(FABRIC): $(PIP)
	@echo "==> installing fabric"
	$(PIP) install $(PIP_FLAGS) fabric

$(PIP): $(PYTHON)
	@echo "==> upgrading pip"
	$(PIP) install $(PIP_FLAGS) --upgrade pip

$(PYTHON):
	@echo "==> creating python environment"
	python -m venv $(PYENV)

.PHONY: clean
clean:
	@echo "==> cleaning project"
	rm -rf $(PYENV)

.PHONY: run
run:
	@echo "==> running fabfile"
	$(FABRIC) $(FABRIC_FLAGS) apply
