#! /bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"
echo -e "\n~~~~~ Salon Appointment Scheduler ~~~~~\n"

echo -e "Welcome to Our Compagnie | How may I help you?\n"


MAIN_MENU() {

  #available_services
  
  AVAILABLE_SERVICES=$($PSQL "SELECT service_id, name FROM services ORDER BY service_id;")
  
  #how the display will look like
  
  echo "$AVAILABLE_SERVICES" | while read SERVICE_ID BAR SERVICE_NAME
  do
    echo "$SERVICE_ID) $SERVICE_NAME"
  done


  #read the coice of the user
  
  read SERVICE_ID_SELECTED
  SERVICE_ID_SELECTED_F=$($PSQL "SELECT service_id FROM services WHERE service_id = $SERVICE_ID_SELECTED;")

  #if the choice does not figure on the list
  
  if [[ -z $SERVICE_ID_SELECTED_F ]]
  then

    #send to main menu
    
    MAIN_MENU "Please enter a valid service number."
  
  else

    #get customer info
    
    echo -e "\nWhat's your phone number?"
    read CUSTOMER_PHONE

    #IF the customer is already on th db
    
    CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE';")

    #if not found
    
    if [[ -z $CUSTOMER_ID ]]
    then

      #The Name of the client
      
      echo -e "\nWhat's your name?"
      read CUSTOMER_NAME

      #insert into customers phone & name
      
      CUSTOMER_PHONE_NAME=$($PSQL "INSERT INTO customers(name, phone) VALUES('$CUSTOMER_NAME', '$CUSTOMER_PHONE');")

      #The id of the customer
      
      CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE';")

    
    fi

    # schedul an appointement
    
    echo -e "\nCan you Choose a time slot for you?"
    read SERVICE_TIME

    #insert into appointments customer_id & service_id & time
    
    CLIENT_ID_SERVICE_ID_TIME_IN_DB=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME');")
    
    #Related service name
    
    SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED;")

    #retrieve customer name
    
    CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE';")

    #output message
    
    echo "I have put you down for a $SERVICE_NAME at $SERVICE_TIME,$CUSTOMER_NAME."
  fi
}
MAIN_MENU

