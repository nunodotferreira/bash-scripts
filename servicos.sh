#!/bin/bash
servico="apache2"
servicom="mysql"
NOW=$(date +"%F %H:%M")
pathlog="services.log"
erro=false
mailto="mymail@mail.com"
othermails="othermail@mail.com"

touch $pathlog

> $pathlog

sleep 1

if ps ax | grep -v grep | grep $servico > /dev/null
then
echo "$servico Running!!!" > /dev/null
else
echo $NOW " Restart $servico" >>$pathlog
echo "Restart apache2" > /dev/null
sudo service apache2 restart
erro=true
fi

sleep 5

if ps ax | grep -v grep | grep $servicom > /dev/null
then
echo "$servicom Running!!!" > /dev/null
else
echo $NOW " Restart $servicom" >>$pathlog
echo "Restart mysql" > /dev/null
sudo service mysql restart
erro=true
fi

sleep 5

if $erro
then
echo "Mail sent." > /dev/null
mailx -s "Some services where restarted ($servico;$servicom)" $mailto -b $othermails < $pathlog
fi
