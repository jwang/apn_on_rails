# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{apn_on_rails}
  s.version = "0.1.0.20090724114507"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["markbates"]
  s.date = %q{2009-07-24}
  s.description = %q{apn_on_rails was developed by: markbates}
  s.email = %q{}
  s.extra_rdoc_files = ["README", "LICENSE"]
  s.files = ["lib/apn_on_rails/apn_on_rails.rb", "lib/apn_on_rails/app/models/apn/device.rb", "lib/apn_on_rails/app/models/apn/notification.rb", "lib/apn_on_rails/db/migrate/20090723132058_create_apn_devices.rb", "lib/apn_on_rails/db/migrate/20090723132059_create_apn_notifications.rb", "lib/apn_on_rails/tasks/apn.rake", "lib/apn_on_rails/tasks/db.rake", "lib/apn_on_rails.rb", "lib/apn_on_rails_tasks.rb", "README", "LICENSE"]
  s.homepage = %q{}
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{magrathea}
  s.rubygems_version = %q{1.3.4}
  s.summary = %q{apn_on_rails}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<configatron>, [">= 0"])
    else
      s.add_dependency(%q<configatron>, [">= 0"])
    end
  else
    s.add_dependency(%q<configatron>, [">= 0"])
  end
end
