#!/bin/bash

curl -O -L "https://github.com/sigstore/cosign/releases/latest/download/cosign-linux-amd64"

mv cosign-linux-amd64 /opt/bin/cosign

chmod +x /opt/bin/cosign
