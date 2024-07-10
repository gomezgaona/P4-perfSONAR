mirroring_add 5 2
table_add MyIngress.forwarding MyIngress.forward 10.0.0.1 => 00:00:00:00:00:01 0
table_add MyIngress.forwarding MyIngress.forward 10.0.0.2 => 00:00:00:00:00:02 1
table_add MyIngress.forwarding MyIngress.forward 10.0.0.3 => 00:00:00:00:00:03 2