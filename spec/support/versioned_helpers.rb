# Versioning

# Returns the path with options[:version] prefixed if options[:using] is :path.
# Returns normal path otherwise.
def versioned_path(options = {})
  case options[:using]
  when :path
    File.join('/', options[:prefix] || '', options[:version], options[:path])
  when :header
    File.join('/', options[:prefix] || '', options[:path])
  else
    raise ArgumentError.new("unknown versioning strategy: #{options[:using]}")
  end
end

def versioned_headers(options)
  case options[:using]
  when :path
    {}  # no-op
  when :header
    {
      'HTTP_ACCEPT' => "application/vnd.#{options[:vendor]}-#{options[:version]}+#{options[:format]}"
    }
  else
    raise ArgumentError.new("unknown versioning strategy: #{options[:using]}")
  end
end

def versioned_get(path, version_name, version_options = {})
  path    = versioned_path(version_options.merge(:version => version_name, :path => path))
  headers = versioned_headers(version_options.merge(:version => version_name))
  get path, {}, headers
end

