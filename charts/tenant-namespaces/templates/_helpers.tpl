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

Custom labels for OpenShift monitoring

*/}}

{{/*
Selector labels
*/}}
{{- define "tenant-namespaces.selectorLabels" -}}
app.kubernetes.io/name: {{ include "tenant-namespaces.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "tenant-namespaces.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "tenant-namespaces.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Check if a feature is enabled, handling the "false" boolean trap.
Returns "true" (string) if enabled, or empty string if disabled.
Usage: {{ include "tenant-namespaces.isEnabled" (dict "context" $namespaceCtx "key" "featureKey" "default" $globalDefault) }}
*/}}
{{- define "tenant-namespaces.isEnabled" -}}
{{- $result := .default -}}
{{- if hasKey .context .key -}}
  {{- $result = get .context .key -}}
{{- end -}}
{{- if $result -}}
true
{{- end -}}
{{- end -}}








{{/*
Custom labels for OpenShift monitoring
*/}}
{{ define "tenant-namespaces.custom-labels" }}
{{- if .enableUserMonitoring }}
openshift.io/user-monitoring: "true"
{{- end }}
{{- range $k, $v := .labels }}
{{ $k }}: {{ $v }}
{{- end }}
{{- end }}

{{/*
Custom annotations for OVN Audit logging
*/}}
{{ define "tenant-namespaces.custom-annotations" }}
{{- if .enableNetpolAuditLogging }}
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
