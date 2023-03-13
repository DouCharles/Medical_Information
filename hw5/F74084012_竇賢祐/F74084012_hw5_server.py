# Echo server program
import socket
import random
import sys

HOST = '192.168.43.95'       #RPi         # Symbolic name meaning all available interfaces
#HOST = '127.0.0.1'
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
        mode = conn.recv(1024).decode()
        if mode == "1":
            secret = random.randint(1,10)
            print("Ans:",secret)
            while True:
                data = conn.recv(1024).decode()
                if data != str(secret):
                    if int(data) > secret:
                        conn.send(b"X < %d"%(int(data)))        
                    else:
                        conn.send(b"X > %d"%(int(data)))
                else:
                    conn.send(b"Bingo!")
                    s.close()
                    break
                if not data: break
        elif mode == "2": # chatting Robot
            msg = conn.recv(1024).decode()
            for i in range(len(msg)-4):
                if msg[i:i+5] == "Hello" or msg[i:i+5] == "hello":
                    conn.send(b"Hello, my name is Bob. Nice to meet you")
                    break
                elif msg[i:i+5] == "angry":
                    conn.send(b"I'm sorry to hear you're upset. Let me know if there's anything I can do to help!")
                    break
                elif msg[i:i+5] == "happy":
                    conn.send(b"Sounds like life is treating you right!")
            s.close()



