*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations
class lcl_connection definition.

  public section.

  CLASS-DATA conn_counter TYPE i READ-ONLY.
  CLASS-METHODS class_constructor.

* Methods
    METHODS set_attributes
      IMPORTING
        i_carrier_id    TYPE /dmo/carrier_id
        i_connection_id TYPE /dmo/connection_id
      RAISING
        cx_abap_invalid_value.

" Functional Method
    METHODS get_output
      returning
        value(r_output) type string_table.

    METHODS constructor
      IMPORTING
        i_carrier_id TYPE /dmo/carrier_id
        i_connection_id TYPE /dmo/connection_id
       RAISING
        cx_ABAP_INVALID_VALUE.

  protected section.
  private section.

   TYPES:
      BEGIN OF st_details,
        DepartureAirport   TYPE /dmo/airport_from_id,
        DestinationAirport TYPE /dmo/airport_to_id,
        AirlineName        TYPE /dmo/carrier_name,
      END OF st_details.

    TYPES:
      BEGIN OF st_airport,
        AirportId TYPE /dmo/airport_id,
        Name      TYPE /dmo/airport_name,
      END OF st_airport.

    TYPES tt_airports TYPE STANDARD TABLE OF st_airport
                           WITH NON-UNIQUE DEFAULT KEY.

    CLASS-DATA airports TYPE tt_airports.

    DATA carrier_id      TYPE /dmo/carrier_id.
    DATA connection_id   TYPE /dmo/connection_id.

    DATA details TYPE st_details.

endclass.

class lcl_connection implementation.

  method class_constructor.

     SELECT FROM /DMO/I_Airport
          FIELDS AirportID, Name
            INTO TABLE @airports.

  endmethod.

  METHOD set_attributes.

    carrier_id    = i_carrier_id.
    connection_id = i_connection_id.

  ENDMETHOD.

  METHOD get_output.

  DATA(departure)   = airports[ airportID = details-departureairport   ].
  DATA(destination) = airports[ airportID = details-destinationairport ].


    APPEND |Departure:   { details-departureairport   } { departure-name   }| TO r_output.
    APPEND |Destination: { details-destinationairport } { destination-name }| TO r_output.

  ENDMETHOD.

  method constructor.


  IF i_carrier_id IS INITIAL OR i_connection_id IS INITIAL.
    RAISE EXCEPTION TYPE cx_abap_invalid_value.
  ENDIF.

    SELECT SINGLE
      FROM /DMO/I_Connection
    FIELDS DepartureAirport, DestinationAirport, \_Airline-Name as AirlineName
     WHERE AirlineID    = @i_carrier_id
       AND ConnectionID = @i_connection_id
      INTO CORRESPONDING FIELDS OF @details.

   IF sy-subrc <> 0.
      RAISE EXCEPTION TYPE cx_abap_invalid_value.
   ENDIF.

    me->carrier_id = i_carrier_id.
    me->connection_id = i_connection_id.

    conn_counter = conn_counter + 1.

    endmethod.

endclass.
