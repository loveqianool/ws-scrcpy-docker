cd /ws-scrcpy

for i in $(echo $host | sed "s/,/ /g")
do
    adb connect $i:5555
done

npm start
