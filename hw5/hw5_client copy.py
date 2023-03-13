# Echo client program
import socket
import sys

#HOST = '192.168.43.95'    # The remote host  RPi
HOST = '127.0.0.1'
if(len(sys.argv)>1):
    PORT = int(sys.argv[1])
else:
    PORT = 48000              # The same port as used by the server
with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
    s.connect((HOST, PORT))
    msg = input("Guess something:")
    s.send(msg.encode())
    data = s.recv(1024).decode()
    while(repr(data) != "'ghostlike'"):
        print(repr(data))
        msg = input("Guess Again:")
        s.send(msg.encode())
        data = s.recv(1024).decode()
    s.close()
print('Client :: received ', repr(data))
