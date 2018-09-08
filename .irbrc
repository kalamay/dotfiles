# encoding: utf-8

require 'rubygems'
require 'pp'

require 'irb/completion'
require 'irb/ext/save-history'

module Kernel
  def requiring(lib)
    exists = false
    loaded = false
    begin
      loaded = require lib
      exists = true
    rescue LoadError
    end
    yield if exists && block_given?
    loaded
  end
end

IRB.conf[:PROMPT][:CUSTOM_COLOR] = {
  :PROMPT_I => %Q{\e[0m\e[1;31m#{RUBY_VERSION} \e[1;32m$ \e[0m},  # normal
  :PROMPT_N => %Q{\e[0m\e[0;34m...\e[0m \e[0m\e[1;34m$ \e[0m},              # indenting code
  :PROMPT_C => %Q{\e[0m\e[0;34m...\e[0m \e[0m\e[1;34m$ \e[0m},              # continuing a statement
  :PROMPT_S => %Q{\e[0m\e[0;34m...\e[0m \e[0m\e[1;34m" \e[0m},              # continuing a string
  :RETURN   => %Q{\e[0m\e[0;34m =>\e[0m %s\n}                               # continuing a string
}

IRB.conf[:PROMPT][:CUSTOM] = {
  :PROMPT_I => "#{RUBY_VERSION} $ ",  # normal
  :PROMPT_N => "... $ ",              # indenting code
  :PROMPT_C => "... $ ",              # continuing a statement
  :PROMPT_S => '... " ',              # continuing a string
  :RETURN   => "  => %s\n"            # prefixes output of statement
}

#IRB.conf[:PROMPT_MODE] = Readline::VERSION =~ /editline/i ? :CUSTOM : :CUSTOM_COLOR
IRB.conf[:PROMPT_MODE] = :CUSTOM
IRB.conf[:USE_READLINE] = true
IRB.conf[:AUTO_INDENT] = true
IRB.conf[:SAVE_HISTORY] = 1000
IRB.conf[:HISTORY_PATH] = File::expand_path("~/.irb_history")

if ENV.include?('RAILS_ENV') && !Object.const_defined?('RAILS_DEFAULT_LOGGER')
  require 'logger'
  # log SQL to the Rails console
  Object.const_set('RAILS_DEFAULT_LOGGER', Logger.new(STDOUT))
end

#if defined? Rails
#  IRB.conf[:IRB_RC] = Proc.new do
#    ActiveRecord::Base.logger = Logger.new(STDOUT)
#    ActiveRecord::Base.connection_pool.clear_reloadable_connections!
#
#    #requiring 'hirb' do
#    #  Hirb.enable
#    #end
#  end
#end

def command(name, sys=name, &block)
  instance_eval <<-RUBY, __FILE__, __LINE__+1
    def #{name}(*args)
      cmd = args.empty? ?
              '#{sys}' :
              %Q[#{sys} '\#{args.join("' '")}']
      system(cmd)
      status = $?.exited? ? $?.exitstatus : $?.stopped? ? 'stopped' : 'running'
      puts "\npid: \#{$?.pid}, status: \#{status}"
      $?.success?
    end
  RUBY
end

command 'ls', 'ls -G'
command 'll', 'ls -Gl'
command 'la', 'ls -Gla'
command 'tree', 'tree'

def pwd
  puts Dir.pwd
end

def cd(to='~')
  Dir.chdir File.expand_path(to)
  pwd
end

def bm(count=10000, &block)
  require 'benchmark'
  Benchmark.bm do |b|
    b.report { count.times &block }
  end
end
