e#!/bin/bash
##Create a SQL API Cosmos DB account, DB in it, collection################
az='/home/buntu/anaconda3/envs/env34/bin/az'
resourceGroupName='documdbrg'
location='eastus'
name='lenadocumentdbdemo'   #account name
databaseName='test-docdb'
collectionName='docdbcollection1'
originalThroughput=400 
newThroughput=700



#Create a resource group
echo "Creating a resource group..."
	$az group create --name $resourceGroupName --location $location >/dev/null 2>&1
	if [ $? -ne 0 ]
	then
		echo "ERROR: Resource Group creation failed."
		exit 1
	fi
	$az group list | grep -i $resourceGroupName
echo "Success."
echo "_________________________________________________"
echo ""



#Create a SQL API Cosmos DB account
echo "Creating SQL API GlobalDB, which is DocumentDB,  account..."
	$az cosmosdb create \
	    --name $name \
	    --locations "East US"=0 "East US 2"=1 \
	    --kind GlobalDocumentDB \
	    --resource-group $resourceGroupName \
	    --max-interval 10 \
	    --max-staleness-prefix 200 >/dev/null 2>&1
	if [ $? -ne 0 ]
	then
		echo "ERROR: Account creation failed. Check parameters."
		exit 1
	fi
	$az cosmosdb show --name $name --resource-group $resourceGroupName | grep provisioningState
echo "Success."
echo "_________________________________________________"
echo ""



#Create a database 
echo "Creating a database in it..."
	$az cosmosdb database create \
	    --name $name \
	    --db-name $databaseName \
	    --resource-group $resourceGroupName >/dev/null 2>&1
	if [ $? -ne 0 ]
	then
		echo "ERROR: Database creation failed."
		exit 1
	fi
	$az cosmosdb database show \
		--db-name $databaseName \
	    --name $name \
	    --resource-group-name $resourceGroupName \
	    | grep -w 'id' | awk '{print $2}'
echo "Success."
echo "_________________________________________________"
echo ""



#Create a collection
echo "Creating a collection within the database..."
	$az cosmosdb collection create \
	    --collection-name $collectionName \
	    --name $name \
	    --db-name $databaseName \
	    --resource-group $resourceGroupName \
	    --throughput $originalThroughput >/dev/null 2>&1
	if [ $? -ne 0 ]
	then
		echo "ERROR: Collection creation failed."
		exit 1
	fi
	$az cosmosdb collection show --collection-name $collectionName \
	        --db-name $databaseName \
	        --name $name \
	        --resource-group-name $resourceGroupName \
	        | grep -w 'id' | head -n1
echo "Success."
echo "_________________________________________________"
echo ""



#Scale throughput
echo "Updating this collection's throughput to a new value..."
	$az cosmosdb collection update \
	    --collection-name $collectionName \
	    --name $name \
	    --db-name $databaseName \
	    --resource-group $resourceGroupName \
	    --throughput $newThroughput >/dev/null 2>&1
	if [ $? -ne 0 ]
	then
		echo "ERROR: Throughput update failed."
		exit 1
	fi
echo "Success."
echo "_________________________________________________"	
echo ""



#List this SQL API globalDBAccount URI and primary key
echo "This globalDBAccount's URI is: "
	$az cosmosdb list \
	    --resource-group $resourceGroupName \
	    --query [*].[documentEndpoint] | grep "http*"
echo ""	
echo "This globalDBAccount primary key is: "
	$az cosmosdb list-keys \
	    --name $name \
	    --resource-group $resourceGroupName \
	    | grep primaryMasterKey
echo "_________________________________________________"
echo "Done."
echo ""
