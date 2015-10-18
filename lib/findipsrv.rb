# coding: utf-8

require 'thor'
require 'findipsrv/srv.rb'

module FindIPSrv
  class CLI < Thor
    class_option :help, :type => :boolean, :aliases => '-h', :desc => 'help'
    default_task :execute

    class_option :port, :type => :numeric, :aliases => '-p', :desc => 'Uses port(default: 12440)'
    desc "exec", "execute service"
    def execute
      port = options[:port] || 12440
      FindIPSrv::Server.start(port)
    end
  end
end
