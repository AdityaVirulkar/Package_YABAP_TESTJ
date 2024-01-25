*&---------------------------------------------------------------------*
*& Report  ZCIMP_COMPARISON
*&
*&---------------------------------------------------------------------*
*& Change Log
*& Name : Kritika
*& Date : 17 Dec 2015
*& Description : To add Target Mandatory field in final results &
*& making format for final as '|' delimited to get proper results
*&---------------------------------------------------------------------*
*& Change Log
*& Name : TESTJ
*& Date : 09 Aug 2021
*& Description :
*&
*&---------------------------------------------------------------------*
REPORT  Y_SCREEN_PARE_TESTJ
        LINE-SIZE 1000
        MESSAGE-ID su.


TABLES : tstc,
         d020t.
* transaction codes
DATA : BEGIN OF i_tcodes OCCURS 0,
         tcode(20) TYPE c,
         pgmna(40) TYPE c,
       END OF i_tcodes.

* TSTC - with Program names
DATA : BEGIN OF i_tstc1 OCCURS 0,
        tcode LIKE tstc-tcode,
        pgmna LIKE tstc-pgmna,
        dypno LIKE tstc-dypno,
       END   OF i_tstc1.
* screen descriptions
DATA : BEGIN OF i_d020t OCCURS 0,
         prog LIKE d020t-prog,
         dynr LIKE d020t-dynr,
         lang LIKE d020t-lang,
         dtxt LIKE d020t-dtxt,
       END OF i_d020t.
* transaction tree

DATA: BEGIN OF i_screens OCCURS 0,
         tcode LIKE tstc-tcode,
         programnm(40) TYPE c,
         screen LIKE tstc-dypno,
         fieldnm(132) TYPE c,
         desc TYPE char255,
         mandatory TYPE flag,
        END OF i_screens.



TYPES: BEGIN OF t_screens,
         tcode         TYPE tstc-tcode,
         programnm(40) TYPE c,
         screen       TYPE tstc-dypno,
         fieldnm(132) TYPE c,
         desc         TYPE string,
         mandatory    TYPE flag,
         done         TYPE flag,
        END OF t_screens.

TYPES : BEGIN OF t_screens3.
        INCLUDE TYPE t_screens.
TYPES:  type TYPE c,
        desc2 TYPE string,
* Begin of changes by KS-17/12
        mand2 TYPE flag,
* End of changes by KS-17/12
     END OF t_screens3.

DATA: abaptext_pri TYPE TABLE OF abaptxt255,
      w_text TYPE abaptxt255.
DATA: abaptext_sec TYPE TABLE OF abaptxt255.
DATA: abaptext TYPE TABLE OF abaptxt255.

DATA: trdir_sec TYPE trdir OCCURS 1 WITH HEADER LINE.
DATA: trdir_delta TYPE xtrdir OCCURS 1 WITH HEADER LINE.
DATA: trdir_pri TYPE trdir OCCURS 1 WITH HEADER LINE.
DATA: abaptext_delta TYPE TABLE OF  vxabapt255,
      w_delta TYPE vxabapt255.


DATA:  lt_screen1 TYPE TABLE OF t_screens,
       lt_screen2 TYPE TABLE OF t_screens,
       lt_screen3 TYPE TABLE OF t_screens3,
       ls_screen TYPE t_screens,
       ls_screen2 TYPE t_screens,
       ls_screen3 TYPE t_screens3.
* screen fields
DATA  BEGIN OF i_dynp_fields OCCURS 20.
        INCLUDE STRUCTURE rsdcf.
DATA  END OF i_dynp_fields.
* screen lines
DATA  BEGIN OF i_lines OCCURS 20.
        INCLUDE STRUCTURE tline.
DATA  END OF i_lines.

DATA: v_file TYPE string.

* Text file containing transaction list to be dowmloaded
PARAMETERS: p_fpath1 TYPE rlgrap-filename,
            p_fpath2 TYPE rlgrap-filename,
            p_fpath3 TYPE rlgrap-filename.


AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_fpath1.
  PERFORM f_get_filename CHANGING p_fpath1.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_fpath2.
  PERFORM f_get_filename CHANGING p_fpath2.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_fpath3.
  PERFORM f_get_filename CHANGING p_fpath3.


