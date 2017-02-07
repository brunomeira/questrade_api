guard :rspec, cmd: 'bundle exec rspec' do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib/(.+)\.rb$})     { |m| "spec/lib/#{m[1]}_spec.rb" }
  watch(%r{^lib/questrade_api/rest/(.+)\.rb$})     { |m| "spec/questrade_api/rest/#{m[1]}_spec.rb" }
  watch('spec/spec_helper.rb')  { "spec" }
end
