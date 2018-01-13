#!/bin/sh

# only execute this script as part of the pipeline.
[ -z "$CI" ] && echo "I am not running in Drone CI" && exit 2

# only execute the script when the client key and certificate exist.
[ -z "$DEV_KEY" ] && echo "I need dev_key secret" && exit 3
[ -z "$DEV_CRT" ] && echo "I need dev_crt secret" && exit 4

# write the client key and the certificate
echo -n "$DEV_KEY" > /root/dev.key
chmod 600 /root/dev.key
echo -n "$DEV_CRT" > /root/dev.crt

# write the Kubernetes CA
K8S_CA="-----BEGIN CERTIFICATE-----
MIICyDCCAbCgAwIBAgIBADANBgkqhkiG9w0BAQsFADAVMRMwEQYDVQQDEwprdWJl
cm5ldGVzMB4XDTE4MDExMTE5MzYxNFoXDTI4MDEwOTE5MzYxNFowFTETMBEGA1UE
AxMKa3ViZXJuZXRlczCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAM0m
uEVv6PfL8vtllB/3Ur5M6oV4TBL4yTfcEd1UPKz1JVeoI06WTdoxFNZmt3ixkzzP
LWo3TBjOfYvWYC2Sz0OffnUVUDdOaycdjxTHudc7ZGEl0OytjBOALqngn+vtxS7h
uFcFWdqbPQbqn4lTRzmOhdeNdMCa9Oh+4/PZrlg+EGiwb809mYblFDFUSv9JpYky
xCv4zYubCEvF6BRqGqYDQTsDz7mO0fsBCjwdxCX3PhgTDnLTrffgjwjwqOuI6JTO
H9lb85sHL/ljbh+z9remmg9FLEuSRQ9e2P1EKWd11g4BaH0g+Oa7S+U83DBJCBA1
+phbLKp0jkCVwajoMMsCAwEAAaMjMCEwDgYDVR0PAQH/BAQDAgKkMA8GA1UdEwEB
/wQFMAMBAf8wDQYJKoZIhvcNAQELBQADggEBAGwGEtbcvl5kcNvWshgcFciNKAR3
Q6LZCovbHvIKz/Z2MTsbwmOfS01toeRTDdRtDMUWUm8yc5R/SjxHO3SKl90JVVbx
E6RaGP1op6GKRSHN/odDT/PRSUUULzmV5FfoS+BUaucDgIiotd8NqBqBdgaJvg9Q
ui02qUKGK5htQFxNi1uF2ex/WNrywmJjGSlGCp12oYfDMCvXAZoLWDh05HRxmdSr
KgV2R/oDRpkGFRLseS/ZF/UK9bIuvLAuV2z9fy2Xlnfdxl6zoiKPut9MyuPD6+Ox
RYTK8CNwUfxJ+kHLwozqlNUT0H0THU4Di6DhzXBlU9KD9/xQmutwoUVGo04=
-----END CERTIFICATE-----"
echo -n "$K8S_CA" > /root/ca.crt

set -e
set -x

# Configure the cluster and the context
kubectl config set-credentials dev --client-certificate=/root/dev.crt --client-key=/root/dev.key
kubectl config set-cluster nixaid --server=https://k8s.nixaid.com:6443 --certificate-authority=/root/ca.crt
kubectl config set-context dev-context --cluster=nixaid --namespace=devns --user=dev