START-OF-SELECTION.
IF sy-sysid = 'DG3' or sy-sysid = 'XG4' or sy-sysid = 'XR4' or sy-sysid = 'DR3' or sy-sysid = 'ILA'.
* validate all the transaction codes
  PERFORM f_upload.
* get the screen fields info
  PERFORM f_compare.
* download the results to file
  PERFORM f_download_results.
* display the report
  PERFORM f_display_report.
*    WRITE :/ 'This Tool is not compatible with your system. Please check with POC.'.
  ENDIF.


*&---------------------------------------------------------------------*
*&      Form  f_upload
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM f_upload.

  v_file = p_fpath1.
  CALL FUNCTION 'GUI_UPLOAD'
    EXPORTING
      filename = v_file
    TABLES
      data_tab = abaptext
    EXCEPTIONS
      OTHERS   = 17.

  LOOP AT abaptext INTO w_text.
    SPLIT w_text AT cl_abap_char_utilities=>horizontal_tab
    INTO ls_screen-tcode
         ls_screen-programnm
         ls_screen-screen
         ls_screen-fieldnm
         ls_screen-desc
         ls_screen-mandatory .

    CONDENSE:ls_screen-tcode, ls_screen-programnm,
             ls_screen-desc, ls_screen-mandatory,
             ls_screen-fieldnm.

*** Begin of changes by Rahul
    IF ls_screen-screen EQ 0000.
      CONTINUE.
    ELSE.
      APPEND ls_screen TO lt_screen1.
    ENDIF.
** End of changes by Rahul
* Begin of changes by KS on 28/12/2015-Removing code
*    CLEAR w_text.
*    CONCATENATE ls_screen-tcode
*        ls_screen-programnm
*        ls_screen-screen
*        ls_screen-fieldnm
*        ls_screen-desc
*        ls_screen-mandatory INTO w_text SEPARATED BY
*   cl_abap_char_utilities=>horizontal_tab.
*    APPEND w_text TO abaptext_sec.
*    CLEAR: w_text, ls_screen.
*  ENDLOOP.
*  IF sy-subrc <> 0.
*  ENDIF.
  ENDLOOP.
* End of changes by KS on 28/12/2015

  CLEAR abaptext[].
  v_file = p_fpath2.
  CALL FUNCTION 'GUI_UPLOAD'
    EXPORTING
      filename = v_file
    TABLES
      data_tab = abaptext
    EXCEPTIONS
      OTHERS   = 17.
  IF sy-subrc <> 0.
  ENDIF.
  LOOP AT abaptext INTO w_text.
    SPLIT w_text AT cl_abap_char_utilities=>horizontal_tab
    INTO ls_screen-tcode
         ls_screen-programnm
         ls_screen-screen
         ls_screen-fieldnm
         ls_screen-desc
         ls_screen-mandatory .

    CONDENSE: ls_screen-tcode, ls_screen-programnm,
             ls_screen-desc, ls_screen-mandatory,
             ls_screen-fieldnm.
*    APPEND ls_screen TO lt_screen2.
*** Begin of changes by Rahul
    IF ls_screen-screen EQ 0000.
      CONTINUE.
    ELSE.
      APPEND ls_screen TO lt_screen2.
    ENDIF.
** End of changes by Rahul
* Begin of changes by KS on 28/12/2015-Removing code
*    CLEAR w_text.
*    CONCATENATE ls_screen-tcode
*        ls_screen-programnm
*        ls_screen-screen
*        ls_screen-fieldnm
*        ls_screen-desc
*        ls_screen-mandatory INTO w_text SEPARATED BY
*   cl_abap_char_utilities=>horizontal_tab.
*    APPEND w_text TO abaptext_pri.
*    CLEAR: ls_screen, w_text.

* End of changes by KS on 28/12/2015
  ENDLOOP.
  SORT lt_screen2 BY tcode programnm screen fieldnm.
ENDFORM.                    " f_upload

*&---------------------------------------------------------------------*
*&      Form  f_download_results
*&---------------------------------------------------------------------*
*       download the results to flat file
*----------------------------------------------------------------------*
*      -->P_P_FPATH2   fiepath containing the screen definitions
*----------------------------------------------------------------------*

FORM f_download_results.

