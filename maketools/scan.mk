TRIVY.cachedir := $(BUILD.dir)/.trivycache
TRIVY.version := "0.23.0"
TRIVY.cmd := docker run --rm --user $$(id -u):$$(id -g) -e TRIVY_CACHE_DIR=$(TRIVY.cachedir) -v $(ROOT.dir):$(ROOT.dir) aquasec/trivy:$(TRIVY.version)
TRIVY.args = -f table -f template -t "@$(ROOT.dir)/junit.xml.tpl" --exit-code 1 --ignorefile $(ROOT.dir)/.trivyignore
DIRECTORIES += $(TRIVY.cachedir)

.PHONY check: scan

.PHONY scan: dependency-scan dockerfile-scan

.PHONY dependency-scan: $(REPORTS.dir)/dependency-scan-junit.xml

$(REPORTS.dir)/dependency-scan-junit.xml: | $(REPORTS.dir) $(TRIVY.cachedir)
	$(Q)$(TRIVY.cmd) fs $(TRIVY.args) -o "$(@)" "$(ROOT.dir)" \
		|| { cat "$(@)" && exit 1; }

.PHONY dockerfile-scan: $(REPORTS.dir)/dockerfile-scan-junit.xml
$(REPORTS.dir)/dockerfile-scan-junit.xml: | $(REPORTS.dir) $(TRIVY.cachedir)
	$(Q)$(TRIVY.cmd) config $(TRIVY.args) -o "$(@)" $(ROOT.dir) \
		|| { cat "$(@)" && exit 1; }
