require 'rspec'

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'simplecov'
SimpleCov.start

require 'byebug'
require 'airborne'
require 'report_airborne'
require 'webmock'
