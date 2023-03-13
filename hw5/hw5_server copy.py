# Echo server program
import socket
import random
import sys

# HOST = '192.168.43.95'       #RPi         # Symbolic name meaning all available interfaces
HOST = '127.0.0.1'
if(len(sys.argv)>1):
    PORT = int(sys.argv[1])
else:
    PORT = 48000              # Arbitrary non-privileged port
with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
    s.bind((HOST, PORT))
    s.listen(1)
    conn, addr = s.accept()
    with conn:
        print('Server :: connected by', addr)
        secret = random.randint(1,10)
        print("Ans:",secret)
        while True:
            data = conn.recv(1024).decode()
            if data != str(secret):
                if int(data) > secret:
                    conn.send(b"not_pass: smaller")        
                else:
                    conn.send(b"not_pass: bigger")
            else:
                conn.send(b"ghostlike")
                s.close()
                break
            if not data: break
