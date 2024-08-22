{ ... }:
{
  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    virtualHosts = {
      "vps.revenantigc.com.br" = {
        forceSSL = true;
        enableACME = true;
      };
      "dns.revenantigc.com.br" = {
        forceSSL = true;
        useACMEHost = "vps.revenantigc.com.br";
        locations."/dns-query" = {
          proxyPass = "https://127.0.0.1:3334/dns-query";
        };
      };
    };
    appendHttpConfig = ''
      aio threads;
    '';
  };
}
