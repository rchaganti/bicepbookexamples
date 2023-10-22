// 11_2-customStringAllowedValues.bicep

// define a custom type
type storageAccountType = 'Standard_LRS' | 'Standard_GRS'

// define a parameter of new custom type
param newStorageType storageAccountType = 'Standard_ZRS'

// output the value of custom type parameter 
output typeOfStorage storageAccountType = newStorageType
