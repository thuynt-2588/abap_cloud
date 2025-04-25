CLASS zcl_bos_eml_thuyd DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_bos_eml_thuyd IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

     DATA agencies_upd TYPE TABLE FOR UPDATE /DMO/I_AgencyTP.

     agencies_upd = VALUE #( ( agencyid = '0700##' name = 'Some fancy new name' ) ).


     MODIFY ENTITIES OF /dmo/i_agencytp
        ENTITY /dmo/agency
        UPDATE FIELDS ( name )
          WITH agencies_upd.

     COMMIT ENTITIES.

     out->write( `Method execution finished!`  ).

  ENDMETHOD.
ENDCLASS.
