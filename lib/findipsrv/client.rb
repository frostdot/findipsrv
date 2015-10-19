# coding: utf-8

require 'socket'

module FindIPSrv
  class Client
    def self.find(port = 12440, timeout = 4)
      @udp_sock = UDPSocket.open
      @udp_sock.setsockopt(Socket::SOL_SOCKET, Socket::SO_BROADCAST, 1)
      @udp_sock.setsockopt(Socket::SOL_SOCKET, Socket::SO_REUSEADDR , true)

      @udp_sock.bind("", port)

      t = Thread.new(@udp_sock) do |s|
        while true
          msg, sockaddr = s.recvfrom(65536)
          host = sockaddr[2]
          ip = sockaddr[3]

          unless msg == "find"
            puts "Found!: #{ip}"
          end
        end
      end
      t.abort_on_exception = true

      begin
        @udp_sock.send("find", 0, "255.255.255.255", port)
        if t.join(timeout).nil?
          #puts "Could not find..."
          raise Interrupt
        end
      rescue Interrupt
        t.kill if t.alive?
      end
    end
  end
end


