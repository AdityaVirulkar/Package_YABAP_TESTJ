*&---------------------------------------------------------------------*
*& Report YTESTJ1
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ytestj1.

TYPES: BEGIN OF s_excel.
         INCLUDE STRUCTURE alsmex_tabline.
TYPES END OF s_excel.


TYPES: BEGIN OF ty_f1,
         s4_hana_changes                 TYPE varchar(4), ""S4 HANA Changes       A
         object                          TYPE varchar(40), ""char(8), ""Object      B
         object_type                     TYPE trobjtype, ""Object Type            C
         obsolete                        TYPE char(8) , ""OBSOLETE                D
         description                     TYPE char (8), ""DESCRIPTION             E
         afffected_area                  TYPE char(8), ""AFFECTED AREA            F
         related_notes                   TYPE char(30), ""RELATED NOTES           G
         solution_step                   TYPE char(30), ""SOLUTION STEPS          H
         error_category_num              TYPE char(30), ""ERROR_CATEGORY_NUM      I
         version                         TYPE char(30), ""VERSION                 J
         identifier                      TYPE char(30), ""IDENTIFIER              K
         complexity                      TYPE char(30), ""COMPLEXITY              L
         issue_category                  TYPE char(30), ""ISSUE CATEGORY          M
         error_category                  TYPE char(30), ""ERROR_CATEGORY          N
         trigger_object                  TYPE char(30), "" TRIGGER OBJECT         O
         remediation_category            TYPE char(30),  ""REMEDIATION CATEGORY   P
         sap_simplification_list_chapter TYPE char(30), ""SAP SIMPLIFICATION LIST CHAPTER Q
         application_component           TYPE char(30), ""APPLICATION COMPONENT   R
         sap_simpl_category              TYPE char(30), ""SAP SIMPL CATEGORY      S
         item_area                       TYPE char(30), ""ITEM AREA               T
       END OF ty_f1,

       BEGIN OF ty_f2,
         identifier    TYPE char(30), ""Identifier      A
         version       TYPE char(30), ""Version         B
         valid_to      TYPE char(30), ""Valid To        C
         object        TYPE char(30), ""Object          D
         sub-object    TYPE char(30), ""Sub-Object      E
         object_type   TYPE char(30), "OBJECT TYPE"     F
         screen_name   TYPE char(30), ""Screen name     G
         screen_no     TYPE char(30), ""Screen no       H
         obselete      TYPE char(30), ""Obselete        I
         length        TYPE char(30), "" Length         J
         affected_area TYPE char(30), ""Affected area   K
         details       TYPE char(30), ""Details         L
       END OF ty_f2,

       BEGIN OF ty_f3,
       END OF ty_f3.
DATA: i_excel1 TYPE STANDARD TABLE OF s_excel WITH HEADER LINE.
DATA: i_excel2 TYPE STANDARD TABLE OF s_excel WITH HEADER LINE.

DATA:it_f1 TYPE STANDARD TABLE OF ty_f1 INITIAL SIZE 0,
     wa_f1 TYPE ty_f1.
DATA:it_f2 TYPE STANDARD TABLE OF ty_f2 INITIAL SIZE 0,
     wa_f2 TYPE ty_f2.

DATA:it_f3 TYPE STANDARD TABLE OF ty_f3 INITIAL SIZE 0,
     wa_f3 TYPE ty_f3.

DATA:it_output3 TYPE STANDARD TABLE OF ty_f1 INITIAL SIZE 0,
     wa_output3 TYPE ty_f1.

DATA:it_output4 TYPE STANDARD TABLE OF ty_f2 INITIAL SIZE 0,
     wa_output4 TYPE ty_f2.

DATA: gd_currentrow TYPE i.

SELECTION-SCREEN: BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
  PARAMETERS: s_input1 TYPE rlgrap-filename,
              s_input2 TYPE rlgrap-filename,
              s_begrow1 TYPE i DEFAULT 2,
              s_begrow2 TYPE i DEFAULT 2,
              s_endrow1 TYPE i DEFAULT 469985.
              s_endrow2 TYPE i DEFAULT 459822.
*              s_input2 TYPE rlgrap-filename,
*              s_output3 TYPE rlgrap-filename.
SELECTION-SCREEN: END OF BLOCK b1.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR s_file.

  CALL FUNCTION 'F4_FILENAME'
