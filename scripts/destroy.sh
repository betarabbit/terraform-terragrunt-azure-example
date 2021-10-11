#!/bin/bash

set -e

usage() {
    cat <<EOF
Infrastructure destroy:
    -e (Required) environment name (daily, staging, production, etc)
    -s (Required) site name (us, eu, aps, etc)
    -c (Optional) component name (app, networking, resource-group, etc), omit this to deploy all components
EOF
    exit 1
}

while getopts "e:s:c:" opt; do
    case $opt in
    e)
        env=$OPTARG
        ;;
    s)
        site=$OPTARG
        ;;
    c)
        component=$OPTARG
        ;;
    *)
        usage
        ;;
    esac
done

# Check the Input parameters
[[ $# -eq 0 || -z $env || -z $site ]] && {
    usage
}

cat <<EOF
environment: $env
site: $site
component: $component
EOF

# Inject environment variables for terraform azure provider
export ARM_CLIENT_ID=$SERVICE_PRINCIPAL_USR
export ARM_CLIENT_SECRET=$SERVICE_PRINCIPAL_PSW
export ARM_SUBSCRIPTION_ID=$SUBSCRIPTION_ID
export ARM_TENANT_ID=$TENANT_ID

echo "=== Login to Azure with $SERVICE_PRINCIPAL_USR ==="
az login \
    --service-principal \
    -u $SERVICE_PRINCIPAL_USR \
    -p $SERVICE_PRINCIPAL_PSW \
    --tenant $TENANT_ID >/dev/null

echo "=== Switch to subscription $SUBSCRIPTION_ID ==="
az account set -s $SUBSCRIPTION_ID >/dev/null

path=$(dirname "$(cd "$(dirname "$0")" && pwd)")

terragrunt run-all destroy \
    --terragrunt-working-dir $path/environments/$env/$site/$component \
    --terragrunt-ignore-external-dependencies
