interface ZIF_BAPI_FLIGHT_GETLIST2
  public .


  types:
    S_CARR_ID type C length 000003 .
  types:
    S_CONN_ID type N length 000004 .
  types:
    begin of BAPISFLKEY,
      AIRLINEID type S_CARR_ID,
      CONNECTID type S_CONN_ID,
      FLIGHTDATE type DATS,
    end of BAPISFLKEY .
  types:
    S_AIRPORT type C length 000003 .
  types:
    S_CITY type C length 000020 .
  types:
    S_COUNTR type C length 000003 .
  types:
    S_COUN_ISO type C length 000002 .
  types:
    begin of BAPISFLDST,
      AIRPORTID type S_AIRPORT,
      CITY type S_CITY,
      COUNTR type S_COUNTR,
      COUNTR_ISO type S_COUN_ISO,
    end of BAPISFLDST .
  types:
    TESTRUN type C length 000001 .
  types:
    S_FBOSTAT3 type C length 000001 .
  types:
    begin of BAPISFLAUX,
      BAPIMAXROW type INT4,
      TESTRUN type TESTRUN,
      FBOSTATUS type S_FBOSTAT3,
    end of BAPISFLAUX .
  types:
    BAPISIGN type C length 000001 .
  types:
    BAPIOPTION type C length 000002 .
  types:
    begin of BAPISFLDRA,
      SIGN type BAPISIGN,
      OPTION type BAPIOPTION,
      LOW type DATS,
      HIGH type DATS,
    end of BAPISFLDRA .
  types:
    __BAPISFLDRA                   type standard table of BAPISFLDRA                     with non-unique default key .
  types:
    TE_STRUC type C length 000030 .
  types:
    VALUEPART type C length 000240 .
  types:
    begin of BAPIPAREX,
      STRUCTURE type TE_STRUC,
      VALUEPART1 type VALUEPART,
      VALUEPART2 type VALUEPART,
      VALUEPART3 type VALUEPART,
      VALUEPART4 type VALUEPART,
    end of BAPIPAREX .
  types:
    __BAPIPAREX                    type standard table of BAPIPAREX                      with non-unique default key .
  types:
    S_CARRNAME type C length 000020 .
  types:
    S_FROMAIRP type C length 000003 .
  types:
    S_FROM_CIT type C length 000020 .
  types:
    S_TOAIRP type C length 000003 .
  types:
    S_TO_CITY type C length 000020 .
  types S_DEP_TIME type T .
  types S_ARR_TIME type T .
  types:
    S_PRICE_2 type P length 12  decimals 000004 .
  types:
    S_CURRCODE type C length 000005 .
  types:
    S_CURR_ISO type C length 000003 .
  types:
    begin of BAPISFLDAT,
      AIRLINEID type S_CARR_ID,
      AIRLINE type S_CARRNAME,
      CONNECTID type S_CONN_ID,
      FLIGHTDATE type DATS,
      AIRPORTFR type S_FROMAIRP,
      CITYFROM type S_FROM_CIT,
      AIRPORTTO type S_TOAIRP,
      CITYTO type S_TO_CITY,
      DEPTIME type S_DEP_TIME,
      ARRTIME type S_ARR_TIME,
      ARRDATE type DATS,
      PRICE type S_PRICE_2,
      CURR type S_CURRCODE,
      CURR_ISO type S_CURR_ISO,
    end of BAPISFLDAT .
  types:
    __BAPISFLDAT                   type standard table of BAPISFLDAT                     with non-unique default key .
  types:
    BAPI_MTYPE type C length 000001 .
  types:
    SYMSGID type C length 000020 .
  types:
    SYMSGNO type N length 000003 .
  types:
    BAPI_MSG type C length 000220 .
  types:
    BALOGNR type C length 000020 .
  types:
    BALMNR type N length 000006 .
  types:
    SYMSGV type C length 000050 .
  types:
    BAPI_PARAM type C length 000032 .
  types:
    BAPI_FLD type C length 000030 .
  types:
    BAPILOGSYS type C length 000010 .
  types:
    begin of BAPIRET2,
      TYPE type BAPI_MTYPE,
      ID type SYMSGID,
      NUMBER type SYMSGNO,
      MESSAGE type BAPI_MSG,
      LOG_NO type BALOGNR,
      LOG_MSG_NO type BALMNR,
      MESSAGE_V1 type SYMSGV,
      MESSAGE_V2 type SYMSGV,
      MESSAGE_V3 type SYMSGV,
      MESSAGE_V4 type SYMSGV,
      PARAMETER type BAPI_PARAM,
      ROW type INT4,
      FIELD type BAPI_FLD,
      SYSTEM type BAPILOGSYS,
    end of BAPIRET2 .
  types:
    __BAPIRET2                     type standard table of BAPIRET2                       with non-unique default key .
endinterface.
