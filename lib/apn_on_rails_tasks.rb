Dir.glob(File.join(File.dirname(__FILE__), 'apn_on_rails', 'tasks', '**/*.rake')).each do |f|
  load File.expand_path(f)
end