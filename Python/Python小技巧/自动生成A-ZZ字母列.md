#自动生成A-ZZ字母列

for i in range(1, bom_len + 11):
    column_list.append(getColumnName(i))

def getColumnName(columnIndex):
    """生成excel的列AA-ZZ"""
    ret = ''
    ci = columnIndex - 1
    index = ci // 26
    if index > 0:
        ret += getColumnName(index)
    ret += string.ascii_uppercase[ci % 26]
    return ret