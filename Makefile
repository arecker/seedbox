PYENV := ./env
PYTHON := $(PYENV)/bin/python

PIP := $(PYENV)/bin/pip
PIP_FLAGS := --quiet --no-cache-dir

FABRIC := $(PYENV)/bin/fab
FABRIC_FLAGS := -H 10.0.0.18

SECRETS = $(addprefix secrets/, sudo pia)

.PHONY: all
all: $(SECRETS) $(FABRIC) run

secrets/%:
	@echo "==> seeding secret $*"
	pass $* > $@

.PHONY: run
run: $(FABRIC)
	@echo "==> running fabfile"
	$(FABRIC) apply $(FABRIC_FLAGS)

$(FABRIC): $(PIP) $(FABRIC_SUDO)
	@echo "==> installing fabric"
	$(PIP) install $(PIP_FLAGS) fabric

$(PIP): $(PYTHON)
	@echo "==> upgrading pip"
	$@ install $(PIP_FLAGS) --upgrade pip

$(PYTHON):
	@echo "==> creating python environment"
	python -m venv $(PYENV)

.PHONY: clean
clean:
	@echo "==> cleaning project"
	rm -rf $(PYENV)
	rm -f $(SECRETS)
