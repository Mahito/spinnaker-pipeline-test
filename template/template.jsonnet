local sponnet = import '../sponnet/pipeline.libsonnet';

local account = '${PROVIDER}';
local manifestAccount = 'spinnaker-artifact-account';
local moniker = sponnet.moniker('${APPLICATION}');

local cluster = 'replicaSet ${APPLICATION}';
local comparison = '==';
local expected = 0;
local regions = ['${NAMESPACE}'];

local stage3 = sponnet.stages
               .checkPreconditions('First Deploy')
               .withClusterSize(cluster, comparison, account, expected, moniker, regions, false);

local expectedArtifact = sponnet.expectedArtifact('${MANIFEST}');
local disableTrafficManagement = sponnet.kubernetes.trafficManagement();

local stage1 = sponnet.stages
               .deployManifest('Svc for first')
               .withAccount(account)
               .withCompleteOtherBranchesThenFail(false)
               .withContinuePipeline(false)
               .withFailPipeline(true)
               .withManifestArtifactAccount(manifestAccount)
               .withManifestArtifact(expectedArtifact)
               .withMoniker(moniker)
               .withRequisiteStages([stage3])
               .withSkipExpressionEvaluation(false)
               .withOverrideTimeout(300000)
               .withTrafficManagement(disableTrafficManagement);


local expectedRsArtifact = sponnet.expectedArtifact('${MANIFEST_RS}');

local tmOptions = {
  enableTraffic: false,
  namespace: '${NAMESPACE}',
  services: [
    'service ${SERVICE_NAME}',
  ],
};
local enableTrafficManagement = sponnet.kubernetes.trafficManagement()
                                .isEnabled(true)
                                .withOptions(tmOptions);

local stage2 = sponnet.stages
               .deployManifest('RS for first')
               .withAccount(account)
               .withCompleteOtherBranchesThenFail(false)
               .withContinuePipeline(true)
               .withFailPipeline(false)
               .withManifestArtifactAccount(manifestAccount)
               .withManifestArtifact(expectedRsArtifact)
               .withMoniker(moniker)
               .withRequisiteStages([stage1])
               .withSkipExpressionEvaluation(false)
               .withOverrideTimeout(300000)
               .withTrafficManagement(enableTrafficManagement);


sponnet.pipeline()
.withExpectedArtifacts([])
.withKeepWaitingPipelines(true)
.withLimitConcurrent(true)
.withParameters([])
.withRoles(['gcp-adminpod-sre'])
.withStages([stage1, stage2, stage3])
.withTriggers([])
