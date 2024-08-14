#!/bin/bash
# version 2024-08-13
apikey=$(cat temp/api-key.txt)
apiurl=$(cat temp/api-url.txt)

install() {
if [ ${#apiurl} -eq 0 ]
then 
read -e -p "Введите URL API полностью:" -i "http://127.0.0.1/api_jsonrpc.php" apiurl
echo $apiurl > temp/api-url.txt 
exit
fi
}

status() {
if [ ${#apikey} -eq 0 ]
then 
echo "Залогинься!"
exit
fi
}

jsonparam() {
local jsp=`echo \""$@"\" | sed -E 's/\s/\"\,\"/g'`
echo $jsp
}

logout() {
if [ ${#apikey} -eq 0 ]
then
break
else
curl --request POST --header "Content-Type: application/json-rpc" -w "\n" --data '''{"jsonrpc":"2.0","method":"user.logout","id":1,"auth":"'${apikey}'","params":[]}''' "${apiurl}"
cat /dev/null > temp/api-key.txt
fi
}

case $1 in
-test)
shift
param=$(jsonparam $@)
echo "$apikey (${#apikey}) $apiurl"
;;
-history) status
shift
param=$(jsonparam $@)
for i in 0 1 2 3 4
do
curl --request POST -s -w "\n" --header "Content-Type: application/json-rpc" --data '''{"jsonrpc":"2.0", "method":"history.get", "id":1, "auth":"'${apikey}'", "params":{"history":'$i', "hostids":['${param}'], "countOutput":true}}''' "${apiurl}" | cut -d'"' -f 8
done
curl --request POST -s -w "\n" --header "Content-Type: application/json-rpc" --data '''{"jsonrpc":"2.0", "method":"item.get", "id":1, "auth":"'${apikey}'", "params":{"hostids":['${param}'], "output":"itemid"}}''' "${apiurl}" | grep -Eo '[0-9\"]{7,8}' | tr -d '\n' | sed 's/""/","/g' > temp/api-temp.txt
paramitem=$(cat temp/api-temp.txt)
curl --request POST -s -w "\n" --header "Content-Type: application/json-rpc" --data '''{"jsonrpc":"2.0", "method":"trend.get", "id":1, "auth":"'${apikey}'", "params":{"itemids":['${paramitem}'], "countOutput":true}}''' "${apiurl}" | cut -d'"' -f 8
;;
-trends) status
shift
param=$(jsonparam $@)
curl --request POST -s -w "\n" --header "Content-Type: application/json-rpc" --data '''{"jsonrpc":"2.0", "method":"item.get", "id":1, "auth":"'${apikey}'", "params":{"hostids":['${param}'], "output":"itemid"}}''' "${apiurl}" | grep -Eo '[0-9\"]{7,8}' | tr -d '\n' | sed 's/""/","/g' > temp/api-temp.txt
paramitem=$(cat temp/api-temp.txt)
curl --request POST -s -w "\n" --header "Content-Type: application/json-rpc" --data '''{"jsonrpc":"2.0", "method":"trend.get", "id":1, "auth":"'${apikey}'", "params":{"itemids":['${paramitem}'], "countOutput":true}}''' "${apiurl}" | cut -d'"' -f 8
;;
-login) logout
shift
curl --request POST -s -w "\n" --header "Content-Type: application/json-rpc" --data '''{"jsonrpc":"2.0", "method":"user.login", "id":1, "params":{"user":"'${1}'","password":"'${2}'"}}''' "${apiurl}" | grep -Eo "[a-f0-9]{32}" > temp/api-key.txt 
;;
-logout) logout
;;
esac
