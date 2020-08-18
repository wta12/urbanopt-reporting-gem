
lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'urbanopt/reporting/version'

Gem::Specification.new do |spec|
  spec.name          = 'urbanopt-reporting'
  spec.version       = URBANopt::Reporting::VERSION
  spec.authors       = ['Rawad El Kontar', 'Dan Macumber']
  spec.email         = ['rawad.elkontar@nrel.gov']

  spec.summary       = 'Library to report URBANopt results'
  spec.description   = 'Library include scenario default reporting measure and scenario defaults reports schema and classes'
  spec.homepage      = 'https://github.com/urbanopt'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|lib.measures.*tests|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']
  spec.required_ruby_version = '~> 2.5.0'

  spec.add_development_dependency 'bundler', '~> 2.1'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rspec', '~> 3.7'

  spec.add_dependency 'json-schema'
  spec.add_dependency 'json_pure'
  spec.add_dependency 'openstudio-extension', '~> 0.2.3'
end
