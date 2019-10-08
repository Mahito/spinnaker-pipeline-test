local sponnet = import '../sponnet/pipeline.libsonnet';

sponnet.artifacts
.githubFile()
.withVersion('${ trigger.tag }')
