*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations
class lcl_connection definition.

  public section.

  CLASS-DATA conn_counter TYPE i READ-ONLY.

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
    DATA carrier_id      TYPE /dmo/carrier_id.
    DATA connection_id   TYPE /dmo/connection_id.

    DATA airport_from_id TYPE /dmo/airport_from_id.
    DATA airport_to_id   TYPE /dmo/airport_to_id.

    DATA carrier_name    TYPE /dmo/carrier_name.

endclass.

class lcl_connection implementation.

  METHOD set_attributes.

    carrier_id    = i_carrier_id.
    connection_id = i_connection_id.

  ENDMETHOD.

  METHOD get_output.

    APPEND |Carrier:     { carrier_id } { carrier_name }| TO r_output.

  ENDMETHOD.

  method constructor.


  IF i_carrier_id IS INITIAL OR i_connection_id IS INITIAL.
    RAISE EXCEPTION TYPE cx_abap_invalid_value.
  ENDIF.


*    SELECT SINGLE
*      FROM /dmo/connection
*    FIELDS airport_from_id, airport_to_id
*     WHERE carrier_id    = @i_carrier_id
*       AND connection_id = @i_connection_id
*      INTO ( @airport_from_id, @airport_to_id ).


    SELECT SINGLE
      FROM /DMO/I_Connection
    FIELDS DepartureAirport, DestinationAirport, \_Airline-Name
     WHERE AirlineID    = @i_carrier_id
       AND ConnectionID = @i_connection_id
      INTO ( @airport_from_id, @airport_to_id, @carrier_name  ).

   IF sy-subrc <> 0.
      RAISE EXCEPTION TYPE cx_abap_invalid_value.
   ENDIF.

    me->carrier_id = i_carrier_id.
    me->connection_id = i_connection_id.

    conn_counter = conn_counter + 1.

  endmethod.

endclass.
