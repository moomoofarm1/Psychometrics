# copyright @ ZhuoJun Gu，仅供研究之用，复制与传播必须遵守GNU V3.0协议 

# http://www.gnu.org/licenses/gpl-3.0.html

import  cymysql
import  json
import numpy as np
cimport numpy as np
from sklearn.decomposition import IncrementalPCA as PCA

def db_connect(host,user,passwd,db,sql):
    # conn = cymysql.connect(host='localhost', user='root', passwd='admin', db='demo')
    global conn,cur

    conn = cymysql.connect(host=host, user=user, passwd=passwd, db=db)
    cur = conn.cursor()
    try:
        # cur.execute('select factor_json from tenant_table_reports')
        cur.execute(sql)

        # keyArr  = []
        # dataArr = []
        # i = 0
        # all = cur.fetchall()
        # print(all)
        #
        # for r in all:
        #     # print(r)
        #     i = i+1
        #     data = json.loads(r[0])
        #     # dataArr.append(list(data.values()))
        #     dataArr.append(data)
        #     # if i == 1:
        #     #     keyArr.extend(list(data.keys()))
        #
        #     # print(keyArr,dataArr)
        # # return (keyArr,dataArr)
        # return dataArr
        return 1
    except:
        print ("Error: unable to fetch data")
        return "Error: unable to fetch data"
def close(conn,cur):
    # 关闭数据库连接
    cur.close()
    conn.close()

def db_close():
    close(conn,cur)
def fetchmanydata(int num):
    many = cur.fetchmany(size=num)
    dataArr = []
    for r in many:
        data = json.loads(r[0])
        dataArr.append(data)
    return dataArr



def doaccess():
    db_connect('localhost','root','admin','db','select factor_json from examine_reports_copy')
    cdef int i
    cdef int j
    cdef double[:, :] data_output_view
    while(1):
        i=0
        j=0
        data = fetchmanydata(60)
        j = len(data)
        print("j",j)
        if j <= 0:
            break
        model = PCA(n_components=1, batch_size=j)

        data_output = np.zeros([j,4]) # 第二个参数是需要计算的变量数，后面改
        data_output_view = data_output # 对ndarray的view

        for i in range(j):
        #   data[i] = json.loads(data[i])
            data_output_view[i,0] = data[i]['aaa']
            data_output_view[i,1] = data[i]['bbb']
            data_output_view[i,2] = data[i]['ccc']
            data_output_view[i,2] = data[i]['ddd']

        model.partial_fit(data_output)


    output = list(model.components_[0,:])
    print('output',output)
    db_close()
