<?xml version="1.0" ?>
<testsuites name="Vulnerability Scanning">
{{- range . -}}
{{- $vulnFailures := len .Vulnerabilities }}
{{- $misconfigFailures := len .Misconfigurations}}
{{- if not (contains "/bin/Debug" .Target)}}
    <testsuite tests="{{ add $vulnFailures $misconfigFailures }}" failures="{{ add $vulnFailures $misconfigFailures }}" name="{{  .Target }}" errors="0" skipped="0" time="">
    {{- if not (eq .Type "") }}
        <properties>
            <property name="type" value="{{ escapeXML .Type }}"></property>
        </properties>
    {{- end -}}
    {{ range .Vulnerabilities }}
        <testcase classname="{{ escapeXML .PkgName }}" name="[{{ .Vulnerability.Severity }}] {{ .VulnerabilityID }}" time="">
            <failure message="{{ escapeXML .Title }}" type="description">{{ escapeXML .Description }}</failure>
{{/* This is rendered in a <pre>-tag, which will include indentation */}}
            <system-err>
{{ escapeXML .Description }}
Installed version: {{ escapeXML .InstalledVersion }}
{{- if .FixedVersion }}
Fixed version: {{ escapeXML .FixedVersion }}
{{- end }}
{{- range .Vulnerability.References }}
{{ escapeXML . }}
{{- end }}
            </system-err>
        </testcase>
    {{- end }}
    {{- range .Misconfigurations }}
        <testcase classname="{{ .ID }}" name="[{{ .Severity }}] {{ .ID }}" time="">
            <failure message="{{ escapeXML .Title }}">{{ escapeXML .Message }}</failure>
            <system-err>
{{ escapeXML .Message }}
{{ escapeXML .PrimaryURL }}
            </system-err>
        </testcase>
    {{- end }}
    </testsuite>
{{- end }}
{{- end }}
</testsuites>