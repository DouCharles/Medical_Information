# Echo client program
import socket
import sys

HOST = '192.168.43.95'    # The remote host  RPi
#HOST = '127.0.0.1'
if(len(sys.argv)>1):
    PORT = int(sys.argv[1])
else:
    PORT = 48000              # The same port as used by the server
with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
    s.connect((HOST, PORT))
    mode = input ("Please choose mode  (1)Playing guessing game, (2)Chatting Robot : ")
    s.send(mode.encode())
    if mode != "2" and mode != "1":
        print("in")
        mode = "1"
    if mode == "1":
        msg = input("Client : ")
        s.send(msg.encode())
        data = s.recv(1024).decode()
        while(repr(data) != "'Bingo!'"):
            print(repr(data))
            msg = input("Client : ")
            s.send(msg.encode())
            data = s.recv(1024).decode()
        s.close()
        print(repr(data))
    elif mode == "2":
        msg = input ("Say Something : ")
        s.send(msg.encode())
        data = s.recv(1024).decode()
        print(repr(data))
        s.close()

