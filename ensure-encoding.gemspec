# frozen_string_literal: true

require 'rake'

Gem::Specification.new do |spec|
  spec.name = 'ensure-encoding'
  spec.version = '0.2'

  spec.author = 'Manfred Stienstra'
  spec.email = 'manfred@fngtps.com'

  spec.description = <<-DESCRIPTION
    Ensure the character encoding in Strings coming from untrusted sources.
  DESCRIPTION
  spec.summary = <<-SUMMARY
    Ensure the character encoding in Strings coming from untrusted sources.
  SUMMARY

  spec.files = FileList['README.rdoc', 'LICENSE', 'lib/**/*.rb'].to_a

  spec.extra_rdoc_files = ['README.rdoc', 'LICENSE']
  spec.rdoc_options << '--all' << '--charset' << 'utf-8'
  spec.metadata['rubygems_mfa_required'] = 'true'

  spec.required_ruby_version = '>= 2.0'
end
