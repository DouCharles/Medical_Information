# 客戶端 ，用來呼叫service_Server.py
import socket
import struct
import timeit
import sys
from gtts import gTTS
import urllib
import os
from record import record
import speech_recognition as sr

def STT(token, data, model):
    # HOST, PORT 記得修改
    HOST, PORT = "140.116.245.149", 2802
    sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    #model = "dnn_S06"
    try:
        sock.connect((HOST, PORT))
        msg = bytes(token + "@@@", "utf-8") + struct.pack("8s",bytes(model, encoding="utf8")) + b"P" + data
        msg = struct.pack(">I", len(msg)) + msg  # msglen
        sock.sendall(msg)
        received = str(sock.recv(1024), "utf-8")
    finally:
        sock.close()

    return received

def TTS(token, data, model="F06"):
    # HOST, PORT 記得修改
    HOST, PORT = "140.116.245.146", 10012
    sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    received = ""
    try:
        sock.connect((HOST, PORT))
        msg = bytes(token+"@@@"+data+"@@@"+model, "utf-8")
        msg = struct.pack(">I", len(msg)) + msg
        sock.sendall(msg)
        
        with open('output.wav','wb') as f:
            while True:
                # print("True, wait for 15sec")
                # time.sleep(15)
                
                l = sock.recv(8192)
                # print('Received')
                if not l: break
                f.write(l)
        print("File received complete")
    finally:
        sock.close()
    return "OK"

def chinese_STT(wav_file):

    r = sr.Recognizer()
    with sr.WavFile(wav_file) as source:
        audio = r.record(source)

    try:
        result = r.recognize_google(audio, language='zh-tw')
        return result
    except LookupError:
        print("Could not understand audio:" , wav_file)
        return None

def chinese_TTS(data):
    while True:
        try:
            urllib.request.urlopen("http://www.google.com")
        except urllib.error.URLError:
            print("Fail to connect Internet...")
            os.system("")
            time.sleep(1)
        else:
            print("Connected")
            # change here
            tts = gTTS(text = data, lang='zh-tw')
            tts.save("test.mp3")
            os.system("mpg123 test.mp3")
            break

### Don't touch

if __name__ == "__main__":
    token = "eyJhbGciOiJSUzUxMiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE2NDkxNjUxNTgsImlhdCI6MTYzMzYxMzE1OCwic3ViIjoiIiwiYXVkIjoid21ta3MuY3NpZS5lZHUudHciLCJpc3MiOiJKV1QiLCJ1c2VyX2lkIjoiMjkwIiwibmJmIjoxNjMzNjEzMTU4LCJ2ZXIiOjAuMSwic2VydmljZV9pZCI6IjMiLCJpZCI6Mzk3LCJzY29wZXMiOiIwIn0.V5H83lIze4RNTf6AGZUf34e6XVtlnVlpUHBLbdJUhL4KK4KPUWDQ3jcallP676OxRVZFn9ExcfxVPhnIZWyVIoxJr09Nothe16_gtLVQVxFNWtbPm5qCaWEEQZeY9vcvQwkI9wMzf_z-xWi0v7bkkqhaAK59qtQZDgYF7r5ztyM" # 需要申請
    token_2 = "eyJhbGciOiJSUzUxMiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE3OTEyOTMxMzMsImlhdCI6MTYzMzYxMzEzMywic3ViIjoiIiwiYXVkIjoid21ta3MuY3NpZS5lZHUudHciLCJpc3MiOiJKV1QiLCJ1c2VyX2lkIjoiMjkwIiwibmJmIjoxNjMzNjEzMTMzLCJ2ZXIiOjAuMSwic2VydmljZV9pZCI6IjI0IiwiaWQiOjM5Niwic2NvcGVzIjoiMCJ9.XtqCCNnmc6tiNIOvcCsY6_vX-IjQFreYQWeU3BqXAvhZYCnjRUZvkcQcRLo-FjUikviipwRRYZhBGXK2Pd2xK8gfNu7LKRGh9V3sPvHIHn4MxC-YzV0tjQItGyIDW2w708YJQffx3v4A7wxnj3sjkxDxHIS8LApRcgk7Cd3Rdig"
    print("program activated")
    models = ["dnn_S06","Minnan"]
    select = input("Chinese(0) or Minnan(1) : ")
    if select != '0' and select != '1':
        select = 1
    select = int(select)

    record()
    file_name = "recording.wav"

    if select == 1:
        file = open(r"./{}".format(file_name), 'rb')
        data = file.read()
        total_time = 0
        count = 0.0

        raw = STT(token, data, models[select])
        text = []
        temp = ""
        print(raw)
        for i in range(len(raw)):
            if raw[i] != ' ':
                if not 0 <= ord(raw[i]) < 128:
                    temp += raw[i]
            else:
                if temp not in text and temp != "":
                    text.append(temp)
                temp = ""
        print ("original : ")
        for i in text:
            print(i,end ="")
        print("\nreply : ")
        display = ""
        speak_text = ""
        for i in text:
            if i == "歡喜":
                print("情感:開心")
                display = "你開心，我也開心"
                speak_text = "你歡喜，我也歡喜"
                break
            if i == "緊張":
                print("情感:緊張")
                display = "放輕鬆，不要緊張"
                speak_text = "放輕鬆，不要緊張"
                break
            if i == "生氣" or i =="受氣" or i == "哭":
                print("情感:生氣")
                display = "生氣傷身體，我能做甚麼為你消消氣嗎?"
                speak_text = "生氣傷身體，我能做甚麼為你消消氣嗎?"
                break
        print(display)
        print("Client : ",TTS(token_2,speak_text))
        os.system("aplay output.wav")
    
    else:
        src = chinese_STT(file_name)
        print("original : \n",src)
        speak = "沒有東西"
        print("reply : ")
        for i in range(len(src)-1):
            if src[i:i+2] == "開心":
                print("情感:開心")
                speak = "你開心，我也開心"
                break
            if src[i:i+2] == "緊張":
                print("情感:緊張")
                speak = "放輕鬆，不要緊張"
                break
            if src[i:i+2] == "生氣":
                print("情感:生氣")
                speak = "生氣傷身體，我能做甚麼為你消消氣嗎?"
                break
            

        print(speak)
        chinese_TTS(speak)

    
