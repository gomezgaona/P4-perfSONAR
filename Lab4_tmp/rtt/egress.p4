/*************************************************************************
****************  E G R E S S   P R O C E S S I N G   *******************
*************************************************************************/
#define PKT_INSTANCE_TYPE_IGRESS_CLONE 1

control MyEgress(inout headers hdr,
                 inout metadata meta,
                 inout standard_metadata_t standard_metadata) {


     apply { 
          if(standard_metadata.instance_type == PKT_INSTANCE_TYPE_IGRESS_CLONE) {
               
               hdr.ethernet.etherType = 0x1234;

               hdr.report.setValid();
               hdr.report.rtt = meta.rtt_sample;
               
               hdr.ipv4.setInvalid();
               hdr.tcp.setInvalid();
               
               truncate((bit<32>)18);
          } 

     }
}
