require 'amazon/ecs'

require "#{File.dirname(__FILE__)}/check_rails.rb"


# ben@beneills.com secrets
Amazon::Ecs.options = {
  :associate_tag => 'hash0e-21',
  :AWS_access_key_id => 'AKIAJ3VAUXSMBNNFMEUQ',
  :AWS_secret_key => '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',
}
