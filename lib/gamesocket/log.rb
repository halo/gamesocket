require 'logger'
require 'singleton'

module GameSocket
  class Log

    include ::Singleton

    attr_reader :logger

    def initialize
      @logger = Logger.new(STDOUT)
      @logger.level = Logger::Severity::FATAL
      @logger.datetime_format = "%Y-%m-%d %H:%M:%S"
      @logger.formatter = proc do |severity, datetime, progname, msg|
        caller_name = @logger.debug? ? ' ' + caller[5].split('/').last.sub('in `', '')[0...-1] : nil
        "#{datetime.strftime('%Y-%m-%d %H:%M:%S')} #{severity.upcase}#{caller_name} - #{msg}\n"
      end
    end

    # Delegate everything to the logger instance
    def self.method_missing(*args, &block)
      instance.logger.send(*args, &block)
    end

  end
end