from flask import Flask, request, jsonify
from flask_cors import CORS
app = Flask(__name__)
CORS(app, resources={r"/*": {"origins": "*"}})

import mysql.connector as conn
class CONN:
    def __init__(self):
        try:
            self.connection = conn.connect(
                host="127.0.0.1",         # 主機名稱
                port=3306,                # 連接埠
                user="root",              # 帳號
                password="ddcharles",          # 密碼
                database="android"           # DB名稱
            )
            self.cursor = self.connection.cursor()
            db_Info = self.connection.get_server_info()
            print("資料庫版本：", db_Info)
        except conn.Error as e:
            print("連接DB失敗：", e)
        
    def __del__(self):
        try:
            self.cursor.close()
            self.connection.close()
            print("資料庫連線已關閉\n")
        except conn.Error as e:
            print("關閉連接失敗：", e)
    
    def DQL(self, sql_query):
        try:
            self.cursor.execute(sql_query)
            
            #print(self.cursor.description)
            column_name = [x[0] for x in self.cursor.description]
            #print(self.cursor.fetchall())
            query_result = self.cursor.fetchall()

            self.connection.commit()
            
            result = {
                "status": "success",
                "column": column_name,
                "result": query_result,
                "dml": ""
            }
            return result
            
        except conn.Error as e:
            print("查詢失敗：", e)
            result = {
                "status": "fail",
                "column": "None",
                "result": str(e),
                "dml": ""
            }
            return result

    def DML(self, sql_query):
        try:
            self.cursor.execute(sql_query)
            rowcount = self.cursor.rowcount
            self.connection.commit()
            
            table_name = None
            dml_str = None
            sql_query_split = sql_query.split()
            if sql_query_split[0] == "DELETE":
                table_name = sql_query_split[2]
                dml_str = "刪除{}行".format(rowcount)
            elif sql_query_split[0] == "INSERT":
                table_name = sql_query_split[2]
                dml_str = "新增{}行".format(rowcount)
            elif sql_query_split[0] == "UPDATE":
                table_name = sql_query_split[1]
                dml_str = "更新{}行".format(rowcount)
                
            new_sql_query = "SELECT * FROM {}".format(table_name)
            result = self.DQL(new_sql_query)
            result["dml"] = dml_str
            return result
            
        except conn.Error as e:
            print("查詢失敗：", e)
            result = {
                "status": "fail",
                "column": "None",
                "result": str(e),
                "dml": ""
            }
            return result
c = CONN()

@app.route("/", methods = ["GET"])
def start():
    print("print hello world")
    return "竇賢祐 F74084012"

@app.route("/mysql", methods = ["POST"])
def mysql():
    data = request.get_json()
    if data["opt"] == "DQL":
        return c.DQL(data["sql"])

    error = {
        "status": "fail",
        "column": "None",
        "result": "opt type error",
        "dml": ""
    }
    return error

if __name__ == "__main__":
    app.run(host="0.0.0.0", port="5000", debug=True)
    
    
