if ENV['CODECLIMATE_REPO_TOKEN']
  require 'codeclimate-test-reporter'
  SimpleCov.formatters = [
      SimpleCov::Formatter::HTMLFormatter,
      CodeClimate::TestReporter::Formatter
  ]
end
SimpleCov.start 'rails'