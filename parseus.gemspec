lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'parseus/version'

Gem::Specification.new do |spec|
  spec.name          = 'parseus'
  spec.version       = Parseus::VERSION
  spec.authors       = ['Adam Ruzicka']
  spec.email         = ['a.ruzicka@outlook.com']

  spec.summary       = 'A parser combinator library'
  spec.homepage      = 'https://github.com/adamruzicka/parseus'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.16.a'
  spec.add_development_dependency 'minitest', '~> 5.0'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rubocop', '~> 0.57.2'
end
