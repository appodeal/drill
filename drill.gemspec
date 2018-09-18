# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'drill/version'

Gem::Specification.new do |spec|
  spec.name          = 'drill-mailer'
  spec.version       = Drill::VERSION
  spec.authors       = ['Ilya Demukh']
  spec.email         = ['i.demukh@appodeal.com']

  spec.summary       = 'ActionMailer like gem for mandrill'
  spec.description   = 'ActionMailer like gem for mandrill'
  spec.homepage      = 'https://github.com/appodeal/drill'
  spec.license       = 'MIT'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'mandrill-api', '~> 1.0'

  spec.add_development_dependency 'letter_opener', '~> 1.6'
  spec.add_development_dependency 'mail', '~> 2.7'

  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop', '~> 0.0'
end
