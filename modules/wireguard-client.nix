{ ... }:
{
  networking = {
    wireguard.interfaces.wg0 =
      {
        privateKeyFile = "/home/revenantigc/wireguard-keys/private";
        # In the configuration add `ips` and `privateKeyFile`.
        peers = [
          {
            name = "VPS";
            publicKey = "VDNKMNA0vHnyXNpm7ElTBaYYwJ87frD5mr+5jyqJkjY=";
            allowedIPs = [
              "0.0.0.0/0"
              "::/0"
            ];
            endpoint = "vps.revenantigc.com.br:51820";
            persistentKeepalive = 25;
          }
        ];
        # I have access to all the network through allowedIPs
        # But by default, I only want routes to the VPN clients and multicast
        allowedIPsAsRoutes = false;
        postSetup = ''
          ip link set wg0 multicast on
          ip route replace "10.100.0.0/24" dev wg0 table main
          ip route replace "fda4:4413:3bb1::/64" dev wg0 table main
        '';
        postShutdown = ''
          ip route del "10.100.0.0/24" dev wg0
          ip route del "fda4:4413:3bb1::/64" dev wg0
        '';
      };
  };
}
