#!/bin/bash

IZBRANI_DATUM="2026-09-15"
MESTA_DATOTEKA="mesta.txt"
MAPA_ZA_SHRANJEVANJE="arhiv/$IZBRANI_DATUM"
mkdir -p "$MAPA_ZA_SHRANJEVANJE"




while IFS=',' read -r mesto lat lon || [ -n "$mesto" ]; do
    
    mesto=$(echo "$mesto" | tr -d '[:space:]\r')
    lat=$(echo "$lat" | tr -d '[:space:]\r')
    lon=$(echo "$lon" | tr -d '[:space:]\r')

    if [ -z "$mesto" ]; then
        continue
    fi

    if [[ "$mesto" == \#* ]]; then
        continue
    fi

    URL="https://api.open-meteo.com/v1/forecast?latitude=${lat}&longitude=${lon}&hourly=temperature_2m,rain,wind_speed_10m&timezone=auto&forecast_days=1"

    echo "------"
    echo "'$mesto'"


    IZHODNA_DATOTEKA="${MAPA_ZA_SHRANJEVANJE}/${mesto}.json"

    curl -s "$URL" | jq '.' > "$IZHODNA_DATOTEKA"

    if [ $? -eq 0 ] && [ -s "$IZHODNA_DATOTEKA" ]; then
        echo "$mesto = ✅"
    else
        echo "$mesto = ❌"
    fi

done < "$MESTA_DATOTEKA"

echo "--------------------------------------------------"
echo "konec"


