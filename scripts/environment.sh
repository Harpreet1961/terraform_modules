#####Restrict the production environment so only main can ever use it — this was the one gap left
cat > env-protection.json << 'EOF'
{
  "deployment_branch_policy": {
    "protected_branches": false,
    "custom_branch_policies": true
  }
}
EOF

gh api \
  --method PUT \
  -H "Accept: application/vnd.github+json" \
  /repos/Harpreet1961/terraform_modules/environments/production \
  --input env-protection.json


gh api \
  --method POST \
  -H "Accept: application/vnd.github+json" \
  /repos/Harpreet1961/terraform_modules/environments/production/deployment-branch-policies \
  -f name="main"

gh api /repos/Harpreet1961/terraform_modules/environments/production/deployment-branch-policies
