#!/bin/bash
status_code=$(curl -s -o /dev/null -w "%{http_code}" 'https://eda.yandex/restaurant/nasha_shaurma_krasnopresnenskaya_naberezhnaya_16s1')
last_status=123
stamp=$(date '+[%F %H:%M]')
echo "${stamp} Script started" >> /tmp/shavukha.log

while $(sleep 1); do
    status_code=$(curl -s -o /dev/null -w "%{http_code}" 'https://eda.yandex/restaurant/nasha_shaurma_krasnopresnenskaya_naberezhnaya_16s1')
        if [[ ${status_code} -eq 200 ]]; then
            if [[ ${status_code} -ne ${last_status} ]]; then
                stamp=$(date '+[%F %H:%M]')
                echo "${stamp} Open" >> /tmp/shavukha.log
                /usr/bin/notify-send --urgency=critical "Мрази за баксы и Анюта ждут твой ротик."
                last_status=${status_code}
            fi
        elif [[ ${status_code} -eq 302 ]]; then
            if [[ ${status_code} -ne ${last_status} ]]; then
                stamp=$(date '+[%F %H:%M]')
                echo "${stamp} Closed" >> /tmp/shavukha.log
                /usr/bin/notify-send --urgency=low "Все, Анюта занята."
                last_status=${status_code}
            fi
        fi
done
