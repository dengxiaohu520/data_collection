# Django request对象常用属性：
1. path: 
    + 请求页面得全路劲，不包括域名端口参数。例如： /users/index
2. method: 
    + 一个全大写的字符串，表示请求中使用的HTTP方法，常用值：GET， POST，DELETE，PUT等。以下三种为 GET 请求：
    + form 表单默认提交（或者method指定为get）
    + 在浏览器中输入地址直接请求
    + 网页中的超链接（a标签
3. user: 
    + 已登录：AbstractUser对象；
    + 未登录：AnonymousUser对象
4. GET:  
    + 类似字典的 QueryDict 对象，包含 GET 请求的所有参数
5. POST:  
    + 类似字典的 QueryDict 对象，包含 POST 请求的所有键值对参数（表单post提交的参数）
6. body:  
    + 获取原始的请求体数据，获取到的数据为bytes类型
7. META:  
    + CONTENT_LENGTH —— 请求的正文的长度（是一个字符串）。
    + CONTENT_TYPE —— 请求的正文的MIME 类型。
    + HTTP_ACCEPT —— 响应可接收的Content-Type。
    + HTTP_ACCEPT_ENCODING —— 响应可接收的编码。
    + HTTP_ACCEPT_LANGUAGE —— 响应可接收的语言。
    + HTTP_HOST —— 客服端发送的HTTP Host 头部。
    + HTTP_REFERER —— Referring 页面。
    + HTTP_USER_AGENT —— 客户端的user-agent 字符串。
    + QUERY_STRING —— 单个字符串形式的查询字符串（未解析过的形式）。
    + REMOTE_ADDR —— 客户端的IP 地址。
    + REMOTE_HOST —— 客户端的主机名。
    + REMOTE_USER —— 服务器认证后的用户。
    + REQUEST_METHOD —— 一个字符串，例如"GET" 或"POST"。
    + SERVER_NAME —— 服务器的主机名。
    + SERVER_PORT —— 服务器的端口（是一个字符串）。
8. COOKIES：
    + 一个标准的 python 字典，包含所有的 cookies, 键和值都是字符串
9. session：
    + 可读可写的类似字典的对象： django.contrib.sessions.backends.db.SessionStore。
Django 提供了 session 模块，默认就会开启用来保存 session 数据















