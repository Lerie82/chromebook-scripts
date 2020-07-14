rm file ip

red='\033[0;31m'
green='\033[0;32m'
yellow='\033[1;33m'
nc='\033[0m' # No Color
macs=(64:c2:de:2a:8e:70 b8:86:87:ab:74:27)

reset

#check for an IP
printf "${yellow}Checking for internet connection${nc}.. "
ip=`wget -qOfile 'http://hotspot.els.com/status'; cat file|grep -oE [0-9]+\\.[0-9]+\\.[0-9]\\.[0-9]+ >ip; cat ip`

if [ -z "$ip" ]; then
        echo -e "${red}Current IP: not connected${nc}"
else
        echo -e "Current IP is ${green}$ip${nc}"
fi

#check if we need to change macs
printf "${yellow}Checking the current MAC.. ${nc} "
mac=`ifconfig wlan0|grep -Eo 'HWaddr [a-z0-9]+:[a-z0-9]+:[a-z0-9]+:[a-z0-9]+:[a-z0-9]+:[a-z0-9]+'|cut -d' ' -f2`

if [ $mac == '90:61:ae:75:fb:cf' ]; then
        echo -e "${yellow}Changing MAC address..${nc}"
        rand=$((0+RANDOM%2))
        sudo ifconfig wlan0 down
        sudo ifconfig wlan0 hw ether ${macs[rand])}
        sudo ifconfig wlan0 up
else
        echo -e "Current MAC address ${green}is good${nc}"
fi

#wait for connection then login
#while ! ping -c1 -W5 google.com 2>&1 >/dev/null; do
#       echo -e "${yellow}Waiting for WIFI connection..${nc}"
#       sleep 10
#done

ip=`ifconfig wlan0|grep -Eo 'inet addr:[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+'`

while [[ $ip == '' ]]; do
        echo "${red}wlan0 is down, attempting to fix..${nc}"
        sudo ifconfig wlan0 up
        ip=`ifconfig wlan0|grep -Eo 'inet addr:[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+'`
        sleep 10
done

if [[ $ip != '' ]]; then
        echo -e "${yellow}Logging in..${nc}"
        curl -s -d 'dst=http://www.gstatic.com/generate_204&password=********&popup=true&username=lerie' http://wlogin.userser$
fi
