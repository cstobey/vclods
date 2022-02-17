echo parent start
( echo subprocess start && sleep 1 && echo subprocess done ) & # needs to be less than 1 second for this to work... no way to consistently detect orphans otherwise.
echo parent done
