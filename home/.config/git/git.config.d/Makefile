# usage: make [m="commit message"]

TARGET := manifest.config
ROOT := $(abspath $(CURDIR))
RELROOT := $(shell basename $(ROOT))
CONFIG_TREE := $(shell find $(RELROOT) -name \*.config -type f)
BANNER := Rebuilding manifest.config with $(ROOT)/$(MAKE)
# usage: make [m="commit message"] 
m = $(BANNER)

# make -B will force a build
$(TARGET) : $(CONFIG_TREE)
	test -f $@ || mv --backup=numbered --update $@ attic/ || true	
	git status || git init
	git add .
	git commit -m "$(m)"
	echo "# $(BANNER) on $$(date)\n[$$USERNAME.$@]\n    generated = '$$(date)'\n    [$$USERNAME.$@.$(RELROOT)]\n        path = '$(ROOT)/$@'\n\n[include]" > $(TARGET)
	for p in $(CONFIG_TREE); do echo "    path = $${p}"; done >> $(TARGET)
	echo "\n# eof" >> $(TARGET)


# TODO <mike@carif.io>: make -d and make -p -f/dev/null don't actually print vars below? Must be a way.
.PHONY: show
show:
	@echo "TARGET: $(TARGET)"
	@echo "ROOT: $(ROOT)"
	@echo "RELROOT: $(RELROOT)"
	@echo "CONFIG_TREE: $(CONFIG_TREE)"
	@echo "BANNER: $(BANNER)"
