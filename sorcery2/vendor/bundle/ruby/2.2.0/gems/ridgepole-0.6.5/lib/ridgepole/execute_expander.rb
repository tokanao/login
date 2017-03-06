class Ridgepole::ExecuteExpander
  class Stub
    def method_missing(method_name, *args, &block)
      # Nothing to do
    end
  end

  module ConnectionAdapterExt
    def execute(sql, name = nil)
      if Ridgepole::ExecuteExpander.noop
        if (callback = Ridgepole::ExecuteExpander.callback)
          sql = append_alter_extra(sql)
          callback.call(sql, name)
        end

        if sql =~ /\A(SELECT|SHOW)\b/i
          begin
            super(sql, name)
          rescue
            Stub.new
          end
        else
          Stub.new
        end
      elsif Ridgepole::ExecuteExpander.use_script
        if sql =~ /\A(SELECT|SHOW)\b/i
          super(sql, name)
        else
          sql = append_alter_extra(sql)
          Ridgepole::ExecuteExpander.sql_executer.execute(sql)
          nil
        end
      else
        sql = append_alter_extra(sql)
        super(sql, name)
      end
    end

    private

    def append_alter_extra(sql)
      if Ridgepole::ExecuteExpander.alter_extra and sql =~ /\AALTER\b/i
        sql = sql + ',' + Ridgepole::ExecuteExpander.alter_extra
      end

      sql
    end
  end

  cattr_accessor :noop,         :instance_writer => false, :instance_reader => false
  cattr_accessor :callback,     :instance_writer => false, :instance_reader => false
  cattr_accessor :use_script,   :instance_writer => false, :instance_reader => false
  cattr_accessor :sql_executer, :instance_writer => false, :instance_reader => false
  cattr_accessor :alter_extra,  :instance_writer => false, :instance_reader => false

  class << self
    def without_operation(callback = nil)
      begin
        self.noop = true
        self.callback = callback
        yield
      ensure
        self.noop = false
        self.callback = nil
      end
    end

    def with_script(script, logger)
      begin
        self.use_script = true
        self.sql_executer = Ridgepole::ExternalSqlExecuter.new(script, logger)
        yield
      ensure
        self.use_script = false
        self.sql_executer = nil
      end
    end

    def with_alter_extra(extra)
      begin
        self.alter_extra = extra
        yield
      ensure
        self.alter_extra = nil
      end
    end

    def expand_execute(connection)
      return if connection.is_a?(ConnectionAdapterExt)

      connection.class_eval do
        prepend ConnectionAdapterExt
      end
    end
  end # of class methods
end
