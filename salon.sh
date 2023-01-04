#! /bin/bash
PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"
echo -e "\n~~~~~ Jeff's Salon ~~~~~\n"

SERVICE_MENU(){
  if [[ $1 ]]
  then
    echo -e "\n$1"
  fi

  echo "Please select which service you will be scheduling." 
  echo -e "\n1) Basic Manicure\n2) Hot Oil Manicure\n3) Basic Pedicure\n4) Hot Oil Pedicure"
  read SERVICE_ID_SELECTED
  
  case $SERVICE_ID_SELECTED in
    1) SCHEDULER ;;
    2) SCHEDULER ;;
    3) SCHEDULER ;;
    4) SCHEDULER ;;
    *) SERVICE_MENU "Please enter a valid service number." ;;

    esac
}

  SCHEDULER(){
    SELECTION=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED")
    echo -e "\nYou selected $(echo $SELECTION | sed -r 's/^ *| *$//g')."
    # Enter phone number
    echo -e "\nWhat is your phone number?"
    read CUSTOMER_PHONE
    CUSTOMER_NAME_LOOKUP=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")

    # Enter a name if phone number lookup gives null
    if [[ -z $CUSTOMER_NAME_LOOKUP ]]
    # new customers
    then
      echo -e "\nWe love our first time customers! \nWhat is your name?"
      read CUSTOMER_NAME
        ADD_CUSTOMER_INFO=$($PSQL "INSERT INTO customers(phone, name) VALUES('$CUSTOMER_PHONE','$CUSTOMER_NAME')")
          echo -e "\nHello $CUSTOMER_NAME, what time would you like your appointment?"
      read SERVICE_TIME
        GET_CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE name='$CUSTOMER_NAME' AND phone='$CUSTOMER_PHONE'")
        ADD_APPOINTMENT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($GET_CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")
          if [[ $ADD_APPOINTMENT == "INSERT 0 1" ]]
          then
          echo -e "\nI have put you down for a $(echo $SELECTION | sed -r 's/^ *| *$//g') at $SERVICE_TIME, $(echo $CUSTOMER_NAME | sed -r 's/^ *| *$//g')."
          fi
    else
      # old customers
      # ask the customer for the appointment time
      echo -e "\nHello$CUSTOMER_NAME_LOOKUP, what time would you like your appointment?"
      # upon valid appointment time, state the customers service, name, and time back to them.
      read SERVICE_TIME
        LOOKUP_CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
        ADD_APPOINTMENT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($LOOKUP_CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")
          if [[ $ADD_APPOINTMENT == "INSERT 0 1" ]]
          then
          echo -e "\nI have put you down for a $(echo $SELECTION | sed -r 's/^ *| *$//g') at $SERVICE_TIME, $(echo $CUSTOMER_NAME_LOOKUP | sed -r 's/^ *| *$//g')."
          fi
          # update the appointments table
    fi
    # Enter an appointment time
  }
  # HOT_OIL_MANICURE(){
  #   echo -e "\nYou selected hot oil manicure."
  #   # Enter phone number
  #   echo -e "\nWhat is your phone number?"
  #   read CUSTOMER_PHONE
  #   CUSTOMER_NAME_LOOKUP=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")

  #   # Enter a name if phone number lookup gives null
  #   if [[ -z $CUSTOMER_NAME_LOOKUP ]]
  #   then
  #   echo -e "\nFirst time customer. what is your name?"
  #   read CUSTOMER_NAME
  #   ADD_CUSTOMER_INFO=$($PSQL "INSERT INTO customers(phone, name) VALUES('$CUSTOMER_PHONE','$CUSTOMER_NAME')")
  #   echo -e "\nHello $CUSTOMER_NAME, what time would you like your appointment?"
  #   read SERVICE_TIME
  #   GET_CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE name='$CUSTOMER_NAME' AND phone='$CUSTOMER_PHONE'")
  #   ADD_APPOINTMENT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($GET_CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")
  #   SERVICE_NAME=$($PSQL "SELECT name FROM appointments LEFT JOIN services ON appointments.service_id=services.service_id WHERE customer_id=$GET_CUSTOMER_ID")
  #   echo -e "\nI have you put down for a$SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
  #   else
  #   # ask the customer for the appointment time
  #   echo -e "\nHello$CUSTOMER_NAME_LOOKUP, what time would you like your appointment?"
  #   # upon valid appointment time, state the customers service, name, and time back to them.
  #   read SERVICE_TIME
  #   LOOKUP_CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
  #   ADD_APPOINTMENT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($LOOKUP_CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")
  #   SERVICE_NAME=$($PSQL "SELECT name FROM appointments LEFT JOIN services ON appointments.service_id=services.service_id WHERE customer_id=$LOOKUP_CUSTOMER_ID AND time='$SERVICE_TIME'")
  #   echo -e "\nI have put you down for a$SERVICE_NAME at $SERVICE_TIME,$CUSTOMER_NAME_LOOKUP."
  #   # update the appointments table
  #   fi
  #   # Enter an appointment time
  # }
  # BASIC_PEDICURE(){
  #   echo -e "\nYou selected basic pedicure."
  #   # Enter phone number
  #   echo -e "\nWhat is your phone number?"
  #   read CUSTOMER_PHONE
  #   CUSTOMER_NAME_LOOKUP=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")

  #   # Enter a name if phone number lookup gives null
  #   if [[ -z $CUSTOMER_NAME_LOOKUP ]]
  #   then
  #   echo -e "\nFirst time customer. what is your name?"
  #   read CUSTOMER_NAME
  #   ADD_CUSTOMER_INFO=$($PSQL "INSERT INTO customers(phone, name) VALUES('$CUSTOMER_PHONE','$CUSTOMER_NAME')")
  #   echo -e "\nHello $CUSTOMER_NAME, what time would you like your appointment?"
  #   read SERVICE_TIME
  #   GET_CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE name='$CUSTOMER_NAME' AND phone='$CUSTOMER_PHONE'")
  #   ADD_APPOINTMENT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($GET_CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")
  #   SERVICE_NAME=$($PSQL "SELECT name FROM appointments LEFT JOIN services ON appointments.service_id=services.service_id WHERE customer_id=$GET_CUSTOMER_ID")
  #   echo -e "\nI have you put down for a$SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
  #   else
  #   # ask the customer for the appointment time
  #   echo -e "\nHello$CUSTOMER_NAME_LOOKUP, what time would you like your appointment?"
  #   # upon valid appointment time, state the customers service, name, and time back to them.
  #   read SERVICE_TIME
  #   LOOKUP_CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
  #   ADD_APPOINTMENT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($LOOKUP_CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")
  #   SERVICE_NAME=$($PSQL "SELECT name FROM appointments LEFT JOIN services ON appointments.service_id=services.service_id WHERE customer_id=$LOOKUP_CUSTOMER_ID AND time='$SERVICE_TIME'")
  #   echo -e "\nI have put you down for a$SERVICE_NAME at $SERVICE_TIME,$CUSTOMER_NAME_LOOKUP."
  #   # update the appointments table
  #   fi
  #   # Enter an appointment time
  # }
  # HOT_OIL_PEDICURE(){
  #   echo -e "\nYou selected hot oil pedicure."
  #   # Enter phone number
  #   echo -e "\nWhat is your phone number?"
  #   read CUSTOMER_PHONE
  #   CUSTOMER_NAME_LOOKUP=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")

  #   # Enter a name if phone number lookup gives null
  #   if [[ -z $CUSTOMER_NAME_LOOKUP ]]
  #   then
  #   echo -e "\nFirst time customer. what is your name?"
  #   read CUSTOMER_NAME
  #   ADD_CUSTOMER_INFO=$($PSQL "INSERT INTO customers(phone, name) VALUES('$CUSTOMER_PHONE','$CUSTOMER_NAME')")
  #   echo -e "\nHello $CUSTOMER_NAME, what time would you like your appointment?"
  #   read SERVICE_TIME
  #   GET_CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE name='$CUSTOMER_NAME' AND phone='$CUSTOMER_PHONE'")
  #   ADD_APPOINTMENT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($GET_CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")
  #   SERVICE_NAME=$($PSQL "SELECT name FROM appointments LEFT JOIN services ON appointments.service_id=services.service_id WHERE customer_id=$GET_CUSTOMER_ID")
  #   echo -e "\nI have you put down for a$SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
  #   else
  #   # ask the customer for the appointment time
  #   echo -e "\nHello$CUSTOMER_NAME_LOOKUP, what time would you like your appointment?"
  #   # upon valid appointment time, state the customers service, name, and time back to them.
  #   read SERVICE_TIME
  #   LOOKUP_CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
  #   ADD_APPOINTMENT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($LOOKUP_CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")
  #   SERVICE_NAME=$($PSQL "SELECT name FROM appointments LEFT JOIN services ON appointments.service_id=services.service_id WHERE customer_id=$LOOKUP_CUSTOMER_ID AND time='$SERVICE_TIME'")
  #   echo -e "\nI have put you down for a$SERVICE_NAME at $SERVICE_TIME,$CUSTOMER_NAME_LOOKUP."
  #   # update the appointments table
  #   fi
  #   # Enter an appointment time
  # }
  
SERVICE_MENU