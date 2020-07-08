# python 手动分页.md
```
page = int(page)
page_size = int(page_size)
start_page = (page - 1) * page_size
stop_page = page_size + ((page - 1) * page_size)

return Response({"code": 200, "count": product_line_count, "zh_message": "获取成功", "en_message": "","result": product_line_list[start_page:stop_page]})
```
