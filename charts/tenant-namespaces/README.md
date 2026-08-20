# tenant-namespaces

![Version: 1.2.0](https://img.shields.io/badge/Version-1.2.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 1.2.0](https://img.shields.io/badge/AppVersion-1.2.0-informational?style=flat-square)

A multi-tenant onboarding chart that automates namespace creation, resource governance, and Argo CD project delegation for development teams

## Prerequisites

* This chart expects that a clusterwide ArgoCD instance is already installed and configured in the cluster.
* It also expects that a dedicated developer ArgoCD instance is available for the tenant teams to use.
* The chart has been developed with BANP & ANP (BaselineAdminNetworkPolicies & AdminNetworkPolicies) in mind, but can be used without it as well.

## Defining Namespaces for a Tenant

This section defines the array of namespaces to be provisioned for a single tenant. The settings will override the global defaults.

```yaml
---
defaults:
  namespace:
    labels:
      ns.openshift.io/owner: "tenant-team"
    features:
      enableNetpolAuditLogging: true
      enableUserMonitoring: true
      enableCertificateConfigMap: true
      enableServiceCaCertificateConfigMap: true
      enableArgocdRBAC: true

  limitRange:
    enabled: true
    name: default
    container:
      enabled: true
      values:
        max:
          cpu: "4"
          memory: 4Gi
        min:
          cpu: 10m
          memory: 10Mi
        default:
          cpu: 500m
          memory: 1Gi
        defaultRequest:
          cpu: 30m
          memory: 200Mi
    pod:
      enabled: true
      values:
        max:
          cpu: "2"
          memory: "1Gi"
        min:
          cpu: "200m"
          memory: "6Mi"
    pvc:
      enabled: true
      values:
        max:
          storage: 10Gi
        min:
          storage: 1Gi

  resourceQuota:
    enabled: true
    compute:
      enabled: true
      name: compute-resources
      values:
        requests.cpu: "10"
        requests.memory: 20Gi
        limits.cpu: "20"
        limits.memory: 40Gi
    storage:
      enabled: true
      name: storage-resources
      values:
        requests.storage: 100Gi
        persistentvolumeclaims: "10"
        ephemeral-storage: "50Gi"
    objects:
      enabled: true
      name: objects-resources
      values:
        pods: "50"
        services: "20"
        secrets: "100"
        configmaps: "100"
        count/deployments.apps: "20"
        count/statefulsets.apps: "10"

  rbac:
    enabled: true
    roleBindings:
      - name: developers
        clusterRole: edit
        groups: []

project:
  name: "my-app-project"
  namespace: "my-namespace"
  enabled: true
  description: ""
  sourceRepos:
    - https://github.com/example/repo.git
  destinations:
    - server: https://kubernetes.default.svc
      namespace: example-namespace
  namespaceResourceWhitelist:
    - group: '*'
      kind: '*'
  roles:
    - name: example-role
      groups:
        - developer
      policies:
        - p, proj:my-app-project:developer, applications, *, my-app-project/*, allow
        - p, proj:my-app-project:developer, repositories, get, my-app-project/*, allow
        - p, proj:my-app-project:developer, clusters, get, *, allow
        - p, proj:my-app-project:developer, projects, get, my-app-project, allow

namespaces:
  - name: abc
    extraResources:
      - apiVersion: v1
        kind: Secret
        metadata:
          name: test
          namespace: test
        stringData:
          key: value
```

## Minimal configuration

```yaml
defaults:
  namespace:
    labels:
      ns.openshift.io/owner: "tenant-team"
    features:
      enableNetpolAuditLogging: true
      enableUserMonitoring: true
      enableCertificateConfigMap: true

project:
  name: "my-app-project"
  namespace: "my-namespace"
  enabled: true
  description: ""
  sourceRepos:
    - https://github.com/example/repo.git
  destinations:
    - server: https://kubernetes.default.svc
      namespace: example-namespace
  namespaceResourceWhitelist:
    - group: '*'
      kind: '*'
  roles:
    - name: example-role
      groups:
        - developer
      policies:
        - p, proj:my-app-project:developer, applications, *, my-app-project/*, allow
        - p, proj:my-app-project:developer, repositories, get, my-app-project/*, allow
        - p, proj:my-app-project:developer, clusters, get, *, allow
        - p, proj:my-app-project:developer, projects, get, my-app-project, allow

namespaces:
  - name: abc
    extraResources:
      - apiVersion: v1
        kind: Secret
        metadata:
          name: test
          namespace: test
        stringData:
          key: value
```

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| argoCD | object | `{"name":"openshift-gitops","namespace":"openshift-gitops"}` | argoCD is the configuration for the Developer Argo CD instance. |
| argoCD.name | string | `"openshift-gitops"` | name is the name of the Developer Argo CD instance. |
| argoCD.namespace | string | `"openshift-gitops"` | namespace is the namespace where the Developer Argo CD instance resides. |
| defaults.limitRange | object | `{"container":{"enabled":true,"values":{"default":{"cpu":"500m","memory":"1Gi"},"defaultRequest":{"cpu":"30m","memory":"200Mi"},"max":{"cpu":"4","memory":"4Gi"},"min":{"cpu":"10m","memory":"10Mi"}}},"enabled":false,"name":"default","pod":{"enabled":true,"values":{"max":{"cpu":"2","memory":"1Gi"},"min":{"cpu":"200m","memory":"6Mi"}}},"pvc":{"enabled":true,"values":{"max":{"storage":"10Gi"},"min":{"storage":"1Gi"}}}}` | limitRange defines default limits applied when enableLimitRange is true. |
| defaults.limitRange.container | object | `{"enabled":true,"values":{"default":{"cpu":"500m","memory":"1Gi"},"defaultRequest":{"cpu":"30m","memory":"200Mi"},"max":{"cpu":"4","memory":"4Gi"},"min":{"cpu":"10m","memory":"10Mi"}}}` | Configuration for container-level limits (max, min, default, defaultRequest). |
| defaults.limitRange.container.enabled | bool | `true` | enabled indicates if container limits are enabled. Only used if parent "limitRange" enabled is true. |
| defaults.limitRange.container.values | object | `{"default":{"cpu":"500m","memory":"1Gi"},"defaultRequest":{"cpu":"30m","memory":"200Mi"},"max":{"cpu":"4","memory":"4Gi"},"min":{"cpu":"10m","memory":"10Mi"}}` | values defines the concrete limit values. |
| defaults.limitRange.container.values.max | object | `{"cpu":"4","memory":"4Gi"}` | max limits for containers. |
| defaults.limitRange.container.values.max.cpu | string | `"4"` | cpu defines the maximum CPU limit. |
| defaults.limitRange.container.values.max.memory | string | `"4Gi"` | memory defines the maximum memory limit. |
| defaults.limitRange.enabled | bool | `false` | whether to enable LimitRange by default. |
| defaults.limitRange.name | string | `"default"` | name of the LimitRange resource. |
| defaults.limitRange.pod.enabled | bool | `true` | enabled indicates if container limits are enabled. Only used if parent "limitRange" enabled is true. |
| defaults.limitRange.pod.values | object | `{"max":{"cpu":"2","memory":"1Gi"},"min":{"cpu":"200m","memory":"6Mi"}}` | values defines the concrete limit values. |
| defaults.limitRange.pvc.enabled | bool | `true` | enabled indicates if container limits are enabled. Only used if parent "limitRange" enabled is true. |
| defaults.limitRange.pvc.values | object | `{"max":{"storage":"10Gi"},"min":{"storage":"1Gi"}}` | values defines the concrete limit values. |
| defaults.namespace.annotations | object | `{}` | Annotations applied to all Namespaces being provisioned. |
| defaults.namespace.features | object | `{"enableArgocdRBAC":true,"enableCertificateConfigMap":true,"enableNetpolAuditLogging":true,"enableServiceCaCertificateConfigMap":true,"enableUserMonitoring":true}` | features contains feature flags applied to all namespaces unless overridden. |
| defaults.namespace.features.enableArgocdRBAC | bool | `true` | enableArgocdRBAC enables ArgoCD RBAC RoleBinding creation for the namespace. When disabled, ArgoCD's application and applicationset controllers will not have access to the namespace, unless manually granted. |
| defaults.namespace.features.enableCertificateConfigMap | bool | `true` | enableCertificateConfigMap enables automatic injection of the cluster CA bundle into a ConfigMap in the namespace. |
| defaults.namespace.features.enableNetpolAuditLogging | bool | `true` | enableNetpolAuditLogging enables OVN ACL logging for allowed and denied traffic. |
| defaults.namespace.features.enableServiceCaCertificateConfigMap | bool | `true` | enableServiceCaCertificateConfigMap enables automatic injection of the service CA bundle into a ConfigMap with service.beta.openshift.io/inject-cabundle: "true" in the namespace. |
| defaults.namespace.features.enableUserMonitoring | bool | `true` | enableUserMonitoring enables user-defined Prometheus monitoring for applications. |
| defaults.namespace.labels | object | `{}` | Labels applied to all Namespaces being provisioned. |
| defaults.rbac | object | `{"enabled":false,"roleBindings":[]}` | rbac defines default RBAC settings applied when enableRBAC is true. |
| defaults.rbac.enabled | bool | `false` | whether to enable RBAC by default. |
| defaults.rbac.roleBindings | list | `[]` | roleBindings of roles to OpenShift groups. |
| defaults.resourceQuota | object | `{"compute":{"enabled":true,"name":"compute-resources","values":{"limits.cpu":"20","limits.memory":"40Gi","requests.cpu":"10","requests.memory":"20Gi"}},"enabled":false,"objects":{"enabled":true,"name":"objects-resources","values":{"configmaps":"100","count/deployments.apps":"20","count/statefulsets.apps":"10","pods":"50","secrets":"100","services":"20"}},"storage":{"enabled":true,"name":"storage-resources","values":{"ephemeral-storage":"50Gi","persistentvolumeclaims":"10","requests.storage":"100Gi"}}}` | resourceQuota defines default resource quotas applied when enableResourceQuota is true. |
| defaults.resourceQuota.compute | object | `{"enabled":true,"name":"compute-resources","values":{"limits.cpu":"20","limits.memory":"40Gi","requests.cpu":"10","requests.memory":"20Gi"}}` | compute quotas (requests.cpu, limits.memory, etc). |
| defaults.resourceQuota.compute.enabled | bool | `true` | enabled indicates if compute resource quotas are enabled. Only used if parent "resourceQuota" enabled is true. |
| defaults.resourceQuota.compute.name | string | `"compute-resources"` | name of the ResourceQuota for compute resources. |
| defaults.resourceQuota.compute.values | object | `{"limits.cpu":"20","limits.memory":"40Gi","requests.cpu":"10","requests.memory":"20Gi"}` | values for compute resource quotas. |
| defaults.resourceQuota.enabled | bool | `false` | whether to enable ResourceQuota by default. |
| defaults.resourceQuota.objects | object | `{"enabled":true,"name":"objects-resources","values":{"configmaps":"100","count/deployments.apps":"20","count/statefulsets.apps":"10","pods":"50","secrets":"100","services":"20"}}` | Quotas for Kubernetes object counts (pods, services, secrets, etc). |
| defaults.resourceQuota.objects.enabled | bool | `true` | enabled indicates if compute resource quotas are enabled. Only used if parent "resourceQuota" enabled is true. |
| defaults.resourceQuota.objects.name | string | `"objects-resources"` | name of the ResourceQuota for compute resources. |
| defaults.resourceQuota.objects.values | object | `{"configmaps":"100","count/deployments.apps":"20","count/statefulsets.apps":"10","pods":"50","secrets":"100","services":"20"}` | values for objects resource quotas. |
| defaults.resourceQuota.storage | object | `{"enabled":true,"name":"storage-resources","values":{"ephemeral-storage":"50Gi","persistentvolumeclaims":"10","requests.storage":"100Gi"}}` | Quotas for storage resources (requests.storage, pvc counts, etc). |
| defaults.resourceQuota.storage.enabled | bool | `true` | enabled indicates if compute resource quotas are enabled. Only used if parent "resourceQuota" enabled is true. |
| defaults.resourceQuota.storage.name | string | `"storage-resources"` | name of the ResourceQuota for storage resources. |
| defaults.resourceQuota.storage.values | object | `{"ephemeral-storage":"50Gi","persistentvolumeclaims":"10","requests.storage":"100Gi"}` | values for storage resource quotas. |
| namespaces | list | `[]` | namespaces defines an array of namespace definitions to be created. |
| project | object | `{"clusterResourceBlacklist":[],"clusterResourceWhitelist":[],"description":"","destinations":[],"enabled":false,"name":"","namespace":"","namespaceResourceBlacklist":[],"namespaceResourceWhitelist":[],"roles":[],"sourceRepos":[]}` | project defines the Argo CD AppProject to create for the tenant namespaces. |
| project.description | string | `""` | description is an optional description for the AppProject. |
| project.destinations | list | `[]` | destinations is a list of allowed deployment destinations for applications in this project. |
| project.enabled | bool | `false` | enable of disable the project resource creation |
| project.name | string | `""` | name is the name of the Argo CD AppProject to create. |
| project.namespace | string | `""` | argocdNamespace is the namespace where the Developer Argo CD instance resides (used for AppProject and delegation). |
| project.annotations | list | `[]` | annotations is a list of annotations for this project. |
| project.roles | list | `[]` | roles is a list of roles and their policies for this project. |
| project.sourceRepos | list | `[]` | sourceRepos is a list of allowed source repositories for applications in this project. |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.14.2](https://github.com/norwoodj/helm-docs/releases/v1.14.2)
