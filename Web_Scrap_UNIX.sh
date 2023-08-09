#!/bin/bash
scriptname = $0
usage ()

cat << EOF Usage:$scriptname[-c][-d][-D][-o][-p][-r][-s] "movie name"
|| $scriptname[-h][-H][-w]
- c Cast
- d Duration
- D Director
-o Overview (Actor, Actress, Ratings,
Director and Plot)
- p Download the poster
- r Rating
-s Summary of the movie
- h Help
-H History of previous searches by the user
-w Movies in theatres this week EOF exit 0}
lg = "\033[92m"
ly = "\033[93m"
lb = "\033[96m"
green = "\033[32m"
red = "\033[31m"
lr = "\033[91m"
getUrl ()

url_first_part = "http://www.imdb.com/find?q="
url_last_part = "&ref_=nv_sr_sm"
url = "${url_first_part}${OPTARG}${url_last_part}"
wget "${url}" - q - O ~ /movie_list
result =$ (grep - Po -m 1'(?<=<h1 class="findHeader">)\K.*?(?=<span
class="findSearchTerm">)' ~
/movie_list | head - 1)
cmpText ="No results found for "
if["$result" = "$cmpText"]
then check = 0;
echo "Sorry.No results were found." rm ~ /movie_list
else
check = 1;
titleId =$ (grep - Po -m 1"(?<=td class=\"primary_photo\"> <a href=\").*?(?=\" ><img src)" ~
/movie_list | head - 1)
part_to_be_added = "?ref_=fn_al_tt_1"
final_url ="www.imdb.com$titleId$part_to_be_added" rm ~ /movie_list fi}
#done
getDuration ()
{
wget "${final_url}" - q - O ~ /movie_local
duration =$ (grep -Po '(?<=}],"duration":"PT).*?(?="}</script>)' ~ /movie_local | head- 1)
echo - e - n "${lg}Duration: " echo -
e "\033[96m$duration" rm ~ /movie_local}
#done
getPoster ()
{
wget "${final_url}" - q - O ~ /movie_local
poster =$ (grep - Po -m 1 '(?<=https://m.media-amazon.com/images/M).*?(?=jpg)' ~
/movie_local | head - 1) echo "Poster : $poster" url_first_part =
"https://m.media-amazon.com/images/M" url_last_part = "jpg" image_url =
"$url_first_part$poster$url_last_part" echo "image url : $image_url"
folder_name ="${OPTARG}" mkdir ~ /"${folder_name}" wget - q "${image_url}" -
O ~ /"${folder_name}" / "${folder_name}" Poster.jpg echo - n -
e "\033[96mDownload complete" rm ~ /movie_local}
#done
getRating ()
{
wget "${final_url}" - q - O ~ /movie_local
rating =$ (grep - Po '(?<=jGRxWM">).*?(?=</span)' ~ /movie_local | head -
1) echo - n - e "${lg}Imdb Rating: " echo - e "\033[96m$rating/10"
rm ~/movie_local
}
#done
getMovies ()
{
wget "http://www.imdb.com/movies-in-theaters/" - q - O ~ /movie_local
movies = $ (grep - Po '(?<=alt=")\K.*?(?=")' ~ /movie_local)
echo - n - e "${lg}Movies in theatres this week: "
echo - e "\033[96m\n$movies" rm ~ /movie_local}
#done
getActor ()
{
wget "${final_url}" - q - O ~ /movie_local
actor = $ (grep -zPo '(?<=Directed by).* With\K.*?(?=\.)' ~ /movie_local) echo - n -
e "${lg}Actors: " echo - e "\033[96m$actor" rm ~ /movie_local}
#done
getDirector ()
{
wget "${final_url}" - q - O ~ /movie_local
director =
$ (grep - Po '(?<=Directed by).*?(?=\.)' ~ /movie_local | head -
1) echo - n - e "${lg}Director: " echo -
e "\033[96m$director" rm ~ /movie_local}
#done
getSummary ()
{
wget "${final_url}" - q - O ~ /movie_local
summary =
$ (grep - Po '(?<=name="description" content=").*?(?=data-id)' ~
/movie_local) echo - e "${lg} Summary:" echo -
e "\033[96m $summary" rm ~ /movie_local}
#done
getOverview ()
{
wget "${final_url}" - q - O ~ /movie_local
title =
$ (grep - Po '(?<=<title>)\K.*?(?= \()' ~ /movie_local | head -
1) echo - e "${lg}Title\t\t: \033[96m$title" year =
$ (grep - Po '(?<=<title>).?\(\K.?(?=\))' ~ /movie_local | head -
1) echo - e "${lg}Year\t\t: \033[96m$year" rating =
$ (grep - Po '(?<=jGRxWM">).*?(?=</span)' ~ /movie_local | head -
1) echo - e "${lg}Rating\t\t: \033[96m$rating/10" director =
$ (grep - Po '(?<=Directed by).*?(?=\.)' ~ /movie_local | head -
1) echo - n - e "${lg}Director\t:\033[96m$director\n" actor =
$ (grep - Po '(?<=Directed by).* With\K.*?(?=\.)' ~ /movie_local) echo -
n - e "${lg}Cast\t\t:\033[96m$actor\n" summary =
$ (grep -
Po '(?<=name="description" content=").*?(?=data-id)' ~
/movie_local) echo - e "${lg}Plot\t\t: \033[96m $summary" echo -
e "${lg}Imdb movie URL\t:\033[91m$urllg$final_url" rm ~ /movie_local}
#done
getHistory ()
{
cat ~ /movie_history.txt}
unset flag
#this is to unset the value of flag if it had any value previously
while getopts ":c:d:D:hHgo:p:r:s:w" opt
do
case $opt in c)
movie = "${OPTARG}" getUrl if[$check - eq 1]
then getActor fi echo "${OPTARG}" >> ~/movie_history.txt flag = '1';;
d) getUrl if[$check - eq 1]
then getDuration fi flag = '1' echo "${OPTARG}" >> ~/movie_history.txt;;
D) getUrl if[$check - eq 1]
then
getDirector fi flag = '1' echo "${OPTARG}" >> ~/movie_history.txt;;
h) usage flag = '1';;
H) getHistory flag = '1';;
o) getUrl if[$check - eq 1]
then
getOverview fi flag = '1' echo "${OPTARG}" >> ~/movie_history.txt;;
p) getUrl if[$check - eq 1]
then getPoster fi flag = '1' echo "${OPTARG}" >> ~/movie_history.txt;;
r) getUrl if[$check - eq 1]
then getRating fi flag = '1' echo "${OPTARG}" >> ~/movie_history.txt;;
s) getUrl if[$check - eq 1]
then
getSummary fi flag = '1' echo "${OPTARG}" >> ~/movie_history.txt;;
w) getMovies flag = '1';;
\?) echo "Invalid option: -$OPTARG" flag = '1' usage;;
:)
echo "Option -$OPTARG requires an argument." usage flag = '1';;
esac done if[-z "$flag"]
then echo "No options were passed"
usage fi
