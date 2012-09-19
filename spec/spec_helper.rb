$: << File.expand_path('../lib', File.dirname(__FILE__))

ENV['GAMESOCKET_TEST_PORT1'] ||= '12345'
raise "Please specify a valid GAMESOCKET_TEST_PORT1" unless ENV['GAMESOCKET_TEST_PORT1'].to_i > 0
