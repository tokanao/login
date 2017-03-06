class Ridgepole::Logger < ::Logger
  include Singleton
  cattr_accessor :verbose

  def initialize
    super($stdout)

    self.formatter = proc do |severity, datetime, progname, msg|
      "#{msg}\n"
    end

    self.level = Logger::INFO
  end

  def verbose_info(msg)
    info(msg) if verbose
  end

  def set_debug(value)
    self.level = value ? Logger::DEBUG : Logger::INFO
  end
end
