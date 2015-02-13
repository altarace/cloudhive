import Adafruit_DHT as dht
h,t =  dht.read_retry(dht.DHT22,4)
print ",{0:f},{1:f},".format(t,h)
