require 'rake'

Gem::Specification.new do |spec|
  spec.name = 'ensure-encoding'
  spec.version = '0.1'

  spec.author = "Manfred Stienstra"
  spec.email = "manfred@fngtps.com"

  spec.description = <<-EOF
    Ensure the character encoding in Strings coming from untrusted sources.
  EOF
  spec.summary = <<-EOF
    Ensure the character encoding in Strings coming from untrusted sources.
  EOF

  spec.files = FileList['README.rdoc', 'LICENSE', 'lib/**/*.rb'].to_a

  spec.extra_rdoc_files = ['README.rdoc', 'LICENSE']
  spec.rdoc_options << "--all" << "--charset" << "utf-8"
end
