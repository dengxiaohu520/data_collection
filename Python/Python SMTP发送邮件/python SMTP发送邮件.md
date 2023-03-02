# python SMTP发送邮件
```
setting文件配置项

# 阿里云的邮箱配置信息
EMAIL_HOST = 'smtpdm.aliyun.com'
EMAIL_PORT = 25
EMAIL_HOST_USER = 'webmaster@mail.infinigo.com'
EMAIL_HOST_PASSWORD = 'EdD1ie90m0f2a'

# BOM报价邮箱消息推送模板
BOM_OFFER_EMAIL_CONTENT_TEMPLATE = """
    <p>尊敬的用户，您好：<p>
         <p>【道合顺网络】 恭喜您收到一条供应商的报价信息，请点击 https://www.infinigo.com （如果不能点击该链接，请复制并粘贴到浏览器的地址输入框）登录INFINIGO平台进入“个人中心-历史BOM管理”查看报价详情。若有疑问，可拨打咨询电话13534149771。<p>

    <p>***********************************************************************************************<p>
    
    <p>道合顺大数据<p>
    <p>电话：0755-83460592<p>
    <p>手机/微信：135 3414 9771<p>
    <p>公司地址：深圳市深南中路3018号交通银行大厦1701室<p>
    <p>公司网站：https://www.infinigo.com/<p>
    <p>微信公众号：道合顺大数据<p>
    <p><img src="cid:image1"></p>
    """



import os
import random
import smtplib
from email.utils import formataddr
from email.mime.text import MIMEText
from email.mime.image import MIMEImage
from email.mime.multipart import MIMEMultipart

from email.header import Header
from .setting import EMAIL_CONTENT_TEMPLATE, BOM_OFFER_EMAIL_CONTENT_TEMPLATE, IMAGE_PSTH


class EmailHelper(object):
    """
    邮件帮助类
    """
    def __init__(self, mail_host='127.0.0.1', mail_port=25, mail_host_user=None, mail_host_pwd=None):
        self.mail_host = mail_host
        self.mail_port = mail_port
        self.mail_host_user = mail_host_user
        self.mail_host_pwd = mail_host_pwd

    def bom_send_email(self, receivers, mail_host='127.0.0.1', mail_port=25, mail_host_user=None, mail_host_pwd=None):
        """
        发送邮箱BOM报价通知
        :param mail_host: 邮件服务器IP
        :param mail_port: 邮件服务器端口
        :param mail_host_user: 邮件服务器发送者用户名
        :param mail_host_pwd: 邮件服务器发送者密码
        :param receivers: 邮件接收者
        :return:
        """
        mail_host = mail_host if mail_host else self.mail_host
        mail_port = mail_port if mail_port else self.mail_port
        mail_user = mail_host_user if mail_host_user else self.mail_host_user
        mail_pass = mail_host_pwd if mail_host_pwd else self.mail_host_pwd
        sender = mail_user
        receivers = receivers if receivers else mail_user

        msgRoot = MIMEMultipart('related')
        msgRoot['From'] = formataddr(("道合顺", sender), charset='utf-8')  # 设置发送者，可以为中文
        msgRoot['To'] = receivers
        msgRoot['Subject'] = Header("【道合顺网络】如意BOM报价通知", charset='utf-8')

        msgAlternative = MIMEMultipart('alternative')
        msgRoot.attach(msgAlternative)

        # 使用模板
        html_message = BOM_OFFER_EMAIL_CONTENT_TEMPLATE
        msgAlternative.attach(MIMEText(html_message, 'html', 'utf-8'))

        # 指定图片为当前目录（插入图片）
        file_path = (os.path.dirname(os.path.abspath(__file__))) + '\\1.png'
        with open(file_path, 'rb') as f:
            msgImage = MIMEImage(f.read())
            # 定义图片 ID，在 HTML 文本中引用
            msgImage.add_header('Content-ID', '<image1>')
            msgRoot.attach(msgImage)
        try:
            smtpObj = smtplib.SMTP()
            smtpObj.connect(mail_host, mail_port)
            smtpObj.login(mail_user, mail_pass)
            smtpObj.sendmail(str(sender), receivers, msgRoot.as_string())
            smtpObj.quit()
            res = {
                "code": 200,
                "zh_message": "邮件已发送",
                "en_message": "The mail has been sent"
            }
            return res
        except smtplib.SMTPException:
            raise Exception({"email_code": "", 'code': 400, 'zh_message': "邮件发送失败", "en_message": "Send failure"})
        except KeyboardInterrupt as ex:
            raise Exception({"email_code": "", 'code': 400, 'zh_message': ex, "en_message": ex})
        except Exception as ex:
            raise Exception({"email_code": "", 'code': 400, 'zh_message': ex, "en_message": ex})
```
