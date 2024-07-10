from scapy.all import *
import socket

class Report(Packet):
    name="report"
    fields_desc = [ BitField("rtt", 0, 32)]

count = 0

def extract_tput(packet):
    global count
    #packet.show()
    count += 1
    if(packet.haslayer(Report)):
        if (count > 20): # skip the first 20 packets
            custom_packet = packet[Report]
            print(f" {custom_packet.rtt}")

bind_layers(Ether, Report, type=0x1234)

sniff(iface='h3-eth0', prn = lambda packet: extract_tput(packet))
