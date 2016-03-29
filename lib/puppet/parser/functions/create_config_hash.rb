def create_hash(value, user, ensure_entry, entry, home_dir)
  hash = {
    :user   => user,
    :ensure => ensure_entry,
    :entry  => entry
  }

  unless value.nil?
    hash[:value] = value
  end

  unless home_dir.empty?
    hash[:custom_home_dir] = home_dir
  end

  hash
end

module Puppet::Parser::Functions
  newfunction(:create_config_hash, :type => :rvalue) do |args|
    configs      = args[0]
    user         = args[1].to_s
    ensure_entry = args[2].to_s
    hash         = {}
    home_dir     = args[3].nil? ? '' : args[3].to_s

    if configs.is_a? Hash
      configs.each do |entry, value|
        if value.is_a? Hash
          value.each do |key, value|
            value     = value.join ' ' if value.is_a? Array
            cnf_entry = "'#{entry}'.'#{key}'"

            hash["#{cnf_entry}-#{user}-create"] = create_hash value, user, ensure_entry, cnf_entry, home_dir
          end
        else
          if value.is_a? Array
            value = value.join ' '
          end

          hash["#{entry}-#{user}-create"] = create_hash value, user, ensure_entry, entry, home_dir
        end
      end
    else
      configs.each do |value|
        hash["#{value}-#{user}-remove"] = create_hash nil, user, 'absent', value, home_dir
      end
    end

    return hash
  end
end
