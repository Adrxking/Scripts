# 1. Entrar vía WEB al ipfire https://10.33.6.1:444 --> usuario admin

# 2. Entrar en firewall rules --> Abrir puerto 21
#   2.1 Standard networks: any
#   2.2 USE NAT Destination NAT : Red interface
#   2.3 Destination address 10.33.6.5 (Ip del filezilla)
#   2.4 Protocol TCP port 21

# 3. Definir el servicio en Firewall Groups
#   3.1 Services
#   3.1 Add service
#   3.1 Service name: FTP Pasivo
#   3.1 Ports: 49152:65534

# 4. Entrar en firewall rules
#   2.1 Standard networks: any
#   2.2 USE NAT Destination NAT : Red interface
#   2.3 Destination address 10.33.6.5 (Ip del filezilla)
#   2.4 Protocol Preestablecido: FTP Pasivo