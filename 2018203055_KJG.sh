print_bonus(){
  echo "______                     _    _               "
  echo "| ___ \                   | |  (_)              "
  echo "| |_/ / _ __   __ _   ___ | |_  _   ___   ___   "
  echo "|  __/ |  __| / _  | / __|| __|| | / __| / _ \  "
  echo "| |    | |   | (_| || (__ | |_ | || (__ |  __/  "
  echo "\_|    |_|    \__,_| \___| \__||_| \___| \___|  "
  echo "                                                "
  echo "(_)       | |    (_)                            "
  echo " _  _ __  | |     _  _ __   _   _ __  __        "
  echo "| ||  _ \ | |    | ||  _ \ | | | |\ \/ /        "
  echo "| || | | || |____| || | | || |_| | >  <         "
  echo "|_||_| |_|\_____/|_||_| |_| \__,_|/_/\_\        "
  echo "                                                "
}
print_nopermisson(){
  echo '                                         __      _      ____                                           '
  echo '                                        |   \   | |   /  __  \                                         '
  echo "                                        | |\ \  | |  | /    \ |                                        "
  echo "                                        | | \ \ | |  | |    | |                                        "
  echo "                                        | |  \ \| |  | \ __ / |                                        "
  echo "                                        |_|   \___|   \ ____ /                                         "
  echo "  ______    _______   ______     __     __    _____    _____    _____   _____     ____     __      _   "
  echo " |  __  \  |  _____| |  ___ \   |  \   /  |  |_   _| / _____| / _____| |_   _|  /  __  \  |   \   | |  "
  echo ' | |__|  | | |_____  | |___| |  |   \ /   |    | |   \ `---.  \ `---.    | |   | /    \ | | |\ \  | |  '
  echo ' |  ____/  |  _____| |  __  /   | |\   /| |    | |    `--.  \  `--.  \   | |   | |    | | | | \ \ | |  '
  echo " | |       | |_____  | |  \ \   | | \_/ | |   _| |_   ___/  /  ___/  /  _| |_  | \ __ / | | |  \ \| |  "
  echo " |_|       |_______| |_|   \_\  |_|     |_|  |_____| |_____/  |_____/  |_____|  \ ____ /  |_|   \___|  "
}
get_process(){
  ps -aux > temp
  process_num=`cat temp | wc -l`
  cat temp | tail -$(($process_num-1)) > process
  rm ./temp
}
print_USER(){
  user=`cat process | awk -F' ' '{print $1}' | sort -u | head -$i | tail -1`
  printf "%20.20s" $user
}
print_ground(){
  FG_num=`grep ^$user process | awk -F' ' '{print $2 $8}' | grep + | cut -d" " -f 2 | wc -l`
  PID=`cat process | grep ^$user | awk -F' ' '{print $2}' | tail -$i | head -1`
  for ((z=1; z<=$FG_num; z++))
  do
    FG=`grep ^$user process | awk -F' ' '{print $2,$8}' | grep + | cut -d" " -f 1 | head -$z | tail -1`
    if [ $PID = $FG ]
    then
      FG_check=1
    fi
  done
  if [ $FG_check = 1 ]
  then
    printf "F "
    FG_check=0
  else
    printf "B "
  fi
}
print_CMD(){
  CMD=`cat process | grep ^$user | awk -F' ' '{print $11,$12,$13,$14,$15,$16,$17,$18}' | tail -$i | head -1`
  length=`expr length "$CMD"`
  echo -n "${CMD:0:20}"
  for((k=0; k<20-length; k++))
  do
    printf " "
  done
  printf "|"
}
print_PID(){
  PID=`cat process | grep ^$user | awk -F' ' '{print $2}' | tail -$i | head -1`
  printf "%7.7s|" $PID
}
print_STIME(){
  STIME=`cat process | grep ^$user | awk -F' ' '{print $9}' | tail -$i | head -1`
  printf "%9.9s" $STIME
}
print_all(){
  user_num=`cat process | awk -F' ' '{print $1}' | sort -u | wc -l`
  echo "-NAME-----------------CMD--------------------PID-----STIME-----"
  for ((i=1; i<=20; i++))
  do

    if [ $i -le $user_num ]
    then
      printf "|"
      if [ $y = $i ]
      then
        echo -n [41m
      fi
      print_USER
      echo -n [0m
      printf "|"
    else
      printf "|                    |"
    fi
    user=`cat process | awk -F' ' '{print $1}' | sort -u | head -$y | tail -1`
    userprocess_num=`cat process | grep ^$user | wc -l`

    if [ $i -le $userprocess_num ]
    then
      if [ $x = 2 ] && [ $y2 = $i ]
        then
          echo -n [42m
      fi
      i=i+jump
      print_ground
      print_CMD
      print_PID
      print_STIME
      echo -n [0m
      printf "|\n"
      i=i-jump
    else
      printf "                      "
      printf "|"
      printf "       "
      printf "|"
      printf "         "
      printf "|\n"
    fi
  done
  echo "---------------------------------------------------------------"
  echo -n "|"
  s1=`expr length "$y"`
  s2=`expr length "$user_num"`
  for ((space=0; space<11-s1-s2; space++))
  do
    echo -n " "
  done
  echo -n "user $y / $user_num |"
  s1=`expr length "$(($y2+$jump))"`
  s2=`expr length "$(($jump+20))"`
  s3=`expr length "$userprocess_num"`

  if [ $userprocess_num -lt 20 ]
  then
    for ((space=0; space<25-s1-s3-s3; space++))
    do
      echo -n " "
    done
    echo "process $(($y2+$jump)) / $userprocess_num - $userprocess_num |"
  else
    for ((space=0; space<25-s1-s2-s3; space++))
    do
      echo -n " "
    done
    echo "process $(($y2+$jump)) / $(($jump+20)) - $userprocess_num |"
  fi

  echo "---------------------------------------------------------------"
  printf "If you want to exit , Please Type 'q' or 'Q'\n"
}
input_key(){
  PID=`cat process | grep ^$user | awk -F' ' '{print $2}' | tail -$y2 | head -1`
  if read -t 3 -sn 3 key
  then
    key=$key
  else
    key=1
  fi
  if [ `expr length "$key"` = 0 ]
  then
    if [ $key = ] && [ $x = 2 ]
    then
      if [ $user = `whoami` ]
      then
        kill $PID
      else
        clear
        print_nopermisson
        sleep 1
      fi
    fi
    key=1
  fi
  if [ $key = '[A' ]
  then
    if [ $x = 1 ] && [ $y -gt 1 ]
    then
      y=y-1
    elif [ $x = 2 ] && [ $y2 -gt 1 ]
    then
      y2=y2-1
    elif [ $x = 2 ] && [ $y2 = 1 ] && [ $jump -ge 1 ]
    then
      jump=jump-1
    fi
  elif [ $key = '[B' ]
  then
    if [ $x = 1 ] && [ $y -lt 20 ] && [ $y -lt $user_num ]
    then
      y=y+1
    elif [ $x = 2 ] && [ $y2 -lt 20 ] && [ $y2 -lt $userprocess_num ]
    then
      y2=y2+1
    elif [ $x = 2 ] && [ $y2 = 20 ] && [ $(($jump+20)) -lt $userprocess_num ]
    then
      jump=jump+1
    fi
  elif [ $key = '[C' ]
  then
    if [ $x = 1 ] && [ $userprocess_num -ge 1 ]
    then
      x=x+1
    fi
  elif [ $key = '[D' ]
  then
    if [ $x = 2 ]
    then
      x=x-1
      y2=1
      jump=0
    fi
  elif [ $key = 'q' ] || [ $key = 'Q' ]
  then
    quit=0
  elif [ $key = 'p' ] || [ $key = 'P' ]
  then
    if [ $x = 2 ] && [ $((29+$jump)) -lt $userprocess_num ]
    then
      jump=jump+10
    fi
  elif [ $key = 'm' ] || [ $key = 'M' ]
  then
    if [ $x = 2 ] && [ $jump -ge 10 ]
    then
      jump=jump-10
    fi
  fi
}

declare -i n=0
declare -i x=1
declare -i y=1
declare -i y2=1
declare -i i=0
declare -i quit=1
declare -i jump=0
declare -i FG_check=0

while [ $quit = 1 ]
do
  clear
  get_process
  print_bonus
  print_all
  input_key
done
