# import os
# import sys
from ckiptagger import WS, POS#, NER ,data_utils, construct_dictionary, 

ws = WS("./data", disable_cuda=False)
pos = POS("./data", disable_cuda=False)
#ner = NER("./data", disable_cuda=False)

sentence_list = ["傅達仁今將執行安樂死，卻突然爆出自己20年前遭緯來體育台封殺，他不懂自己哪裡得罪到電視台。",
        "美國參議院針對今天總統布什所提名的勞工部長趙小蘭展開認可聽證會，預料她將會很順利通過參議院支持，成為該國有史以來第一位的華裔女性內閣成員。",
        "宏宏騎機車去台北找朋友玩",
        "檢察官是在偵辦一起毒品案件時，發現劉偉建涉嫌販賣二級毒品大麻",
        "高院仍認定鈕承澤有罪，維持原判",
        "玉山是台灣第一高峰",
        "阿德要去便利商店買泡麵",
        "小志在牛牛牧場看圖片",
        ]

word_sentence_list = ws(sentence_list)
pos_sentence_list = pos(word_sentence_list)
#entity_sentence_list = ner(word_sentence_list, pos_sentence_list)

del ws
del pos
#del ner

def print_word_pos_sentence(word_sentence, pos_sentence):
    #assert len(word_sentence) == len(pos_sentence)
    print("Orginal sentence  :[ ",end = "")
    for i,j in zip(word_sentence, pos_sentence):
        print(f"'{i}', ",end = "")
    print("]")
    print("POS tagging :",end = "")
    for word, pos in zip(word_sentence, pos_sentence):
        print(f"{word}({pos})", end="\u3000")
    print()
    return

def print_entity(word_sentence,pos_sentence):
    person_list = []
    time_list = []
    location_list = []
    object_list = []
    event_dic = {"S" : "",
                 "P" : "",
                 "V" : "",
                 "O" : "",
    }
    event_list = []
    next = "SV"
    man = ""
    for word,pos in zip(word_sentence,pos_sentence):
        if pos == "Nb":
            if word not in person_list:
                person_list.append(word)
            if event_dic["S"] == "" and  next == "SV":
                man = word
                event_dic["S"] = word
                next = "V"
        elif pos == "Nh" and word == "自己" and event_dic["S"] == "":
            event_dic["S"] = man
            next = "V"
        elif pos == "P" and event_dic["P"] == "":
            event_dic["P"] = word
        elif pos == "Nd":
            if word not in time_list:
                time_list.append(word)
        elif pos == "Nc":
            location_list.append(word)

            if event_dic["S"] == "" and next == "SV":
                event_dic["S"] = word
            elif event_dic["O"] == "" and (next == "O" or next == "place"):
                event_dic["O"] = word
                next = "SV"
        elif pos == "Na":
            if word not in object_list:
                object_list.append(word)
            if event_dic["S"] == "" and next == "SV":
                event_dic["S"] = word
            elif event_dic["O"] == "" and next == "O":
                event_dic["O"] = word
                next = "SV"
        elif (pos == "VC" or pos == "VE" or pos == "VD")and event_dic["V"] == "" and (next == "V" or next == "SV"):
            event_dic["V"] = word
            next = "O"
        elif pos == "VCL" and (next == "SV" or next == "V"):
            event_dic["V"] = word
            next = "place"
        if (event_dic["V"] != "" and event_dic["O"] != "") or pos == "PERIODCATEGORY" or pos == "COMMACATEGORY":
            if event_dic["P"] == "遭" or event_dic["P"] == "被":
                temp = event_dic["S"] +  event_dic["P"] + event_dic["V"] + event_dic["O"] 
            else:
                temp = event_dic["S"] + event_dic["V"] + event_dic["O"]
            if temp != "" and event_dic["V"] != "":
                event_list.append(temp)
            event_dic["V"] = event_dic["O"] = event_dic["P"] = "" # event_dic["S"] =
            if pos == "PERIODCATEGORY" or pos == "COMMACATEGORY":
                event_dic["S"] = ""
    print("Person Name List = {0}".format(person_list))
    print("Time List = {0}".format(time_list))
    print("Location List = {0}".format(location_list))
    print("Object List = {0}".format(object_list))
    print("Event List = {0}".format(event_list))


for i, sentence in enumerate(sentence_list):
    print()
    print(f"'{sentence}'")
    print_word_pos_sentence(word_sentence_list[i],  pos_sentence_list[i])
    print_entity(word_sentence_list[i],pos_sentence_list[i])
    # for entity in sorted(entity_sentence_list[i]):
    #     print(entity)