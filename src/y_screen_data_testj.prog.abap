*&---------------------------------------------------------------------*
*& Report  ZMSS_TEST_YSCR_01
*&
*&---------------------------------------------------------------------*
*& Change Log
*& Name : TESTJ
*& Date : 09 Aug 2021
*& Description :
*&
*&---------------------------------------------------------------------*
report  zmss_test_yscr_01
        line-size 132
        message-id su.

tables : tstc,
         d020t.
* transaction codes
data : begin of i_tcodes occurs 0,
         tcode(20) type c,
         pgmna(40) type c,
       end of i_tcodes.

* TSTC - with Program names
data : begin of i_tstc1 occurs 0,
        tcode like tstc-tcode,
        pgmna like tstc-pgmna,
        dypno like tstc-dypno,
       end   of i_tstc1.
* screen descriptions
data : begin of i_d020t occurs 0,
         prog like d020t-prog,
         dynr like d020t-dynr,
         lang like d020t-lang,
         dtxt like d020t-dtxt,
       end of i_d020t.
* transaction tree
data : begin of i_screens occurs 0,
         tcode like tstc-tcode,
         programnm(40) type c,
         screen like tstc-dypno,
         fieldnm(132) type c,
         desc type char255,
         mandatory type flag,
        end of i_screens.
* screen fields
data  begin of i_dynp_fields occurs 20.
        include structure rsdcf.
data  end of i_dynp_fields.
* screen lines
data  begin of i_lines occurs 20.
        include structure tline.
data  end of i_lines.


* selection screen block containing file to be uploaded
selection-screen begin of block b1 with frame title text-t01.
select-options : r_tcode for tstc-tcode.
selection-screen end of block b1.

* Text file containing transaction list to be dowmloaded
selection-screen begin of block b2 with frame title text-t02.
parameters: p_fpath2 like  rlgrap-filename  default text-d02.
selection-screen end of block b2.


at selection-screen on value-request for p_fpath2.
  perform f_get_filename.

start-of-selection.

* validate all the transaction codes
  perform f_validate_tcodes.
* get the screen fields info
  perform f_get_screen_definitions.
* download the results to file
  perform f_download_results using p_fpath2.
* display the report
  perform f_display_report.

end-of-selection.

*&---------------------------------------------------------------------*
*&      Form  f_validate_tcodes
*&---------------------------------------------------------------------*
*       validate the tcodes
*----------------------------------------------------------------------*
form f_validate_tcodes .
* get the prognames & tcodes & screen number
* determine if the tcodes has associcated programs
  if not r_tcode[] is initial.
    select tcode
           pgmna
           dypno
           from tstc
           into table i_tstc1
           where tcode in r_tcode.
  endif.

* validate the screen number with table d020t
* this is to confirm whether the screen number is present or not as SAP
* can remove screens
  sort i_tstc1 by tcode.
  if not i_tstc1[] is initial.
    select prog
           dynr
           lang
           dtxt
           from d020t
           into table i_d020t
           for all entries in i_tstc1
           where prog eq i_tstc1-pgmna
             and lang = 'EN'.
  endif.

endform.                    " f_validate_tcodes
*&---------------------------------------------------------------------*
*&      Form  f_get_screen_definitions
*&---------------------------------------------------------------------*
*       get the screen definitions
*----------------------------------------------------------------------*
form f_get_screen_definitions .

  data : cnt_tcode type i,
         l_text(70),
         l_tabix(6) type c,
         l_string1(60).

  loop at i_tstc1.
*   process for all programs
    loop at i_d020t where prog = i_tstc1-pgmna
                      and lang = 'E'.
      refresh i_dynp_fields.
*     show the gui status bar to avoid short dumps
      add 1 to cnt_tcode.
      if cnt_tcode gt 100.
        clear : cnt_tcode.
        move sy-tabix to l_tabix.
        concatenate 'Processing done for'
                      l_tabix
                      'Objects'
                      into l_text
                      separated by space.
        call function 'SAPGUI_PROGRESS_INDICATOR'
          exporting
            text   = l_text
          exceptions
            others = 1.
        if sy-batch = 'X'.
          message i000 with l_text.
        endif.
      endif.
      clear i_screens.
*     tcode
      i_screens-tcode = i_tstc1-tcode.
*     program name
      i_screens-programnm = i_d020t-prog.
      append i_screens.
*     screen number
      i_screens-screen = i_d020t-dynr.
      append i_screens.
*     pass the program name and screen number
      call function 'DYNPRO_FIELD_GET'
        exporting
          dynpro           = i_d020t-dynr
          program          = i_d020t-prog
        tables
          dynp_fields      = i_dynp_fields
          lines            = i_lines
        exceptions
          dynpro_not_found = 1
          others           = 2.
      if sy-subrc eq 0.
    " additional check to find out mandatory screen elements by ashish :