*   EXPORTING
*     PROGRAM_NAME        = SYST-CPROG
*     DYNPRO_NUMBER       = SYST-DYNNR
*     FIELD_NAME          = ' '
    IMPORTING
      file_name = s_input1.


START-OF-SELECTION.

  IF s_input1 IS NOT INITIAL.
    CALL FUNCTION 'ALSM_EXCEL_TO_INTERNAL_TABLE'
      EXPORTING
        filename    = s_input1
        i_begin_col = '1'
        i_begin_row = s_begrow1
        i_end_col   = '20'
        i_end_row   = s_endrow1
      TABLES
        intern      = i_excel1.
 EXCEPTIONS
       INCONSISTENT_PARAMETERS       = 1
       UPLOAD_OLE  = 2
       OTHERS      = 3
    .
    IF sy-subrc <> 0.
* Implement suitable error handling here
      MESSAGE 'Problem uploading Excel sheet' TYPE i.
      STOP.
    ENDIF.

END-OF-SELECTION.

  LOOP AT i_excel1.
    CASE i_excel1-col.
      WHEN '0001'.
        wa_output3-s4hana_changes = i_excel1-value.
      WHEN '0002'.
        wa_output3-s4hana_changes = i_excel1-value.
      WHEN '0003'.
        wa_output3-s4hana_changes = i_excel1-value.
      WHEN '0004'.
        wa_output3-s4hana_changes = i_excel1-value.
      WHEN '0005'.
        wa_output3-s4hana_changes= i_excel1-value.
      WHEN '0006'.
        wa_output3-s4hana_changes = i_excel1-value.
      WHEN '0007'.
        wa_output3-s4hana_changes = i_excel1-value.
      WHEN '0008'.
        wa_output3-s4hana_changes = i_excel1-value.
      WHEN '0009'.
        wa_output3-s4hana_changes = i_excel1-value.
      WHEN '0010'.
        wa_output3-s4hana_changes= i_excel1-value.
      WHEN '0011'.
        wa_output3-s4hana_changes = i_excel1-value.
      WHEN '0012'.
        wa_output3-s4hana_changes = i_excel1-value.
      WHEN '0013'.
        wa_output3-s4hana_changes = i_excel1-value.
      WHEN '0014'.
        wa_output3-s4hana_changes = i_excel1-value.
      WHEN '0015'.
        wa_output3-s4hana_changes = i_excel1-value.
      WHEN '0016'.
        wa_output3-s4hana_changes = i_excel1-value.
      WHEN '0017'.
        wa_output3-s4hana_changes = i_excel1-value.

      WHEN '0018'.
        wa_output3-s4hana_changes= i_excel1-value.
      WHEN '0019'.
        wa_output3-s4hana_changes = i_excel1-value.
      WHEN '0020'.
        wa_output3-s4hana_changes = i_excel1-value.
    ENDCASE.
    AT END OF row.
      APPEND wa_output3 TO it_output3.
      CLEAR : wa_output3.
    ENDAT.
  ENDLOOP.

  SORT it_output3 BY identifier.
  REFRESH: it_output3[].

  LOOP AT it_output3 INTO wa_output3.
    AT NEW identifier.
      flag = 'X'.
    ENDAT.
    IF flag = 'X'.
      CLEAR: wa_output3,flag.
    ENDIF.
  ENDLOOP.

ELSEIF.

  IF s_input2 IS NOT INITIAL.
    CALL FUNCTION 'ALSM_EXCEL_TO_INTERNAL_TABLE'
      EXPORTING
        filename    = s_input2
        i_begin_col = '1'
        i_begin_row = s_begrow2
        i_end_col   = '12'
        i_end_row   = s_endrow2
      TABLES
        intern      = i_excel2
 EXCEPTIONS
       INCONSISTENT_PARAMETERS       = 1
       UPLOAD_OLE  = 2
       OTHERS      = 3
      .
    IF sy-subrc <> 0.
