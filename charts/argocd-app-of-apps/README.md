# argocd-app-of-apps

![Version: 1.0.0](https://img.shields.io/badge/Version-1.0.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 1.0.0](https://img.shields.io/badge/AppVersion-1.0.0-informational?style=flat-square)

A Helm chart for ArgoCD to manage the App of Apps pattern

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| appSourceBasePath | string | `nil` |  |
| appSuffix | string | `nil` |  |
| applications | object | `{"example":{"annotations":{},"destination":{"namespace":"openshift-gitops","server":"https://kubernetes.default.svc"},"enabled":true,"extraFields":{},"finalizers":[],"labels":{},"namespace":"openshift-gitops","project":"default","source":{"chart":null,"helm":{"ignoreMissingValueFiles":false,"releaseName":"","valueFiles":["$myRepo/values.yaml"]},"ignoreBasePath":false,"path":"","repoURL":"https://github.com/my-org/my-repo","targetRevision":"master"},"sources":[{"helm":{"ignoreMissingValueFiles":false,"releaseName":"app-of-apps","valueFiles":["$myRepo/values.yaml"]},"repoURL":"https://ghcr.io/redhat-consulting-services/helm-charts/argocd-app-of-apps","targetRevision":"0.1.0"},{"ignoreBasePath":false,"path":"app-of-apps","ref":"myRepo","repoURL":"https://github.com/redhat-consulting-services/helm-charts","targetRevision":"HEAD"}],"syncPolicy":{"automated":{"prune":true,"selfHeal":true},"retry":{},"syncOptions":[]}}}` | Define a map of applications and their configurations |
| applications.example.enabled | bool | `true` | enabled is a flag to enable or disable the application |
| applications.example.extraFields | object | `{}` | extraFields allows for adding additional fields to the application, that are not mapped |
| applications.example.source | object | `{"chart":null,"helm":{"ignoreMissingValueFiles":false,"releaseName":"","valueFiles":["$myRepo/values.yaml"]},"ignoreBasePath":false,"path":"","repoURL":"https://github.com/my-org/my-repo","targetRevision":"master"}` | source is the source of the application only one of application.example.source or application.example.sources can be set |
| applications.example.source.chart | string | `nil` | chart is the name of the chart to be used |
| applications.example.source.helm | object | `{"ignoreMissingValueFiles":false,"releaseName":"","valueFiles":["$myRepo/values.yaml"]}` | helm is the Helm specific configuration For more information about the Helm configuration, see https://argo-cd.readthedocs.io/en/stable/user-guide/helm/#helm |
| applications.example.source.helm.ignoreMissingValueFiles | bool | `false` | ignoreMissingValueFiles is a flag to ignore missing value files |
| applications.example.source.helm.releaseName | string | `""` | releaseName is the name of the Helm release |
| applications.example.source.helm.valueFiles | list | `["$myRepo/values.yaml"]` | valueFiles is a list of Helm value files to be used (`$ref` can be used to reference a different source) |
| applications.example.source.ignoreBasePath | bool | `false` | ignoreBasePath is a flag to ignore the base path set in appSourceBasePath |
| applications.example.source.path | string | `""` | path is the path to the application source |
| applications.example.source.repoURL | string | `"https://github.com/my-org/my-repo"` | repoURL is the URL to the application source repository |
| applications.example.source.targetRevision | string | `"master"` | targetRevision is the revision of the application source repository |
| applications.example.sources | list | `[{"helm":{"ignoreMissingValueFiles":false,"releaseName":"app-of-apps","valueFiles":["$myRepo/values.yaml"]},"repoURL":"https://ghcr.io/redhat-consulting-services/helm-charts/argocd-app-of-apps","targetRevision":"0.1.0"},{"ignoreBasePath":false,"path":"app-of-apps","ref":"myRepo","repoURL":"https://github.com/redhat-consulting-services/helm-charts","targetRevision":"HEAD"}]` | sources is a list of sources for the application only one of application.example.source or application.example.sources can be set |
| applications.example.sources[0].helm | object | `{"ignoreMissingValueFiles":false,"releaseName":"app-of-apps","valueFiles":["$myRepo/values.yaml"]}` | helm is the Helm specific configuration For more information about the Helm configuration, see https://argo-cd.readthedocs.io/en/stable/user-guide/helm/#helm |
| applications.example.sources[0].helm.ignoreMissingValueFiles | bool | `false` | ignoreMissingValueFiles is a flag to ignore missing value files |
| applications.example.sources[0].helm.releaseName | string | `"app-of-apps"` | releaseName is the name of the Helm release |
| applications.example.sources[0].helm.valueFiles | list | `["$myRepo/values.yaml"]` | valueFiles is a list of Helm value files to be used (`$ref` can be used to reference a different source) |
| applications.example.sources[0].repoURL | string | `"https://ghcr.io/redhat-consulting-services/helm-charts/argocd-app-of-apps"` | repoURL is the URL to the application source repository |
| applications.example.sources[0].targetRevision | string | `"0.1.0"` | targetRevision is the revision of the application source repository |
| applications.example.sources[1].ignoreBasePath | bool | `false` | ignoreBasePath is a flag to ignore the base path set in appSourceBasePath |
| applications.example.sources[1].path | string | `"app-of-apps"` | path is the path to the application source |
| applications.example.sources[1].ref | string | `"myRepo"` | ref is the reference name to be used in the application (only used when Helm is used with different repositories for chart and values) |
| applications.example.sources[1].repoURL | string | `"https://github.com/redhat-consulting-services/helm-charts"` | repoURL is the URL to the application source repository |
| applications.example.sources[1].targetRevision | string | `"HEAD"` | targetRevision is the revision of the application source repository |
| applications.example.syncPolicy | object | `{"automated":{"prune":true,"selfHeal":true},"retry":{},"syncOptions":[]}` | syncPolicy is the sync policy for the application |
| applications.example.syncPolicy.automated | object | `{"prune":true,"selfHeal":true}` | automated is the automated sync policy for the application |
| applications.example.syncPolicy.automated.prune | bool | `true` | prune is a flag to enable or disable pruning |
| applications.example.syncPolicy.automated.selfHeal | bool | `true` | selfHeal is a flag to enable or disable self-healing |
| applications.example.syncPolicy.retry | object | `{}` | retry is the retry strategy for the application |
| applications.example.syncPolicy.syncOptions | list | `[]` | syncOptions is a list of sync options |
| default | object | `{"application":{"annotations":{},"destination":{"namespace":"openshift-gitops","server":"https://kubernetes.default.svc"},"enabled":false,"finalizers":[],"labels":{},"namespace":"openshift-gitops","project":"default","source":{"helm":{},"ignoreBasePath":false,"path":"","repoURL":"https://github.com/my-org/my-repo","targetRevision":"master"},"syncPolicy":{"automated":{"prune":true,"selfHeal":true},"retry":{},"syncOptions":[]}}}` | Default values for all applications |
| default.application | object | `{"annotations":{},"destination":{"namespace":"openshift-gitops","server":"https://kubernetes.default.svc"},"enabled":false,"finalizers":[],"labels":{},"namespace":"openshift-gitops","project":"default","source":{"helm":{},"ignoreBasePath":false,"path":"","repoURL":"https://github.com/my-org/my-repo","targetRevision":"master"},"syncPolicy":{"automated":{"prune":true,"selfHeal":true},"retry":{},"syncOptions":[]}}` | We expect the same structure as for the applications below |
| fullnameOverride | string | `""` |  |
| nameOverride | string | `""` |  |
| projects | object | `{}` | Define a map of projects and their configurations |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.14.2](https://github.com/norwoodj/helm-docs/releases/v1.14.2)
