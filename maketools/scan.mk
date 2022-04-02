TRIVY.cachedir := $(BUILD.dir)/.trivycache
TRIVY.version := "0.23.0"
TRIVY.cmd := docker run --rm --user $$(id -u):$$(id -g) -e TRIVY_CACHE_DIR=$(TRIVY.cachedir) -v $(ROOT.dir):$(ROOT.dir) aquasec/trivy:$(TRIVY.version)
TRIVY.args = -f template -t "@$(ROOT.dir)/junit.xml.tpl" --exit-code 1 --ignorefile $(ROOT.dir)/.trivyignore
DIRECTORIES += $(TRIVY.cachedir)

.PHONY check: scan

.PHONY scan: dependency-scan dockerfile-scan

dependency-scan: | $(REPORTS.dir) $(TRIVY.cachedir)
	$(Q)$(TRIVY.cmd) fs $(TRIVY.args) -o $(REPORTS.dir)/dependency-scan-junit.xml $(ROOT.dir)

dockerfile-scan: | $(REPORTS.dir) $(TRIVY.cachedir)
	$(Q)$(TRIVY.cmd) config $(TRIVY.args) -o $(REPORTS.dir)/dockerfile-scan-junit.xml  $(ROOT.dir)
