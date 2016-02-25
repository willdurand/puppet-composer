def create_hash(value, user, ensure_entry, entry)
  hash = {
    :user   => user,
    :ensure => ensure_entry,
    :entry  => entry
  }

  unless value.nil?
    hash[:value] = value
  end

  hash
end

module Puppet::Parser::Functions
  newfunction(:create_config_hash, :type => :rvalue) do |args|
    configs      = args[0]
    user         = args[1].to_s
    ensure_entry = args[2].to_s
    hash         = {}

    if configs.is_a? Hash
      configs.each do |entry, value|
        if value.is_a? Hash
          value.each do |key, value|
            value  = value.join ' ' if value.is_a? Array
            entry  = "'#{entry}'.'#{key}'"

            hash["#{entry}-#{user}-create"] = create_hash value, user, ensure_entry, entry
          end
        else
          if value.is_a? Array
            value = value.join ' '
          end

          hash["#{entry}-#{user}-create"] = create_hash value, user, ensure_entry, entry
        end
      end
    else
      configs.each do |value|
        hash["#{value}-#{user}-remove"] = create_hash nil, user, 'absent', value
      end
    end

    return hash
  end
end
