#!/usr/bin/env bash
set -euo pipefail

# ==============================================================================
# GitHub OIDC -> AWS IAM setup script
# Repo:   Harpreet1961/terraform_modules
# Branch: dev
# ==============================================================================

REPO="Harpreet1961/terraform_modules"
BRANCH="dev"
ROLE_NAME="github-actions-terraform-modules-dev"
POLICY_NAME="github-actions-terraform-modules-policy"
OIDC_URL="https://token.actions.githubusercontent.com"
THUMBPRINT="6938fd4d98bab03faadb97b34396831e3780aea1"
WORKDIR="$(mktemp -d)"

echo "==> Confirming AWS identity..."
ACCOUNT_ID=$(aws sts get-caller-identity --query 'Account' --output text)
echo "    Account ID: ${ACCOUNT_ID}"

OIDC_PROVIDER_ARN="arn:aws:iam::${ACCOUNT_ID}:oidc-provider/token.actions.githubusercontent.com"

# ------------------------------------------------------------------------------
# Step 1: Create (or reuse) the OIDC provider
# ------------------------------------------------------------------------------
echo "==> Checking for existing GitHub OIDC provider..."
if aws iam list-open-id-connect-providers --output text | grep -q "token.actions.githubusercontent.com"; then
  echo "    OIDC provider already exists. Skipping creation."
else
  echo "    Creating OIDC provider..."
  aws iam create-open-id-connect-provider \
    --url "${OIDC_URL}" \
    --client-id-list sts.amazonaws.com \
    --thumbprint-list "${THUMBPRINT}"
  echo "    Created: ${OIDC_PROVIDER_ARN}"
fi

# ------------------------------------------------------------------------------
# Step 2: Write the trust policy (scoped to repo + branch)
# ------------------------------------------------------------------------------
echo "==> Writing trust policy..."
cat > "${WORKDIR}/trust-policy.json" <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Federated": "${OIDC_PROVIDER_ARN}"
      },
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Condition": {
        "StringEquals": {
          "token.actions.githubusercontent.com:aud": "sts.amazonaws.com"
        },
        "StringLike": {
          "token.actions.githubusercontent.com:sub": "repo:${REPO}:ref:refs/heads/${BRANCH}"
        }
      }
    }
  ]
}
EOF

# ------------------------------------------------------------------------------
# Step 3: Create (or update) the IAM role
# ------------------------------------------------------------------------------
echo "==> Creating IAM role: ${ROLE_NAME}..."
if aws iam get-role --role-name "${ROLE_NAME}" >/dev/null 2>&1; then
  echo "    Role already exists. Updating trust policy..."
  aws iam update-assume-role-policy \
    --role-name "${ROLE_NAME}" \
    --policy-document "file://${WORKDIR}/trust-policy.json"
else
  aws iam create-role \
    --role-name "${ROLE_NAME}" \
    --assume-role-policy-document "file://${WORKDIR}/trust-policy.json" \
    --description "Role for GitHub Actions OIDC - ${REPO} (${BRANCH} branch)"
fi

# ------------------------------------------------------------------------------
# Step 4: Attach permissions policy
#   Default: PowerUserAccess (fine for a sandbox/training account).
#   For production, replace this block with a custom least-privilege policy.
# ------------------------------------------------------------------------------
echo "==> Attaching permissions policy..."
aws iam attach-role-policy \
  --role-name "${ROLE_NAME}" \
  --policy-arn arn:aws:iam::aws:policy/PowerUserAccess

# ------------------------------------------------------------------------------
# Done
# ------------------------------------------------------------------------------
ROLE_ARN=$(aws iam get-role --role-name "${ROLE_NAME}" --query 'Role.Arn' --output text)

echo ""
echo "=============================================================="
echo " Setup complete."
echo "=============================================================="
echo " OIDC Provider ARN : ${OIDC_PROVIDER_ARN}"
echo " Role Name         : ${ROLE_NAME}"
echo " Role ARN          : ${ROLE_ARN}"
echo ""

rm -rf "${WORKDIR}"
