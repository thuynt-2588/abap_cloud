CLASS zcl_hello_world_thuyd DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_hello_world_thuyd IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.
  out->write( 'Hello ThuyD' ).
  ENDMETHOD.
ENDCLASS.
