#!/bin/bash

# This script deploys a Bicep template to create a resource group and then creates an Azure AD App registration.
# Usage: ./deploy.sh <resource-group-name> <location> <app-name>

# Check if the correct number of arguments are passed
if [ "$#" -ne 8 ]; then
    echo "Usage: $0 <subscriptionid> <resource-group-name> <location> <ad-app-name> <org> <repo> <branch> <webappname>"
    exit 1
fi

# Parameters
subscriptionId=$1
resourceGroupName=$2
location=$3
adAppName=$4
org=$5
repo=$6
branch=$7
webAppName=$8


# Deploy the Bicep template to create the resource group
echo "Deploying Bicep template to create resource group..."
az deployment sub create --location $location --template-file main.bicep --parameters resourceGroupName=$resourceGroupName location=$location webappname=$webAppName --debug
# Check if the deployment was successful
if [ $? -ne 0 ]; then
    echo "Failed to deploy the Bicep template."
    exit 1
fi

# Create the Azure AD App registration
echo "Creating Azure AD App registration..."
appId=$(az ad app create --display-name $adAppName --query appId --output tsv)

# Check if the app registration was successful
if [ $? -ne 0 ]; then
    echo "Failed to create Azure AD App registration."
    exit 1
fi

# Create the service principal for the Azure AD App
echo "Creating service principal for the Azure AD App..."
az ad sp create --id $appId

# Check if the service principal creation was successful
if [ $? -ne 0 ]; then
    echo "Failed to create service principal."
    exit 1
fi

# Create a new federated credential for GitHub Actions for deploying directly to main branch
echo "Creating federated credential for main branch deployment"
az ad app federated-credential create --id $appId --parameters '{
  "name": "github-actions-presentation-2025-cred1",
  "issuer": "https://token.actions.githubusercontent.com",
  "subject": "repo:'$org'/'$repo':ref:refs/heads/'$branch'",
  "audiences": ["api://AzureADTokenExchange"]
}'

# Check if the federated credential creation was successful
if [ $? -ne 0 ]; then
    echo "Failed to create federated credential."
    exit 1
fi

# Create a new federated credential for GitHub Actions for targeting DEV Environment
echo "Creating federated credential for targeting DEV environment"
az ad app federated-credential create --id $appId --parameters '{
  "name": "github-actions-presentation-2025-dev",
  "issuer": "https://token.actions.githubusercontent.com",
  "subject": "repo:'$org'/'$repo':environment:DEV",
  "audiences": ["api://AzureADTokenExchange"]
}'

# Check if the federated credential creation was successful
if [ $? -ne 0 ]; then
    echo "Failed to create federated credential."
    exit 1
fi

# Create a new federated credential for GitHub Actions for targeting STAGING Environment
echo "Creating federated credential for targeting STAGING environment"
az ad app federated-credential create --id $appId --parameters '{
  "name": "github-actions-presentation-2025-staging",
  "issuer": "https://token.actions.githubusercontent.com",
  "subject": "repo:'$org'/'$repo':environment:STAGING",
  "audiences": ["api://AzureADTokenExchange"]
}'

# Check if the federated credential creation was successful
if [ $? -ne 0 ]; then
    echo "Failed to create federated credential."
    exit 1
fi

# Create a new federated credential for GitHub Actions for targeting PROD Environment
echo "Creating federated credential for targeting PROD environment"
az ad app federated-credential create --id $appId --parameters '{
  "name": "github-actions-presentation-2025-prod",
  "issuer": "https://token.actions.githubusercontent.com",
  "subject": "repo:'$org'/'$repo':environment:PROD",
  "audiences": ["api://AzureADTokenExchange"]
}'

# Check if the federated credential creation was successful
if [ $? -ne 0 ]; then
    echo "Failed to create federated credential."
    exit 1
fi

# Assign Contributor role to the Azure AD App for the resource group
echo "Assigning Contributor role to the Azure AD App for the resource group..."
az role assignment create --assignee $appId --role Contributor --scope /subscriptions/$subscriptionId/resourceGroups/$resourceGroupName

# Check if the role assignment was successful
if [ $? -ne 0 ]; then
    echo "Failed to assign Contributor role."
    exit 1
fi

# Add the appId to a repository-level secret called AZURE_CLIENT_ID
echo "Adding AZURE_CLIENT_ID secret to the repository"
gh secret set AZURE_CLIENT_ID --body "$appId" --repo "$org/$repo"

# Check if setting the secret was successful
if [ $? -ne 0 ]; then
    echo "Failed to set AZURE_CLIENT_ID secret."
    exit 1
fi

# Add code that uses gh to see if the DEV, STAGING, and PROD environments exist. If they do not exist, create them
# Function to check if an environment exists and create it if it does not
create_environment_if_not_exists() {
    local env_name=$1
    echo "Checking if environment $env_name exists..."
    if ! gh api repos/$org/$repo/environments/$env_name --silent; then
        echo "Environment $env_name does not exist. Creating it..."
        gh api repos/$org/$repo/environments/$env_name --method PUT --silent
        if [ $? -ne 0 ]; then
            echo "Failed to create environment $env_name."
            exit 1
        fi
    else
        echo "Environment $env_name already exists."
    fi
}

# Check and create environments if they do not exist
create_environment_if_not_exists "DEV"
create_environment_if_not_exists "STAGING"
create_environment_if_not_exists "PROD"


echo "Deployment, Azure AD App registration, federated credential creation, and role assignment completed successfully."