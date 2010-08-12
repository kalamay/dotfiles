# encoding: utf-8

require 'pp'
require 'rubygems'

require 'irb/completion'
require 'irb/ext/save-history'

module Kernel
  def using(lib)
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

IRB.conf[:PROMPT][:CUSTOM] = {
  :PROMPT_I => "#{RUBY_VERSION} ❯ ",      # normal
  :PROMPT_N => "... ❯ ",      # indenting code
  :PROMPT_C => "... ❯ ",      # continuing a statement
  :PROMPT_S => '... " ',      # continuing a string
  :RETURN   => "  => %s\n"    # prefixes output of statement
}

IRB.conf[:PROMPT_MODE] = :CUSTOM
IRB.conf[:USE_READLINE] = true
IRB.conf[:AUTO_INDENT] = true
IRB.conf[:SAVE_HISTORY] = 1000
IRB.conf[:HISTORY_PATH] = File::expand_path("~/.irb_history")

using 'sketches' do
  Sketches.config :editor => 'gvim'
end

using 'looksee/shortcuts'

if ENV.include?('RAILS_ENV')
  IRB.conf[:IRB_RC] = Proc.new do
    ActiveRecord::Base.logger = Logger.new(STDOUT)
    ActiveRecord::Base.connection_pool.clear_reloadable_connections!

    using 'hirb' do
      Hirb.enable
    end
  end
end


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
