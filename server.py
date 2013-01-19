import socket, struct, time
from pymouse import PyMouse
m = PyMouse()

s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.bind(('', 1337))
s.listen(1)

conn, addr = s.accept()
print "Connected..."

while 1:
    x, y = m.position()
    conn.send(struct.pack("=LL", x, y))
    conn.recv(1)
    #time.sleep(1/30.)
conn.close()
