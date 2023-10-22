// 11_9-customTypes.bicep

@export()
@sealed()
type subnetType = {
  name: string
  addressPrefix: string
}
