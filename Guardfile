# rubocop:disable Style/RegexpLiteral

guard :rubocop do
  watch(%r{.+\.rb$})
  watch(%r{(?:.+/)?\.rubocop\.yml$}) { |m| File.dirname(m[0]) }
end

guard :shell do
  watch(/.*/) { `git add --all` }
end

guard 'rake', :task => 'install' do
  watch(%r{^lib/.*\.rb})
  watch(%r{^.*\.gemspec})
  watch(%r{^Gemfile$})
end
