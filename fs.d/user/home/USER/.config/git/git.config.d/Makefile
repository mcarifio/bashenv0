i = $(info $(1): $($(1)))
_here := $(realpath $(dir $(lastword $(MAKEFILE_LIST))))
# $(call i,_here)
_suffix := $(notdir $(_here))
# $(call i,_suffix)
RTARGET=manifest.config
# $(call i,RTARGET)
TARGET := $(_here)/$(RTARGET)
# $(call i,TARGET)
ROOT := $(_here)
# $(call i,ROOT)
CONFIG_TREE := $(shell find $(_here)/$(_suffix) -name \*.config -type f)
# $(call i,CONFIG_TREE)
RCONFIG_TREE := $(shell find $(_here)/$(_suffix) -name \*.config -type f -exec realpath --relative-to=$(_here) {} \; )
# $(call i,RCONFIG_TREE)
BANNER := Rebuilding manifest.config with $(ROOT)/$(lastword $(MAKEFILE_LIST))
# $(call i,BANNER)

# make -B -f /path/to/Makefile will force a build
# set with git config --list [--show-origin]
$(TARGET) : $(CONFIG_TREE)
	test -f $@ && mkdir -p $(@D) && mv --backup=numbered --update $@ $(@D)/.attic || true	
	printf "# $(BANNER) on $$(date -I)\n[$$USER.$(@F)]\n    generated = $$(date)\n    abspath = $@\n\n[include]\n" > $(TARGET)
	printf "    path = %s\n" $(RCONFIG_TREE) >> $(TARGET)
	printf "\n# eof\n" >> $(TARGET)


