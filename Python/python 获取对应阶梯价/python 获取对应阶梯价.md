# python 获取对应阶梯价
```
electron_dict = {'store_id': 49, 'part_id': 'ab2d9de0-9e4c-11ea-b100-20040fe763d8', 'goods_storage': 0, 'interior_time': 0, 'company_name': '深圳市道合顺电子科技有限公司', 'company_phone': '0755-83246417', 'store_type':
'1', 'contacts_name': '欧阳冬1111', 'contacts_phone': '157680787362', 'gradient': {'1': '29.45684', '10': '27.90648', '100': '26.35612', '1000': '24.80576'}, 'source': 2}

def get_platform_price(electron_dict, count):
    """根据用户上传的元器件数量获取对应的阶梯价(平台售价)"""
    try:
        if electron_dict:
            list_1 = []
            gradient = electron_dict.get('gradient', {})
            if gradient:
                for key, value in gradient.items():
                    list_1.append({"num": key, "price": value})
                for i in range(len(list_1) + 1):
                    if int(list_1[i]['num']) > count:
                        b = 0 if i - 1 < 0 else i - 1
                        return list_1[b]['price']
                    else:
                        if i == (len(list_1) - 1):
                            return list_1[len(list_1) - 1]['price']
            else:
                return 0
        else:
            return 0
    except Exception as e:
        print(e)
```