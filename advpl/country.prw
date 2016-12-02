#INCLUDE "TOTVS.CH"
#INCLUDE "RESTFUL.CH"

WSRESTFUL country DESCRIPTION "Países" 

	WSDATA id AS INTEGER
	WSDATA start AS INTEGER
	WSDATA limit AS INTEGER

	WSMETHOD GET DESCRIPTION "get" PATH "{id}" PRODUCES APPLICATION_JSON

	WSMETHOD GET getEstado DESCRIPTION "get" PATH "{id}" PRODUCES APPLICATION_JSON 
	
	WSMETHOD GET getAll DESCRIPTION "get" PRODUCES APPLICATION_JSON 
	
	WSMETHOD POST DESCRIPTION "post" PRODUCES APPLICATION_JSON 

	WSMETHOD PUT DESCRIPTION "put" PATH "{id}" PRODUCES APPLICATION_JSON 

	WSMETHOD DELETE DESCRIPTION "delete" PATH "{id}" PRODUCES APPLICATION_JSON 

END WSRESTFUL

WSMETHOD GET PATHPARAM id WSREST country
Local cAlias := GetNextAlias()
Local cQuery
Local oResponse := JsonObject():New()
Local nLength := 0

cQuery := "SELECT X5_CHAVE,X5_DESCRI FROM " + RetSqlName('SX5') + ;
			" WHERE X5_FILIAL = '" + xFilial('SX5') + ;
			"' AND X5_TABELA = 'BH' AND X5_CHAVE = '" + StrZero(::id, 3) + "'" 

DbUseArea( .T., "TOPCONN", TCGenQry(,,cQuery), cAlias, .F., .F. )

oResponse['length'] := 0
oResponse['messages'] := {}
oResponse['data'] := JsonObject():New()
oResponse['data']['id'] := Val((cAlias)->X5_CHAVE)
oResponse['data']['name'] := AllTrim((cAlias)->X5_DESCRI)
oResponse['data']['acronym'] := Upper(Left((cAlias)->X5_DESCRI,2))

DbCloseArea()

::SetResponse(FWJsonSerialize(oResponse, .F., .F., .T.))
Return .T.

WSMETHOD GET getAll QUERYPARAM start, limit WSREST country
Local cAlias := GetNextAlias()
Local cQuery
Local cFromWhere := " FROM " + RetSqlName('SX5') + " WHERE X5_FILIAL = '" + xFilial('SX5') + "' AND X5_TABELA = 'BH'"
Local oResponse := JsonObject():New()
Local nLength := 0

cQuery := "SELECT COUNT(*) AS NCOUNT " + cFromWhere 
DbUseArea( .T., "TOPCONN", TCGenQry(,,cQuery), cAlias, .F., .F. )
oResponse['length'] := (cAlias)->NCOUNT
DbCloseArea()

DEFAULT ::start := 1, ::limit := oResponse['length']

cQuery := "SELECT X5_CHAVE,X5_DESCRI " + cFromWhere 
DbUseArea( .T., "TOPCONN", TCGenQry(,,cQuery), cAlias, .F., .F. )

oResponse['data'] := {}
oResponse['messages'] := {}

If ::start > 1
	DbSkip(::start)
EndIf

While !Eof() .and. ++nLength <= ::limit
	Aadd(oResponse['data'], JsonObject():New())
	oResponse['data'][nLength]['id'] := Val((cAlias)->X5_CHAVE)
	oResponse['data'][nLength]['name'] := AllTrim((cAlias)->X5_DESCRI)
	oResponse['data'][nLength]['acronym'] := Upper(Left((cAlias)->X5_DESCRI,2))
	oResponse['data'][nLength]['memo'] := 'linha 1 \n linha2'
	
	DbSkip()
End

DbCloseArea()

::SetResponse(FWJsonSerialize(oResponse, .F., .F., .T.))
Return .T.

WSMETHOD PUT PATHPARAM id WSREST country
Local oResponse := JsonObject():New()
Local oMessage := JsonObject():New()
Local oRequest := JsonObject():New()

If oRequest:fromJson(::GetContent())
	varinfo('getProperties', oRequest:getProperties())
	varinfo('hasProperty(name)', oRequest:hasProperty('name'))
EndIf

oResponse['length'] := 0
oResponse['data'] := NIL

oMessage['code'] := 'TESTE'
oMessage['type'] := 'error'
oMessage['detail'] := 'mensagem de erro'
oResponse['messages'] := {oMessage}

::SetResponse(FWJsonSerialize(oResponse, .F., .F., .T.))
Return .T.

WSMETHOD POST WSREST country
Local oResponse := JsonObject():New()
Local oMessage := JsonObject():New()
Local oRequest := JsonObject():New()

If oRequest:fromJson(::GetContent())
	varinfo('getProperties', oRequest:getProperties())
	varinfo('hasProperty', oRequest:hasProperty('name'))
EndIf

oResponse['length'] := 0
oResponse['data'] := NIL

oMessage['code'] := 'TESTE'
oMessage['type'] := 'error'
oMessage['detail'] := 'mensagem de erro'
oResponse['messages'] := {oMessage}

::SetResponse(FWJsonSerialize(oResponse, .F., .F., .T.))
Return .T.

WSMETHOD DELETE PATHPARAM id WSREST country
SetRestFault(400,"Operacao nao disponivel")
Return .F.

