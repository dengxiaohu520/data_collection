# python 操作excel表
```
import xlrd
import xlwt
import pymysql
import requests

from xlutils.copy import copy
from requests.adapters import HTTPAdapter

# conn = pymysql.connect(host='******', port=3306, user='****', password='*****', db='****',
#                        charset='utf8')
conn = pymysql.connect(host='******', port=3306, user='****', password='*****', db='****',
                       charset='utf8')

cursor = conn.cursor()

def get_requests():
    try:
        # cursor.execute("SELECT DISTINCT(images), model_name, id from magic_online.m_electron limit 10")
        cursor.execute("SELECT DISTINCT(images), model_name, id from db_electron.tb_electron group by factory_id having factory_id = 8895 limit 10")
        maxid = cursor.fetchall()
        image_list = []
        for i in maxid:
            print(i)
            if len(i) >=3:
                s = requests.Session()
                s.mount('http://', HTTPAdapter(max_retries=3))
                s.mount('https://', HTTPAdapter(max_retries=3))
                response = s.get(i[0], timeout=5)
                if response.status_code == 200:
                    image_list.append(list(i))
        write_excel_xls_append(book_name_xls, image_list)
    except Exception as e:
        print(e)
        get_requests()


def write_excel_xls(path, sheet_name, value):
    index = len(value)  # 获取需要写入数据的行数
    workbook = xlwt.Workbook()  # 新建一个工作簿
    sheet = workbook.add_sheet(sheet_name)  # 在工作簿中新建一个表格
    for i in range(0, index):
        for j in range(0, len(value[i])):
            sheet.write(i, j, value[i][j])  # 像表格中写入数据（对应的行和列）
    workbook.save(path)  # 保存工作簿
    print("创建xls文档成功！")


def write_excel_xls_append(path, value):
    index = len(value)  # 获取需要写入数据的行数
    workbook = xlrd.open_workbook(path)  # 打开工作簿
    sheets = workbook.sheet_names()  # 获取工作簿中的所有表格
    worksheet = workbook.sheet_by_name(sheets[0])  # 获取工作簿中所有表格中的的第一个表格
    rows_old = worksheet.nrows  # 获取表格中已存在的数据的行数
    new_workbook = copy(workbook)  # 将xlrd对象拷贝转化为xlwt对象
    new_worksheet = new_workbook.get_sheet(0)  # 获取转化后工作簿中的第一个表格
    for i in range(0, index):
        for j in range(0, len(value[i])):
            new_worksheet.write(i + rows_old, j, value[i][j])  # 追加写入数据，注意是从i+rows_old行开始写入
    new_workbook.save(path)  # 保存工作簿
    print("xls写入数据成功！")


book_name_xls = '验证图片有效性.xls'

sheet_name_xls = '验证图片有效性'

value_title = [["图片链接", "型号名称", "id"], ]




if __name__ == '__main__':
    write_excel_xls(book_name_xls, sheet_name_xls, value_title)
    get_requests()


```
