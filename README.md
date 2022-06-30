## logicapps ##

This is a basic terraform repo to deploy a logic app and some associated resources to Azure via an Azure DevOps pipeline

The logic app will run on a schedule, retrieve a secret from an Azure KeyVault, call a REST API and store the JSON response in an Azure Blob