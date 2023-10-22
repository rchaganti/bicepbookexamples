// 11_1-customStringType.bicep

// define a custom type
type storageAccountType = string

// define a parameter of new custom type
param newStorageType storageAccountType = 'Standard_LRS'

// output the value of custom type parameter 
output typeOfStorage storageAccountType = newStorageType
