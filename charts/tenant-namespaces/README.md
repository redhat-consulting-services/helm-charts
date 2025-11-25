# tenant-namespaces

![Version: 0.1.0](https://img.shields.io/badge/Version-0.1.0-informational?style=flat-square)

A Helm-chart to create namespaces with a baseline configuration of resource quota, limit range and labels.

## Prerequisites

* This chart expects that a clusterwide ArgoCD instance is already installed and configured in the cluster.
* It also expects that a dedicated developer ArgoCD instance is available for the tenant teams to use.
* The chart has been developed with BANP & ANP (BaselineAdminNetworkPolicies & AdminNetworkPolicies) in mind, but can be used without it as well.

## Defining Namespaces for a Tenant

This section defines the array of namespaces to be provisioned for a single tenant. The settings will override the global defaults.

```yaml
---
# ArgoCD AppProject specifications
project:
  enabled: true
  name: team-a
  description: "AppProject for Team A"
# Allowed repos to use with the developer ArgoCD
  sourceRepos:
    - 'https://github-team-a-*'
  destinations:
# Allowed namespaces for developer ArgoCD to deploy to
    - namespace: 'team-a-*'
      server: https://kubernetes.default.svc
  roles:
    - name: developer
# Permissions for the developer team on the ArgoCD objects
      policies:
        - p, proj:team-a:developer, applications, *, team-a/*, allow
        - p, proj:team-a:developer, repositories, get, team-a/*, allow
        - p, proj:team-a:developer, clusters, get, *, allow
        - p, proj:team-a:developer, projects, get, team-a, allow
# Team or teams to be part of this appProject
      groups:
        - team-a-developers

# Namespaces to be created, with or without any default overwrites
namespaces:
  - name: team-a-test

    enableResourceQuota: true
    enableLimitRange: true
    enableRBAC: true

    resourceQuota:
      compute:
        requests.cpu: "5"
        requests.memory: 10Gi
        limits.cpu: "10"
        limits.memory: 20Gi

    rbac:
      developers:
        groups:
          - "team-a-devs"
      admins:
        groups:
          - "team-a-admins"
```

## Minimal configuration

```yaml
---
# ArgoCD AppProject specifications
project:
  enabled: true
  name: team-a
  description: "AppProject for Team A"
# Allowed repos to use with the developer ArgoCD
  sourceRepos:
    - 'https://github-team-a-*'
  destinations:
# Allowed namespaces for developer ArgoCD to deploy to
    - namespace: 'team-a-*'
      server: https://kubernetes.default.svc
  roles:
    - name: developer
# Permissions for the developer team on the ArgoCD objects
      policies:
        - p, proj:team-a:developer, applications, *, team-a/*, allow
        - p, proj:team-a:developer, repositories, get, team-a/*, allow
        - p, proj:team-a:developer, clusters, get, *, allow
        - p, proj:team-a:developer, projects, get, team-a, allow
# Team or teams to be part of this appProject
      groups:
        - team-a-developers

# Namespaces to be created, with or without any default overwrites
namespaces:
  - name: team-a-minimal
    rbac:
      developers:
        groups:
          - "team-a-devs"
      admins:
        groups:
          - "team-a-admins"
    # All defaults apply unless overridden
```

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| argocdNamespace | string | `"argocd-dev"` | argocdNamespace is the namespace where the Developer Argo CD instance resides (used for AppProject and delegation). |
| defaults.annotations | object | `{}` | Annotations applied to all Namespaces being provisioned. |
| defaults.enableArgocdRBAC | bool | `true` | enableArgocdRBAC enables deployment of the AppProject resource for Argo CD RBAC. |
| defaults.enableLimitRange | bool | `true` | enableLimitRange deploys a Kubernetes LimitRange based on limitRangeDefaults. |
| defaults.enableNetpolAuditLogging | bool | `true` | enableNetpolAuditLogging enables OVN ACL logging for allowed and denied traffic. |
| defaults.enableRBAC | bool | `true` | enableRBAC deploys default RoleBindings (from rbacDefaults) for users. |
| defaults.enableResourceQuota | bool | `false` | enableResourceQuota deploys a Kubernetes ResourceQuota based on resourceQuotaDefaults. |
| defaults.enableUserMonitoring | bool | `true` | enableUserMonitoring enables user-defined Prometheus monitoring for applications. |
| defaults.labels | object | `{"argocd.argoproj.io/managed-by":"argocd-dev","platform.openshift.io/network-policy":"enforced"}` | Labels and annotations applied to all Namespaces being provisioned. |
| defaults.labels."argocd.argoproj.io/managed-by" | string | `"argocd-dev"` | Label required by the OpenShift GitOps Operator to grant permissions to the argocd-dev instance. |
| defaults.labels."platform.openshift.io/network-policy" | string | `"enforced"` | Label required for cluster-wide BANP/ANP network policy enforcement. |
| defaults.limitRange | object | `{"container":{"default":{"cpu":"500m","memory":"1Gi"},"defaultRequest":{"cpu":"30m","memory":"200Mi"},"max":{"cpu":"4","memory":"4Gi"},"min":{"cpu":"10m","memory":"10Mi"}}}` | limitRange defines default limits applied when enableLimitRange is true. |
| defaults.limitRange.container | object | `{"default":{"cpu":"500m","memory":"1Gi"},"defaultRequest":{"cpu":"30m","memory":"200Mi"},"max":{"cpu":"4","memory":"4Gi"},"min":{"cpu":"10m","memory":"10Mi"}}` | Configuration for container-level limits (max, min, default, defaultRequest). |
| defaults.rbac | object | `{"admins":{"clusterRole":"admin","enabled":true,"groups":[]},"developers":{"clusterRole":"edit","enabled":true,"groups":[]}}` | rbac defines default RBAC settings applied when enableRBAC is true. |
| defaults.rbac.admins | object | `{"clusterRole":"admin","enabled":true,"groups":[]}` | Settings for admin role bindings. |
| defaults.rbac.admins.clusterRole | string | `"admin"` | The ClusterRole to bind to the admin groups (e.g., 'admin'). |
| defaults.rbac.admins.enabled | bool | `true` | Whether to create the admin RoleBinding. |
| defaults.rbac.admins.groups | list | `[]` | List of LDAP groups to receive admin access. |
| defaults.rbac.developers | object | `{"clusterRole":"edit","enabled":true,"groups":[]}` | Settings for developer role bindings. |
| defaults.rbac.developers.clusterRole | string | `"edit"` | The ClusterRole to bind to the developer groups (e.g., 'edit'). |
| defaults.rbac.developers.enabled | bool | `true` | Whether to create the developer RoleBinding. |
| defaults.rbac.developers.groups | list | `[]` | List of LDAP groups to receive developer access. |
| defaults.resourceQuota | object | `{"compute":{"limits.cpu":"20","limits.memory":"40Gi","requests.cpu":"10","requests.memory":"20Gi"},"objects":{"configmaps":"100","count/deployments.apps":"20","count/statefulsets.apps":"10","pods":"50","secrets":"100","services":"20"},"storage":{"ephemeral-storage":"50Gi","persistentvolumeclaims":"10","requests.storage":"100Gi"}}` | resourceQuota defines default resource quotas applied when enableResourceQuota is true. |
| defaults.resourceQuota.compute | object | `{"limits.cpu":"20","limits.memory":"40Gi","requests.cpu":"10","requests.memory":"20Gi"}` | Quotas for compute resources (requests.cpu, limits.memory, etc). |
| defaults.resourceQuota.objects | object | `{"configmaps":"100","count/deployments.apps":"20","count/statefulsets.apps":"10","pods":"50","secrets":"100","services":"20"}` | Quotas for Kubernetes object counts (pods, services, secrets, etc). |
| defaults.resourceQuota.storage | object | `{"ephemeral-storage":"50Gi","persistentvolumeclaims":"10","requests.storage":"100Gi"}` | Quotas for storage resources (requests.storage, pvc counts, etc). |
| namespaces | list | `[]` | namespaces defines an array of namespace definitions to be created. |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.14.2](https://github.com/norwoodj/helm-docs/releases/v1.14.2)