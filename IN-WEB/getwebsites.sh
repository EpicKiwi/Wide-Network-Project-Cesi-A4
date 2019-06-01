#!/bin/env sh

mkdir toyota
cd toyota
wget -E -H -k -K -p -nd https://fr.wikipedia.org/wiki/Toyota_Supra
mv Toyota_Supra.html index.html
cd ..

mkdir telredor
cd telredor
wget -E -H -k -K -p -nd https://wow.gamepedia.com/Telredor
mv Telredor.html index.html
cd ..

mkdir cesi
cd cesi
wget -E -H -k -K -p -nd https://www.cesi.fr
cd ..