# group-sync

![Version: 0.1.1](https://img.shields.io/badge/Version-0.1.1-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 1.16.0](https://img.shields.io/badge/AppVersion-1.16.0-informational?style=flat-square)

A Helm chart for doing Group Synchronization in OpenShift

## Prerequisites

An LDAP server reachable from the OpenShift cluster

Access to a oc CLI container e.g. ose-cli

## Example

```yaml
image:
  repository: registry.redhat.io/openshift4/ose-cli
  tag: "latest"
  pullPolicy: IfNotPresent

ldap:
  url: "ldaps://ldap-service.ldap-group-sync.svc.cluster.local:636"
  baseDN: "dc=example,dc=com"
  bindDN: "cn=admin,dc=example,dc=com"

  secretName: "ldap-secret"

  insecure: false

  caCert: |-
    -----BEGIN CERTIFICATE-----
    ...
    -----END CERTIFICATE-----

whitelist: |
  cn=lab-admins,ou=groups,dc=example,dc=com
  cn=lab-readers,ou=groups,dc=example,dc=com

syncSettings:
  groupsQuery:
    filter: "(objectclass=groupOfNames)"
    scope: "sub"
    derefAliases: "never"
  usersQuery:
    derefAliases: "never"
  groupUIDAttribute: "dn"
  groupNameAttributes: [ "cn" ]
  groupMembershipAttributes: [ "member" ]
  userNameAttributes: [ "cn" ]
  userUIDAttribute: "dn"
  tolerateMemberNotFound: true
  tolerateMemberOutOfScope: true

cronjob:
  schedule: "*/30 * * * *"
  concurrencyPolicy: Forbid
  backoffLimit: 0
  activeDeadlineSeconds: 500
  ttlSecondsAfterFinished: 1800

extraResources:
  - apiVersion: external-secrets.io/v1
    kind: ExternalSecret
    metadata:
      name: ldap-creds
    spec:
      refreshInterval: 1h
      secretStoreRef:
        name: vault-backend
        kind: ClusterSecretStore
      target:
        name: ldap-creds
      data:
        - secretKey: bindPassword
          remoteRef:
            key: secret/ldap
            property: password
```

## Minimal Configuration

```yaml
ldap:
  url: "ldap://10.0.2.2:389"
  baseDN: "dc=example,dc=com"
  bindDN: "cn=admin,dc=example,dc=com"
  secretName: "ldap-secret"

syncSettings:
  groupsQuery:
    derefAliases: "never"
  usersQuery:
    derefAliases: "never"
```

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| cronjob.activeDeadlineSeconds | int | `500` | Maximum duration in seconds for the sync job to run |
| cronjob.backoffLimit | int | `0` | Number of retries before considering a job as failed |
| cronjob.concurrencyPolicy | string | `"Forbid"` | Concurrency policy for the CronJob (Allow, Forbid, or Replace) |
| cronjob.schedule | string | `"*/30 * * * *"` | Cron schedule for automatic LDAP group synchronization (in cron format) |
| cronjob.ttlSecondsAfterFinished | int | `1800` | Time in seconds to keep finished job pods before cleanup |
| extraResources[0].apiVersion | string | `"external-secrets.io/v1"` |  |
| extraResources[0].kind | string | `"ExternalSecret"` |  |
| extraResources[0].metadata.name | string | `"ldap-creds"` |  |
| extraResources[0].spec.data[0].remoteRef.key | string | `"secret/ldap"` |  |
| extraResources[0].spec.data[0].remoteRef.property | string | `"password"` |  |
| extraResources[0].spec.data[0].secretKey | string | `"bindPassword"` |  |
| extraResources[0].spec.refreshInterval | string | `"1h"` |  |
| extraResources[0].spec.secretStoreRef.kind | string | `"ClusterSecretStore"` |  |
| extraResources[0].spec.secretStoreRef.name | string | `"vault-backend"` |  |
| extraResources[0].spec.target.name | string | `"ldap-creds"` |  |
| image.pullPolicy | string | `"IfNotPresent"` | Image pull policy |
| image.repository | string | `"registry.redhat.io/openshift4/ose-cli"` | Container image repository for the OpenShift CLI |
| image.tag | string | `"latest"` | Container image tag |
| ldap.baseDN | string | `"dc=example,dc=com"` | LDAP base DN for searches |
| ldap.bindDN | string | `"cn=admin,dc=example,dc=com"` | LDAP bind DN for authentication |
| ldap.caCert | string | `"-----BEGIN CERTIFICATE-----\n...\n-----END CERTIFICATE-----"` | CA certificate for LDAPS connections (required when insecure is false) |
| ldap.insecure | bool | `false` | Allow insecure LDAP connections (set to true for ldap:// without TLS) |
| ldap.secretName | string | `"ldap-secret"` | Name of the Kubernetes secret containing the 'bindPassword' key |
| ldap.url | string | `"ldaps://ldap-service.ldap-group-sync.svc.cluster.local:636"` | LDAP server URL (ldap:// or ldaps://) |
| syncSettings.groupMembershipAttributes | list | `["member"]` | LDAP attributes that define group membership |
| syncSettings.groupNameAttributes | list | `["cn"]` | LDAP attributes to use for the group name in OpenShift |
| syncSettings.groupUIDAttribute | string | `"dn"` | LDAP attribute to use as the group's unique identifier |
| syncSettings.groupsQuery.derefAliases | string | `"never"` | LDAP alias dereferencing behavior for group queries (never, search, base, or always) |
| syncSettings.groupsQuery.filter | string | `"(objectclass=groupOfNames)"` | LDAP filter for group searches |
| syncSettings.groupsQuery.scope | string | `"sub"` | Search scope for group queries (sub, one, or base) |
| syncSettings.tolerateMemberNotFound | bool | `true` | Continue sync if a group member is not found in LDAP |
| syncSettings.tolerateMemberOutOfScope | bool | `true` | Continue sync if a group member is outside the user search scope |
| syncSettings.userNameAttributes | list | `["cn"]` | LDAP attributes to use for the user name in OpenShift |
| syncSettings.userUIDAttribute | string | `"dn"` | LDAP attribute to use as the user's unique identifier |
| syncSettings.usersQuery.derefAliases | string | `"never"` | LDAP alias dereferencing behavior for user queries (never, search, base, or always) |
| whitelist | string | `"cn=lab-admins,ou=groups,dc=example,dc=com\ncn=lab-readers,ou=groups,dc=example,dc=com\n"` | Whitelist of LDAP group DNs to sync. Each group must exist in your LDAP server. Use multi-line format with one group DN per line |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.14.2](https://github.com/norwoodj/helm-docs/releases/v1.14.2)
