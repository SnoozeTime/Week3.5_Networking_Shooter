import socket
import time

def client():
    for i in range(10):
        msgFromClient = "Hello UDP Server"

        bytesToSend = str.encode(msgFromClient)

        serverAddressPort = ("127.0.0.1", 20001)

        bufferSize = 1024

        # Create a UDP socket at client side

        UDPClientSocket = socket.socket(family=socket.AF_INET, type=socket.SOCK_DGRAM)

        # Send to server using created UDP socket
        sent_at = time.time()
        UDPClientSocket.sendto(bytesToSend, serverAddressPort)

        msgFromServer = UDPClientSocket.recvfrom(bufferSize)
        ping = time.time()-sent_at
        print(f'Ping is {ping}')
        msg = "Message from Server {}".format(msgFromServer[0])

    print(msg)



if __name__ == '__main__':
    client()