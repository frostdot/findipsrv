# coding: utf-8

require 'thor'
require 'findipsrv/client.rb'

module FindIPSrv
  class CLI < Thor
    class_option :help, :type => :boolean, :aliases => '-h', :desc => 'help'
    default_task :find

    class_option :port, :type => :numeric, :aliases => '-p', :desc => 'Uses port(default: 12440)'
    class_option :timeout, :type => :numeric, :aliases => '-t', :desc => 'Search timeout(default: 4)[sec]'
    desc "find", "Find service"
    def find
      port = options[:port] || 12440
      timeout = options[:timeout] || 4
      FindIPSrv::Client.find(port, timeout)
    end
  end
end
