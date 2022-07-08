az group create --name bicep --location eastus

az ad sp create-for-rbac --name  bicepcicd \
                         --role contributor \
                         --scopes /subscriptions/<subscriptionId>/resourceGroups/bicep \
                         --query "{clientId:appId, clientSecret:password, tenantId:tenant, subscriptionId:'<subscriptionId>'}"