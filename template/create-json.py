#!/usr/bin/env python3

import sys
import os
import json

if len(sys.argv) <= 2:
    print("invalid argument")
    print(sys.argv[0], "[template.json]", "[new.json]")
    sys.exit(1)

application = os.environ['APPLICATION']
provider = os.environ['PROVIDER'].lower()
namespace = os.environ['NAMESPACE'].lower()
service = os.environ['SERVICE_NAME'].lower()
ingress = os.environ['INGRESS_NAME'].lower()

template = json.load(open(sys.argv[1], "r"))
newfile = json.load(open(sys.argv[2], "r"))

if "expectedArtifacts" not in newfile:
    print("expectedArtifacts not defined")
    sys.exit(1)
else:
    template["expectedArtifacts"] = newfile["expectedArtifacts"]
if "triggers" in newfile:
    template["triggers"] = newfile["triggers"]
if "notifications" in newfile:
    template["notifications"] = newfile["notifications"]

manifest = template["expectedArtifacts"][0]["id"]
manifest_rs = template["expectedArtifacts"][1]["id"]
manifest_ing = template["expectedArtifacts"][2]["id"]
manifest_svc_dummy = template["expectedArtifacts"][3]["id"]

result = json.loads(json.dumps(template).
                    replace("${APPLICATION}", application).
                    replace("${PROVIDER}", provider).
                    replace("${NAMESPACE}", namespace).
                    replace("${SERVICE_NAME}", service).
                    replace("${INGRESS_NAME}", ingress).
                    replace("${MANIFEST}", manifest).
                    replace("${MANIFEST_RS}", manifest_rs).
                    replace("${MANIFEST_ING}", manifest_ing).
                    replace("${MANIFEST_SVC_DUMMY}", manifest_svc_dummy)
                    )

json.dump(result, sys.stdout, indent=2)
