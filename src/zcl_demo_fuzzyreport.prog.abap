*&---------------------------------------------------------------------*
*& Report zcl_demo_fuzzyreport
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zcl_demo_fuzzyreport.
TYPES: type_p TYPE p LENGTH 3 DECIMALS 2.

       TYPES: BEGIN of TY_1,
              score TYPE type_p,
              carrid TYPE scarr-carrid,
              carrname TYPE scarr-carrname,
              END of TY_1.
TYPES: tt_scarr TYPE STANDARD TABLE OF ty_1.

DATA:it_scarr TYPE tt_scarr,
     wa_scarr LIKE LINE of it_scarr.

PARAMETERS: p_carr TYPE scarr-carrname.

CALL METHOD zcl_demo_fuzzysearch=>demo_fuzzy
EXPORTING
*               im_carrname = Áirline'
                im_carrname = p_carr
IMPORTING
    ex_details = it_scarr.
WRITE:(10) 'Score' CENTERED,
(15) 'Carrier ID' CENTERED,
(30) 'Carrier name' CENTERED.
WRITE:/ SY-ULINE(60).

LOOP AT it_scarr into wa_scarr.
WRITE:/(10) wa_scarr-score CENTERED,
       (15) wa_scarr-carrid CENTERED,
       (30) wa_scarr-carrname CENTERED.
ENDLOOP.
