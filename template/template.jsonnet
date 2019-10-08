local sponnet = import '../sponnet/pipeline.libsonnet';

local appName = 'monitoring-gui';
local account = 'lab3-lab3-sre-gke-main-20190401';

local manifestRepo = 'https://api.github.com/repos/tamac-io/bs_mon_gui/contents/';
local svcArtifactName = 'kube/lab2alfa/manifest.yaml';

local manifest = import './manifest.jsonnet';
local svcManifestArtifact = manifest
                            .withName(svcArtifactName)
                            .withReference(manifestRepo + svcArtifactName);

local manifestAccount = 'spinnaker-artifact-account';
local expectedGithubArticactId = '3571386c-6999-426e-aaff-3bbe16ca7a07';
local expectedSVCManifestArticact = sponnet.expectedArtifact(expectedGithubArticactId)
                                    .withDefaultArtifact(svcManifestArtifact)
                                    .withDisplayName(svcArtifactName)
                                    .withUseDefaultArtifact(true)
                                    .withUsePriorArtifact(false);


local moniker = sponnet.moniker(appName);
local trafficManagement = sponnet.kubernetes.trafficManagement();

local svc4first = sponnet.stages
                  .deployManifest('Svc for first')
                  .withAccount(account)
                  .withCompleteOtherBranchesThenFail(false)
                  .withContinuePipeline(false)
                  .withFailPipeline(true)
                  .withManifestArtifactAccount(manifestAccount)
                  .withManifestArtifact(expectedSVCManifestArticact)
                  .withMoniker(moniker)
                  .withRequisiteStages([])
                  .withSkipExpressionEvaluation(false)
                  .withOverrideTimeout(300000)
                  .withTrafficManagement(trafficManagement);

local namespace = 'lab2alfa-app-monitoring';
local options = {
  enableTraffic: false,
  namespace: namespace,
  services: [
    'service ' + appName,
  ],
};

local enableTrafficManagement = sponnet.kubernetes.trafficManagement()
                                .isEnabled(true)
                                .withOptions(options);

//local rs4first = sponnet.stages
//                 .deployManifest('RS for first')
//                 .withAccount(account)
//                 .withCompleteOtherBranchesThenFail(false)
//                 .withContinuePipeline(true)
//                 .withFailPipeline(false)
//                 .withManifestArtifactAccount(manifestAccount)
//                 .withManifestArtifact()
//                 .withMoniker(moniker)
//                 .withRequisiteStages([svc4first])
//                 .withSkipExpressionEvaluation(false)
//                 .withOverrideTimeout(300000)
//                 .withTrafficManagement(enableTrafficManagement);

sponnet.pipeline()
.withExpectedArtifacts([expectedSVCManifestArticact])
.withKeepWaitingPipelines(true)
.withLimitConcurrent(true)
.withParameters([])
.withRoles(['gcp-adminpod-sre'])
.withStages([svc4first])
.withTriggers([])
