local adapt = import 'spaas/lib/kubernetes/adapt.libsonnet';

{

  params:: {error 'Must provide params',
  local p = self.params,

  values:: {
    name: p.componentName,

    service: {
      annotations: {
        "service.beta.kubernetes.io/aws-load-balancer-scheme": '%s' % p.loadbalancerSchema,
        "service.beta.kubernetes.io/aws-load-balancer-type": "nlb-ip",
        "service.beta.kubernetes.io/aws-load-balancer-cross-zone-load-balancing-enabled": "true",
      }
    },

    resources: {
      requests: {
        cpu: '%sm' % p.resource.cpuRequestM,
        memory: '%sMi' % p.resource.ramRequestMi,
      },
      limits: {
        cpu: '%sMi' % p.resource.cpuLimitMi,
        memory: '%sMi' % p.resource.ramLimitMi,
      },
    },
  },

  patches:: [],
  chart: adapt.importHelmManifests(std.thisFile, p.namespace, p.componentName, p.chartPath, [$.values], {}, {}, patches=self.patches),
}
