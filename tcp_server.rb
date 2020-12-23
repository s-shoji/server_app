require "socket"

port = 8001
server = TCPServer.open(port)

def read_html
  File.open("index.html") do |f|
    f.read
  end
end

while true
  Thread.start(server.accept) do |socket|
    p socket.peeraddr

    request = socket.gets
    p request

    if request.include? "GET"
      content = read_html
      socket.write <<-EOF
HTTP/1.1 200 OK
Content-Type: text/html; charset=UTF-8
Server: rserver
Connection: close

#{content}
      EOF
    end

    socket.close
  end
end

server.close