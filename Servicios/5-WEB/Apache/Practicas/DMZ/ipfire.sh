#######################################
###--- Permitir trafico a la DMZ ---###
#######################################
# * 1 --> Firewall Rules --> New Rule --> 
        # * 1.1 --> Source | Standard networks: Any
        # * 1.2 --> NAT | Use NAT --> DNAT
        # * 1.3 --> Destination | Destination address: 10.33.106.3
        # * 1.4 --> Protocol | Preestablecido --> Services: HTTP

##################################################
###--- Permitir trafico de la DMZ al Server ---###
##################################################
# * 2 --> Firewall Rules --> New Rule --> 
        # * 2.1 --> Source | Standard networks: 10.33.106.3
        # * 2.2 --> NAT | NO NAT
        # * 2.3 --> Destination | Destination address: 10.33.6.3
        # * 2.4 --> Protocol | TCP: --> From: --> To: 80
        # * 2.5 --> ACCEPT