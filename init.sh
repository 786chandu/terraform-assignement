#!/bin/bash

set -ex

SUBSCRIPTION_ID=$1
ENVIRONMENT="test"
APPLICATION="task"
RESOURCE_GROUP_NAME="$APPLICATION-$ENVIRONMENT-rg"
STORAGE_ACCOUNT_NAME="$APPLICATION-$ENVIRONMENT-tf"
CONTAINER_NAME="terraform-state"
Location="centralindia"

# Set the passed in subscription as the current subscription
az account set -s $SUBSCRIPTION_ID

# Remove hypens
__STORAGE_ACCOUNT_NAME=$(echo $STORAGE_ACCOUNT_NAME | sed -e 's/-//g')

# Create resource group 
az group create --name $RESOURCE_GROUP_NAME --location $Location

# Create Storage Account
az storage account create --resource-group  $RESOURCE_GROUP_NAME --name $__STORAGE_ACCOUNT_NAME --sku Standard_LRS --encryption-services blob || az storage account show --resource-group $RESOURCE_GROUP_NAME --name $__STORAGE_ACCOUNT_NAME

# Get Storage account key 
ACCOUNT_KEY=$(az storage account keys list --resource-group $RESOURCE_GROUP_NAME --account-name $__STORAGE_ACCOUNT_NAME --query '[0].value' -o tsv )

# Create blob container for dev
az storage container create --name $CONTAINER_NAME --account-name $__STORAGE_ACCOUNT_NAME --account-key $ACCOUNT_KEY
