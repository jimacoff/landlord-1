roles = ['Owner', 'Admin', 'Normal', 'Restricted']
roles.each do |role_name|
  Landlord::Role.create(key: role_name.downcase, name: role_name)
end
