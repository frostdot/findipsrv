# coding: utf-8

require 'socket'
require 'syslog'

module FindIPSrv
  class Server
    def self.start(port = 12440)
      @udp_sock = UDPSocket.open
      @udp_sock.setsockopt(Socket::SOL_SOCKET, Socket::SO_BROADCAST, 1)
      @udp_sock.setsockopt(Socket::SOL_SOCKET, Socket::SO_REUSEADDR , true)
      @udp_sock.bind("", port)
      Syslog.open 'findipsrv'
      Syslog.info "Starting Find IP Service(port:#{port})..."

      t = Thread.new(@udp_sock) do |s|
        while true
          msg, sockaddr = s.recvfrom(65536)
          host = sockaddr[2]
          ip = sockaddr[3]

          if msg == "find"
            @udp_sock.send("ACK", 0, host, port)
            Syslog.info "found by #{ip}"
          end
        end
      end
      t.abort_on_exception = true
      
      begin
        t.join
      rescue Interrupt
        t.kill if t.alive?
        Syslog.info "Exiting Find IP Service"
        Syslog.close
      end
    end
  end
end

