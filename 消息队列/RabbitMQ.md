# RabbitMQ
```
import json
import pika

CONFIG = {
    'rabbit_user': 'appadmin',
    'rabbit_password': 'apprabbitmq',
    'rabbit_ip': '192.168.1.100',
    'rabbit_port': 5672,
    'rabbit_queue_name': 'bom_queue_1',
    'rabbit_routing_key': 'bom_queue_1',
    'rabbit_exchange': '',
    'rabbit_vhost': '',

}


class RabbitMQClient(object):
    """
    RabbitMQ 类
    """

    def __init__(self):
        # 获取与rabbitmq 服务的连接，虚拟队列需要指定参数 virtual_host，如果是默认的可以不填（默认为/)，也可以自己创建一个
        self.connection = pika.BlockingConnection(
            pika.ConnectionParameters(host=CONFIG.get('rabbit_ip'), port=CONFIG.get('rabbit_port'),
                                      credentials=pika.PlainCredentials(CONFIG.get('rabbit_user'),
                                                                        CONFIG.get('rabbit_password'))))
        # 创建一个 AMQP 信道（Channel）,建造一个大邮箱，隶属于这家邮局的邮箱
        self.channel = self.connection.channel()
        self.exchange = CONFIG.get('rabbit_exchange')
        self.routing_key = CONFIG.get('rabbit_routing_key')
        self.queue_name = CONFIG.get('rabbit_queue_name')
        self.channel.queue_declare(queue=self.queue_name, durable=True)

    def send(self, msg):
        """消息生产者"""
        try:
            self.channel.basic_publish(
                exchange=self.exchange,
                routing_key=self.routing_key,
                body=json.dumps(msg),
                properties=pika.BasicProperties(
                    delivery_mode=2,  # make message persistent
                )
            )
        except Exception as e:
            print(e)

    def consumer(self):
        """消息消费者"""
        try:
            # 声明消息队列tester,durable=False 表示不持久化
            self.channel.queue_declare(queue=self.queue_name, durable=True)

            # 定义一个回调函数来处理消息队列中的消息，这里是将消息写入文件，你也可以入库。
            def callback(ch, method, properties, body):
                ch.basic_ack(delivery_tag=method.delivery_tag)  # 告诉生成者，消息处理完成
                print(body.decode())

            # 公平调度，这样是告诉RabbitMQ，再同一时刻，不要发送超过1条消息给一个工作者（worker），直到它已经处理了上一条消息并且作出了响应
            self.channel.basic_qos(prefetch_count=1)
            # 告诉rabbitmq在tester列表里面收消息，收到就调用callback函数
            self.channel.basic_consume(self.queue_name, callback)
            # 开始接收信息，并进入阻塞状态，队列里有信息才会调用callback进行处理
            self.channel.start_consuming()
        except Exception as e:
            print(e)

    def close(self):
        self.channel.close()
        self.connection.close()


if __name__ == '__main__':
    client = RabbitMQClient()
    i = 0
    msg = ''
    for i in range(3):
        i+=1
        msg = 'hello world' + str(i)
        client.send(msg)
    client.consumer()
    client.close()

```
