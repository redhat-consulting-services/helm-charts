{{/*
Expand the name of the chart.
*/}}
{{- define "tenant-namespaces.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
*/}}
{{- define "tenant-namespaces.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "tenant-namespaces.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "tenant-namespaces.labels" -}}
helm.sh/chart: {{ include "tenant-namespaces.chart" . }}
{{ include "tenant-namespaces.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Custom labels for OpenShift monitoring
*/}}
{{ define "tenant-namespaces.custom-labels" }}
{{- if .features.enableUserMonitoring }}
openshift.io/user-monitoring: "true"
{{- end }}
{{- .labels | toYaml | nindent 0 }}
{{- end }}

{{/*
Custom annotations for OVN Audit logging
*/}}
{{ define "tenant-namespaces.custom-annotations" }}
{{- if .features.enableNetpolAuditLogging }}
k8s.ovn.org/acl-logging: |-
  {
    "deny": "info",
    "allow": "info"
  }
{{- end }}
{{- with .annotations }}
{{- . | toYaml | nindent 0 }}
{{- end }}
{{- end }}
