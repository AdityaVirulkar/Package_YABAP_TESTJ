CLASS zcl_demo_fuzzysearch DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
  INTERFACES if_amdp_marker_hdb.
  TYPES: type_p TYPE p LENGTH 3 DECIMALS 2.

  TYPES:BEGIN OF TY_1,
        score TYPE type_p,
        carrid TYPE scarr-carrid,
        carrname TYPE scarr-carrname,
        END of TY_1.
  TYPES:tt_scarr TYPE STANDARD TABLE of TY_1.

  CLASS-METHODS demo_fuzzy
                IMPORTING VALUE(im_carrname) TYPE scarr-carrname
                EXPORTING VALUE(ex_details) TYPE tt_scarr.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS zcl_demo_fuzzysearch IMPLEMENTATION.
METHOD demo_fuzzy BY DATABASE PROCEDURE FOR HDB LANGUAGE SQLSCRIPT
                  OPTIONS READ-ONLY
                  USING SCARR.
       ex_details = SELECT score() as score, carrid, carrname FROM SCARR
                    WHERE CONTAINS( carrname,im_carrname,FUZZY( 0.5 )) AND
                    MANDT = '100' ORDER BY 1;
ENDMETHOD.

ENDCLASS.
