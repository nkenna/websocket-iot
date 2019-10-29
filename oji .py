from simple_websocket_server import WebSocketServer, WebSocket
from gpiozero import MotionSensor, LED, PWMLED, Servo
import pigpio
import RPi.GPIO as GPIO
import Adafruit_DHT
from time import sleep
import threading

GPIO.setmode(GPIO.BCM)

# pins to use
pin_pir1 = 23
pin_pir2 = 26
alarm_pin = 21
flite_pin = 17
blite_pin = 27
slite_pin = 22
temp_pin = 4
relay = 20

servo_door_pin = 13
sensorpin = 4


pi = pigpio.pi()
# initializations
#pir1 = MotionSensor(pin_pir1)
#pir2 = MotionSensor(pin_pir2)
alarm = LED(alarm_pin)
flite = LED(flite_pin)
blite = LED(blite_pin)
slite = LED(slite_pin)
fan = LED(relay)
sensormodel = Adafruit_DHT.AM2302
pi.set_mode(servo_door_pin, pigpio.OUTPUT)
#servo_camera = Servo(servo_door_pin)
#servo_door = Servo(20)

GPIO.setup(pin_pir1, GPIO.IN)
GPIO.setup(pin_pir2, GPIO.IN)

   
            
        

#pir1.when_motion = p_action(pin_pir1, "front: motion detected")
#pir2.when_motion = p_action(pin_pir2, "back: motion detected")



print("setting to: ",pi.set_servo_pulsewidth(servo_door_pin, 1500))
print("set to: ",pi.get_servo_pulsewidth(servo_door_pin))
temperature = 25.0
humidity = 73.0
temp_fan = False
ARMED = False
tt = 10.0
#fan.value = 1
#pi.stop()

slite.value = 1
sleep(3)
slite.value = 0

def getTemp():
    global temperature
    global humidity
    global tt
    hum, tempe = Adafruit_DHT.read_retry(sensormodel, sensorpin)
    humidity = hum
    humidity = float("{:0.2f}".format(humidity))
    temperature = tempe
    tt = tempe
    temperature  = float("{:0.2f}".format(temperature))

def p_action(client, message):
    while True:
        i1 = GPIO.input(pin_pir1)
        i2 = GPIO.input(pin_pir2)

        if i1:
            if ARMED:
                alarm.value = 1
            client.send_message('front: ' + message)
        if i2:
            if ARMED:
                alarm.value = 1
            client.send_message('back: ' + message)
        sleep(3) 
    



class SimpleEcho(WebSocket):

    

   
   
    def handle(self):
        # echo message back to client
        global ARMED
        sensordata = str(self.data)
        print(sensordata)
        print(self.address)
        if (sensordata == 'frontlite1'):
            print(1)
            flite.value = 1
            self.send_message('front lite ON')
        elif sensordata == 'frontlite0':
            print(0)
            flite.value = 0    
            self.send_message('frontlite OFF')
        elif sensordata == 'backlite1':
            print(1)
            blite.value = 1
            self.send_message('back lite ON')
        elif sensordata == 'backlite0':
            print(0)
            blite.value = 0
            self.send_message('back lite OFF')
        elif sensordata == 'seclite1':
            print(1)
            slite.value = 1
            self.send_message('security lite ON')
        elif sensordata == 'seclite0':
            print(0)
            slite.value = 0
            self.send_message('security lite OFF')
        elif sensordata == 'fan1':
            print(1)
            fan.value = 1
            self.send_message('Fan ON')
        elif sensordata == 'fan0':
            print(0)
            fan.value = 0
            self.send_message('Fan OFF')
        elif sensordata == 'alarm1':
            print(1)
            alarm.value = 1
            self.send_message('alarm ON')
        elif sensordata == 'alarm0':
            print(0)
            alarm.value = 0
            self.send_message('alarm OFF')
        elif sensordata == 'arm1':
            print(1)
            ARMED = True
            self.send_message('ARMED')
        elif sensordata == 'arm0':
            print(0)
            ARMED = False
            self.send_message('UNARMED')
        elif sensordata == 'temperature':
            print(temperature)
            getTemp()
            self.send_message('TE'+str(temperature))
        elif sensordata == 'humidity':
            print(humidity)
            self.send_message('HU'+str(humidity))        
        elif sensordata == 'open':
            print('open')
            pi.set_servo_pulsewidth(servo_door_pin, 2000)
        elif sensordata == 'close':
            print('close')
            pi.set_servo_pulsewidth(servo_door_pin, 800)
        else:
            self.send_message('no operation specified')    

    def connected(self):
        print(self.address, 'connected')
        p = threading.Thread(target=p_action, args=(self, 'motion detected'))
        p.start()
        self.send_message('HU'+str(humidity))
        self.send_message('TE'+str(temperature))

    def handle_close(self):
        print(self.address, 'closed')


server = WebSocketServer('', 8001, SimpleEcho)

server.serve_forever()
