from scapy.all import *
import socket

class Report(Packet):
    name="report"
    fields_desc = [ BitField("src_ip", 0, 32),
            BitField("dst_ip", 0, 32),
            BitField("throughput", 0, 48)]


def extract_tput(packet):
    #packet.show()
    if(packet.haslayer(Report)):
            custom_packet = packet[Report]
            src_ip = socket.inet_ntoa(struct.pack('!L', custom_packet.src_ip))
            dst_ip = socket.inet_ntoa(struct.pack('!L', custom_packet.dst_ip))
            print(f" {src_ip} => {dst_ip}: {custom_packet.throughput}")

bind_layers(Ether, Report, type=0x1234)

sniff(iface='h3-eth0', prn = lambda packet: extract_tput(packet))
