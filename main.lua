require "socket"
serial = require "serial"
serial.util = require "serial.util"

c = 0
x, y = 0, 0
start = socket.gettime()

function love.load()
    print ("load")
    local socket = require("socket")
    s = assert(socket.connect("75.155.249.38", 1337))
end

function love.update()
    local xdata = s:receive(4)
    local ydata = s:receive(4)
    x = serial.read.uint32(serial.buffer(xdata), "le")
    y = serial.read.uint32(serial.buffer(ydata), "le")
    s:send("a")
    c = c + 1
    print (c, (socket.gettime() -start))
    print (c/(socket.gettime() -start))
    print (love.timer.getFPS())
end


function love.draw()
    love.graphics.print('Hello World!', x, y)
end
