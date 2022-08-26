PYENV := ./env
PYTHON := $(PYENV)/bin/python

PIP := $(PYENV)/bin/pip
PIP_FLAGS := --quiet --no-cache-dir

FABRIC := $(PYENV)/bin/fab
FABRIC_FLAGS := -H 10.0.0.18
FABRIC_SUDO := ./.sudo-password

.PHONY: all
all: run

.PHONY: run
run: $(FABRIC)
	@echo "==> running fabfile"
	$(FABRIC) apply $(FABRIC_FLAGS)


$(FABRIC): $(PIP) $(FABRIC_SUDO)
	@echo "==> installing fabric"
	$(PIP) install $(PIP_FLAGS) fabric

$(FABRIC_SUDO):
	@echo "==> seeding sudo password"
	pass sudo > $@
	chmod 700 $@

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
	rm -f $(FABRIC_SUDO)
