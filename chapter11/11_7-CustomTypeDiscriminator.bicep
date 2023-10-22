// 11_7-CustomTypeDiscriminator.bicep

type ssh = {
  type: 'ssh'

  @description('SSH key for authentication')
  value: string
}

type password = {
  type: 'passwd'

  @description('User password for authentication')
  @minLength(12)
  @secure()
  value: string
}

@discriminator('type')
type authConfig = ssh | password 

param vmAuthConfig authConfig = { type: 'passwd', value: '@dm1n1234123456' }

output config object = vmAuthConfig
