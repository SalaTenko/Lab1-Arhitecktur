#!/bin/bash
echo "Дата: `date -I`"
echo "Имя учетной записи: `whoami`"
echo "Доменное имя ПК: `hostname`"

echo "Процессор:"

lscpu | grep 'Model name' | awk '{print "    Модель - " $3" "$4" "$5}'
#'Имя Модели'
lscpu | grep 'Arch' | awk '{print "    Архитектура - " $2}'
#'Архитектруа'
lscpu | grep 'CPU M' | awk '{print "    Тактовая частота - " $3}'
lscpu | grep '^CPU(s):' | awk '{print "    Количество ядер - " $2}'
lscpu | grep 'Th' | awk '{print "    Количество потоков на одном ядре - " $4}'

#echo ram
echo "Оперативная память: "
free -h | grep 'Mem' | awk '{print "    Всего - " $2}'
free -h | grep 'Mem' | awk '{print "    Доступно - " $7}'

echo "Жесткий диск: "
df -h | grep '/dev/sda5' | awk '{print "    Всего - " $2}'
df -h | grep '/dev/sda5' | awk '{print "    Доступно - " $4}'
df -h | grep '/dev/sda5' | awk '{print "    Смонтировано в корневую директорию / - " $5}'
free -h | grep 'Swap' | awk '{print "    SWAP всего - " $2}'
free -h | grep 'Swap' | awk '{print "    SWAP доступно - " $4}'

NAME_INT=$(ifconfig | cut -c 1-8 | sort | uniq -u | awk -F: '{print "   " $1}')
NUM_INT=$(echo "$NAME_INT"| wc -l)
echo "Сетевые интерфейсы: "
echo "    Количество сетевых интерфейсов - $NUM_INT"
echo "    №   Имя интерфейса    MAC-адрес             IP-адреса       Скорость соединения"
I=0

for INTERFACE in $NAME_INT
do
  if(($I<=$NUM_INT))
  then
    ((I++))
  fi
  MAC_ADD=$(ifconfig $INTERFACE | grep 'ether' | awk '{print "   " $2}')
  if [ -z "${MAC_ADD}" ];
  then
    MAC_ADD=$(echo "        No such device  ")
  fi
  IP_ADD=$(ifconfig $INTERFACE | grep 'inet ' | awk '{print "   " $2}')

  SPD=$(sudo apt-get install ethtool)
  CONNECTION_SPD=$(cat sys/class/net/"interface"/speed)
  echo "    $I     $INTERFACE       $MAC_ADD  $IP_ADD  $CONNECTION_SPD "
done
