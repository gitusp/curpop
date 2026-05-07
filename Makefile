PREFIX ?= $(HOME)/.local
BIN_DIR := $(PREFIX)/bin
BIN := $(BIN_DIR)/highlight
SRC := highlight.swift

KARABINER_DIR := $(HOME)/.config/karabiner/assets/complex_modifications
KARABINER_SRC := karabiner/cursor-highlight.json
KARABINER_DST := $(KARABINER_DIR)/cursor-highlight.json

.PHONY: all build install install-karabiner install-all uninstall clean run

all: build

build: highlight

highlight: $(SRC)
	swiftc -O $(SRC) -o highlight

install: build
	install -d $(BIN_DIR)
	install -m 0755 highlight $(BIN)
	@echo "Installed: $(BIN)"

install-karabiner:
	install -d $(KARABINER_DIR)
	sed 's|~/.local/bin/highlight|$(BIN)|g' $(KARABINER_SRC) > $(KARABINER_DST)
	chmod 0644 $(KARABINER_DST)
	@echo "Installed: $(KARABINER_DST) (shell_command -> $(BIN))"
	@echo "Open Karabiner-Elements -> Complex Modifications -> Add rule to enable."

install-all: install install-karabiner

uninstall:
	rm -f $(BIN)
	rm -f $(KARABINER_DST)

run: build
	./highlight

clean:
	rm -f highlight
