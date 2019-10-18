local sponnet = import '../../sponnet/pipeline.libsonnet';

local manifestRepo = 'https://api.github.com/repos/tamac-io/bs_mon_gui/contents/';
local artifactName = 'kube/lab2alfa/manifest.yaml';

local manifestArtifact = sponnet.artifacts
                         .githubFile()
                         .withVersion('${ trigger.tag }')
                         .withName(artifactName)
                         .withReference(manifestRepo + artifactName);

local expectedGithubArticactId = '3571386c-6999-426e-aaff-3bbe16ca7a07';

sponnet.expectedArtifact(expectedGithubArticactId)
.withDefaultArtifact(manifestArtifact)
.withDisplayName(artifactName)
.withMatchArtifact(manifestArtifact)
.withUseDefaultArtifact(true)
.withUsePriorArtifact(false)