* Implement suitable error handling here
      MESSAGE 'Problem uploading Excel sheet2' TYPE i.
      STOP.
    ENDIF.


    LOOP AT i_excel2.
      CASE i_excel2-col.
        WHEN '0001'.
          wa_output4-s4hana_changes = i_excel1-value.
        WHEN '0002'.
          wa_output4-s4hana_changes = i_excel1-value.
        WHEN '0003'.
          wa_output4-s4hana_changes = i_excel1-value.
        WHEN '0004'.
          wa_output4-s4hana_changes = i_excel1-value.
        WHEN '0005'.
          wa_output4-s4hana_changes= i_excel1-value.
        WHEN '0006'.
          wa_output4-s4hana_changes = i_excel1-value.
        WHEN '0007'.
          wa_output4-s4hana_changes = i_excel1-value.
        WHEN '0008'.
          wa_output4-s4hana_changes = i_excel1-value.
        WHEN '0009'.
          wa_output4-s4hana_changes = i_excel1-value.
        WHEN '0010'.
          wa_output4-s4hana_changes= i_excel1-value.
        WHEN '0011'.
          wa_output4-s4hana_changes = i_excel1-value.
        WHEN '0012'.
          wa_output4-s4hana_changes = i_excel1-value.
      ENDCASE.
      AT END OF row.
        APPEND wa_output4 TO it_output4.
        CLEAR : wa_output4.
      ENDAT.
    ENDLOOP.

    SORT it_output4 BY identifier.
    REFRESH: it_output4[].

    LOOP AT it_output4 INTO wa_output4.
      AT NEW identifier.
        flag = 'X'.
      ENDAT.
      IF flag = 'X'.
        CLEAR: wa_output4,flag.
      ENDIF.
    ENDLOOP.


*    ************

*    SORT it_f1 BY row col.
*
*    READ TABLE it_f1 INDEX 1.
*    gd_currentrow = it_f1-row.
*
*    LOOP AT it_f1.        "Reset value for next row"
*      IF it_f1-row NE gd_currentrow.
*        APPEND wa_f1 TO it_f3.
*        CLEAR wa_f1.
*        gd_currentrow = itab-row.
*      ENDIF.
*
*      CASE itab-col.
*
*        WHEN '0001"' "First name
*          wa_f1-  = it_f1-value.


** #########################ADD DATA TO S4HANA table
*
**Convert .XLSX to TXT.
*
*DATA: ZITAB TYPE TABLE OF ZSIMPLE1.
*DATA: WA_ZITAB TYPE ZSIMPLE1.
*PARAMETERS:P_FILE TYPE STRING DEFAULT '<Path to your actual text file>'OBLIGATORY. "File name
*CALL FUNCTION 'GUI_UPLOAD'
*  EXPORTING
*    filename                      =   P_FILE
**   FILETYPE                      = 'ASC'
*   HAS_FIELD_SEPARATOR           = '#'
**   HEADER_LENGTH                 = 0
**   READ_BY_LINE                  = 'X'
**   DAT_MODE                      = ' '
**   CODEPAGE                      = ' '
**   IGNORE_CERR                   = ABAP_TRUE
**   REPLACEMENT                   = '#'
**   CHECK_BOM                     = ' '
**   VIRUS_SCAN_PROFILE            =
**   NO_AUTH_CHECK                 = ' '
** IMPORTING
**   FILELENGTH                    =
**   HEADER                        =
*  tables
*    data_tab                      =   ZITAB.
** CHANGING
**   ISSCANPERFORMED               = ' '
** EXCEPTIONS
**   FILE_OPEN_ERROR               = 1
**   FILE_READ_ERROR               = 2
**   NO_BATCH                      = 3
**   GUI_REFUSE_FILETRANSFER       = 4
**   INVALID_TYPE                  = 5
**   NO_AUTHORITY                  = 6
**   UNKNOWN_ERROR                 = 7
**   BAD_DATA_FORMAT               = 8
**   HEADER_NOT_ALLOWED            = 9
**   SEPARATOR_NOT_ALLOWED         = 10
**   HEADER_TOO_LONG               = 11
**   UNKNOWN_DP_ERROR              = 12
**   ACCESS_DENIED                 = 13
**   DP_OUT_OF_MEMORY              = 14
**   DISK_FULL                     = 15
**   DP_TIMEOUT                    = 16
**   OTHERS                        = 17
*          .
*IF sy-subrc <> 0.
** Implement suitable error handling here
*  LOOP AT ZITAB INTO WA_ZITAB.
*    INSERT ZITAB FROM WA_ZITAB.
*ENDIF.
