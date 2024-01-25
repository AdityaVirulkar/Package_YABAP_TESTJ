*&---------------------------------------------------------------------*
*& Report ZOCTEST
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZOCTEST.
*Select single PERNR into @DATA(ls_pernr) from pa0105
*  where USRID = @sy-uname and begda le @sy-datum and endda ge @sy-datum.
*  BREAK-POINT.
BREAK-POINT.

 Select PERNR into @DATA(ls_pernr) from pa0105
   where begda le @sy-datum and endda ge @sy-datum order by primary key.
   exit.
 endselect.

* Select * UP TO 1 ROWS FROM MARA INTO @DATA(LS_MARA) WHERE MTART = 'FERT'.
*   ENDSELECT.
