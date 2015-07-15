import socket
import logging
import datetime
from boto.ec2 import cloudwatch
from logging.handlers import RotatingFileHandler

UDP_IP = "0.0.0.0"
UDP_PORT = 20000
#logger = logging.basicConfig(level=logging.WARNING, filename='/tmp/udpapp.log')
logger = logging.getLogger("Rotating Log")
logger.setLevel(logging.WARNING)
handler = RotatingFileHandler('/tmp/udpapp.log', maxBytes=5000,backupCount=1)
logger.addHandler(handler)

sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM) # UDP
sock.bind((UDP_IP, UDP_PORT))
while True:
   try:
      data, addr = sock.recvfrom(1024) # buffer size is 1024 bytes
      #print "received message:", data, ":",count
      metrics = data.split("_")
      print metrics
      dt = datetime.datetime.fromtimestamp(float(metrics[4]))
      cw = cloudwatch.connect_to_region("us-east-1")
      cw.put_metric_data("YARD-2","Temp",metrics[1],dt,unit=None,dimensions={"Item":metrics[0]})
      cw.put_metric_data("YARD-2","Hum",metrics[2],dt,unit=None,dimensions={"Item":metrics[0]})
      cw.put_metric_data("YARD-2","Weight",metrics[3],dt,unit=None,dimensions={"Item":metrics[0]})
      cw.close()
   except:
        logger.exception("MyException:")



