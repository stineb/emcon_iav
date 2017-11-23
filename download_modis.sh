#!/bin/bash

for year in {2000..2015}
do
	yearstring=`printf "%04i" $year`
	echo $yearstring	
	for moy in {1..12}
	do
		moystring=`printf "%02i"  $moy`
		echo $moystring
		wget --header="Host: files.ntsg.umt.edu" --header="User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/62.0.3202.94 Safari/537.36" --header="Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8" --header="Accept-Language: en-US,en;q=0.9,de;q=0.8,fr;q=0.7,es;q=0.6,it;q=0.5" --header="Cookie: PHPSESSID=amu874vu1qnarkrfp9ecm4juk4" --header="Connection: keep-alive" "http://files.ntsg.umt.edu/data/NTSG_Products/MOD17/GeoTIFF/Monthly_MOD17A2/GeoTIFF_0.05degree/MOD17A2_GPP.${yearstring}.M${moystring}.tif" -O "MOD17A2_GPP.${yearstring}.M${moystring}.tif" -c
	done
done