* Begin of changes by KS-17/12
  TYPES: begin of ty_final,
  line type string,
  end of ty_final.
  DATA: it_final TYPE STANDARD TABLE OF ty_final,
      wa_final TYPE ty_final,
      lv_final TYPE string.
LOOP AT lt_screen3 INTO ls_screen3.
  CONCATENATE ls_screen3-tcode  '|'
         ls_screen3-programnm  '|'
         ls_screen3-screen  '|'
         ls_screen3-fieldnm  '|'
         ls_screen3-desc  '|'
         ls_screen3-mandatory  '|'
         ls_screen3-type  '|'
*Begin of changes by KS on 28/12/2015
*         ls_screen3-done  '|'
*End of changes by KS on 28/12/2015
        ls_screen3-desc2  '|'
        ls_screen3-mand2  '|'
        into lv_final.
 wa_final-line = lv_final.
APPEND wa_final to it_final.
clear wa_final.


ENDLOOP.
* End of changes by KS-17/12
  v_file = p_fpath3.
  CALL FUNCTION 'GUI_DOWNLOAD'
    EXPORTING
      filename              = v_file
* Begin of changes by KS-17/12
*      filetype              = 'DAT'
*      write_field_separator = 'X'
* End of changes by KS-17/12
    TABLES
* Begin of changes by KS-17/12
*      data_tab              = lt_screen3
      data_tab              = it_final
* End of changes by KS-17/12
    EXCEPTIONS
      OTHERS                = 01.
  IF sy-subrc <> 0.
  ENDIF.
ENDFORM.                    " f_download_results

*&---------------------------------------------------------------------*
*&      Form  f_display_report
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM f_display_report .
  WRITE :/03 'File downloaded to specified path'.

ENDFORM.                    " f_display_report
*&---------------------------------------------------------------------*
*&      Form  f_get_filename
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_PATH     text
*----------------------------------------------------------------------*
FORM f_get_filename CHANGING p_path TYPE rlgrap-filename.
  CALL FUNCTION 'F4_FILENAME'
** EXPORTING
**   PROGRAM_NAME        = sy-repid
**   DYNPRO_NUMBER       = SYST-DYNNR
**   FIELD_NAME          = ' '
   IMPORTING
     file_name           = p_path
            .
ENDFORM.                    " f_get_filename
*&---------------------------------------------------------------------*
*&      Form  F_COMPARE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_compare .

  FIELD-SYMBOLS <f_screen2> TYPE t_screens.

  LOOP AT lt_screen1 INTO ls_screen.
    MOVE-CORRESPONDING ls_screen TO ls_screen3.
    READ TABLE lt_screen2 ASSIGNING <f_screen2>
               WITH KEY tcode = ls_screen-tcode
                        programnm = ls_screen-programnm
                        screen = ls_screen-screen
                        fieldnm = ls_screen-fieldnm
              BINARY SEARCH.
    IF sy-subrc = 0.
      <f_screen2>-done = 'X'.
      IF <f_screen2>-desc NE ls_screen-desc.
        ls_screen3-type = 'U'.
        ls_screen3-desc2 = <f_screen2>-desc.
* Begin of changes by KS-17/12
              ls_screen3-mand2 = <f_screen2>-mandatory.
* End of changes by KS-17/12
      ENDIF.
    ELSE.
      ls_screen3-type = 'D'.
    ENDIF.
    IF ls_screen3-type IS NOT INITIAL.
      APPEND ls_screen3 TO lt_screen3.
    ENDIF.
    CLEAR:  ls_screen, ls_screen3.
  ENDLOOP.

  DELETE lt_screen2 WHERE done = 'X'.
  LOOP AT lt_screen2 INTO ls_screen2.
    MOVE-CORRESPONDING ls_screen2 TO ls_screen3.
* Begin of changes by KS on 28/12/2015
    CLEAR : ls_screen3-desc, ls_screen3-mandatory.
    ls_screen3-desc2 = ls_screen2-desc.
    ls_screen3-mand2 = ls_screen2-mandatory.
* End of changes by KS on 28/12/2015
    ls_screen3-type = 'I'.
    APPEND ls_screen3 TO lt_screen3.
    CLEAR: ls_screen2, ls_screen3.
  ENDLOOP.
  SORT lt_screen3 BY tcode programnm screen fieldnm.
ENDFORM.                    " F_COMPARE
