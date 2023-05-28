local adapt = import 'spaas/lib/kubernetes/adapt.libsonnet';

{
  params:: {
    namespace: 'istio-system',
    componentName: 'istio-ingressgateway-external',
    chartPath: '../../charts/1.17/gateway',
    loadbalancerSchema: 'internet-facing',
    resource: {
      cpuRequestM: 1000,
      cpuLimitM: 2000,
      ramRequestMi: 1024,
      ramLimitMi: 2048,
    },
  },
  local p = self.params,
  values:: {
    name: p.componentName,

    service: {
      annotations: {
        "external-dns.alpha.kubernetes.io/hostname": '*.srv.us-east-1.dev.smartnews.net',
        "service.beta.kubernetes.io/aws-load-balancer-scheme": "internet-facing",
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
