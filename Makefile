PREFIX ?= $(HOME)/.local
BIN_DIR := $(PREFIX)/bin
BIN := $(BIN_DIR)/curpop
SRC := curpop.swift

.PHONY: all build install uninstall clean run

all: build

build: curpop

curpop: $(SRC)
	swiftc -O $(SRC) -o curpop

install: build
	install -d $(BIN_DIR)
	install -m 0755 curpop $(BIN)
	@echo "Installed: $(BIN)"

uninstall:
	rm -f $(BIN)

run: build
	./curpop

clean:
	rm -f curpop