*START
        data: i_d021s type standard table of d021s.
        data: i_tab type standard table of d021s.
        refresh: i_d021s[].
        tables: d021s.
        data: dylang  like  d020s-spra,
              dyname  like  d020s-prog,
              dynumb  like  d020s-dnum.
        dylang = 'EN'.
        dyname = i_d020t-prog.
        dynumb = i_d020t-dynr.
        call function 'IMPORT_DYNPRO'
            exporting
                 dylang               =  dylang
                 dyname               = dyname
                 dynumb               = dynumb
*           REQUEST              = 'F'
*       IMPORTING
*            HEADER               = HEADER
            tables
                 ftab                 = i_d021s
            exceptions
                 dylanguage_invalid   = 1
                 dylanguage_not_inst  = 2
                 dyname_invalid       = 3
                 dynproload_not_found = 4
                 dynumb_invalid       = 5
                 ftab_invalid         = 6
                 header_invalid       = 7
                 internal_error       = 8
                 no_dynpro            = 9
                 no_ftab_row          = 10
                 no_memory            = 11
                 request_invalid      = 12
                 others               = 13.
" additional check to find out mandatory screen elements by ashish : END
        loop at i_dynp_fields.
          i_tab[] = i_d021s[].
          if i_dynp_fields-tabname <> ''.
*           create field records in the fields table
            clear i_screens.
*           field name
            i_screens-tcode = i_tstc1-tcode.
            i_screens-screen = i_d020t-dynr.
            i_screens-programnm = i_d020t-prog.
            i_screens-fieldnm = i_dynp_fields-dynpro_fld.
            data: l_str1 type char30,
                  l_str2 type char30,
                  l_ddtext type dd03m-ddtext.
            clear: l_str1, l_str2, l_ddtext.
            l_str1 = i_dynp_fields-dynpro_fld.
            if l_str1+0(1) = '*'.
              replace first occurrence of '*' in  l_str1 with ''.
              condense l_str1.
            else.
              condense l_str1.
            endif.
            split l_str1 at '-' into l_str1 l_str2.
            select single ddtext from dd03m into l_ddtext
                   where tabname =  l_str1 and
                         fieldname = l_str2 and
                         ddlanguage = 'EN'.
            delete i_tab[] where  fnam ne i_dynp_fields-dynpro_fld.
            delete i_tab[] where stxt ns '_'.
*            IF sy-subrc = 0 .
            read table i_tab into d021s index 1.
            data: flg3 type char10.
            flg3 = d021s-flg3.
            condense flg3.
            if flg3+0(1) = 'A'.
              i_screens-mandatory = 'X'.
            else.
              i_screens-mandatory = ''.
            endif.
*            ENDIF.
            i_screens-desc = l_ddtext.
            append i_screens to i_screens.
          endif.
        endloop.
*       get the bdc_okcode
*        CLEAR i_screens. " commented by ashish
*        i_screens-tcode = i_tstc1-tcode.
*        i_screens-screen = i_d020t-dynr.
*        i_screens-programnm = i_d020t-prog.
*        i_screens-fieldnm = 'BDC_OKCODE'.
*        APPEND i_screens.
      endif.
    endloop.
  endloop.
endform.                    " f_get_screen_definitions
*&---------------------------------------------------------------------*
*&      Form  f_download_results
*&---------------------------------------------------------------------*
*       download the results to flat file
*----------------------------------------------------------------------*
*      -->P_P_FPATH2   fiepath containing the screen definitions
*----------------------------------------------------------------------*

form f_download_results using p_p_fpath2.

  data: file type string.
  file = p_p_fpath2.

  call function 'GUI_DOWNLOAD'
    exporting
*   BIN_FILESIZE                    =
      filename                        = file
*   FILETYPE                        = 'ASC'
*   APPEND                          = ' '
     write_field_separator           = '|'
    tables
      data_tab                        = i_screens
 exceptions
   others                          = 01
            .
  if sy-subrc <> 0.
  endif.
endform.                    " f_download_results

form f_display_report .
  skip.
  write :/03 'File downloaded to path:',
          30 p_fpath2.
endform.                    " f_display_report
form f_get_filename .
  call function 'F4_FILENAME'
** EXPORTING
**   PROGRAM_NAME        = sy-repid
**   DYNPRO_NUMBER       = SYST-DYNNR
**   FIELD_NAME          = ' '
   importing
     file_name           = p_fpath2
            .
endform.                    " f_get_filename
