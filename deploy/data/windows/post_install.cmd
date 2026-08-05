sc stop AmneziaWGTunnel$AmneziaVPN
sc delete AmneziaWGTunnel$AmneziaVPN
taskkill /IM "VPNYour-service.exe" /F
taskkill /IM "VPNYour.exe" /F
exit /b 0
