#INCLUDE "TOTVS.CH"
#INCLUDE "RESTFUL.CH"

user function _rafaelrest()
	Local cAlias := ""
	Local cFromWhere := ""
	//Data inicial e final do mes corrente
	Local cDataIni := cValToChar(Year(Date())) + /*cValToChar(Month(Date()))*/ "01" + "01"
	Local cDataFim := cValToChar(Year(Date())) + /*cValToChar(Month(Date()))*/ "12" + "31"
	
	Local oResponse := JsonObject():New()
	
	Local nLength := 0
	
	cFromWhere := " FROM SPED050 WHERE MODELO = '55' AND STATUS = 6 AND DATE_NFE >= '"+ cDataIni + "' AND DATE_NFE <= '" + cDataFim + "' ORDER BY ID_ENT,DATE_NFE"
	
	InitSped()
	
	//FAZ A QUERY
	graphquery(cFromWhere, @cAlias)
	//MONTA RESPOSTA JSON
	graphJson(1,cAlias,@oResponse)	
	
return

WSRESTFUL tssgraph DESCRIPTION "TSS Graficos"

	WSDATA id AS  INTEGER //id - codigo do gráfico desejado
	WSDATA id_ent AS INTEGER //id_ent - entidade desejada
	WSDATA moths  AS INTEGER //qtd de meses para buscar dados MAXIMO 3 MESES		
	
	WSMETHOD GET DESCRIPTION "get" PATH "{id}" PRODUCES APPLICATION_JSON //METODO RETORNA POR TIPO DE GRAFICO

	//WSMETHOD GET entidade DESCRIPTION "get" PATH "{id}/{ident}" PRODUCES APPLICATION_JSON //METODO RETORNA POR TIPO DE GRAFICO E ENTIDADE
	
	//WSMETHOD GET mes DESCRIPTION "get" PATH "{id}/{moths}" PRODUCES APPLICATION_JSON //METODO RETORNA POR TIPO DE GRAFICO ENTIDADE E MESES
	
	//WSMETHOD GET entidademes DESCRIPTION "get" PATH "{id}/{ident}/{moths}" PRODUCES APPLICATION_JSON //METODO RETORNA POR TIPO DE GRAFICO ENTIDADE E MESES
	
	//WSMETHOD GET getall DESCRIPTION "get" PRODUCES APPLICATION_JSON //METODO RETORNA TODAS AS CONSULTAS
	

END WSRESTFUL

//id possiveis
//id = 1 - Produtos mais vendidos
//id = 2 - Regiões mais vendidas
//id = 3 - Clientes mais vendidos

WSMETHOD GET PATHPARAM id WSREST tssgraph
Local cAlias := ""
Local cFromWhere := ""
//Data inicial e final do mes corrente
Local cDataIni := cValToChar(Year(Date())) + /*cValToChar(Month(Date()))*/ "10" + "01"
Local cDataFim := cValToChar(Year(Date())) + /*cValToChar(Month(Date()))*/ "12" + "31"

Local oResponse := JsonObject():New()

Local nLength := 0

cFromWhere := " FROM SPED050 WHERE MODELO = '55' AND STATUS = 6 AND DATE_NFE >= '"+ cDataIni + "' AND DATE_NFE <= '" + cDataFim + "' ORDER BY ID_ENT,DATE_NFE"

InitSped()

//FAZ A QUERY
graphquery(cFromWhere, @cAlias)
//MONTA RESPOSTA JSON
graphJson(::id,cAlias,@oResponse)

::SetResponse(FWJsonSerialize(oResponse, .F., .F., .T.))
	
fwfreeobj(oResponse)

Return .T.


/*
WSMETHOD GET PATHPARAM id,ident WSREST tssgraph
Local cAlias := ""
Local oResponse := JsonObject():New()
Local cFromWhere := " FROM SPED050 WHERE ID_ENT = '"+strzero(::ident,6)+"' AND STATUS = 6 ORDRER BY ID_ENT,DATE_NFE"
Local nLength := 0

//FAZ A QUERY
graphquery(cFromWhere, @cAlias)
//MONTA RESPOSTA JSON
graphJson(::id,cAlias,@oResponse)

::SetResponse(FWJsonSerialize(oResponse, .F., .F., .T.))

Return .T.

WSMETHOD GET PATHPARAM id,ident, WSREST tssgraph
Local cAlias := ""
Local oResponse := JsonObject():New()
Local cFromWhere := " FROM SPED050 WHERE ID_ENT = '"+strzero(::ident,6)+"' AND STATUS = 6 ORDRER BY ID_ENT,DATE_NFE"
Local nLength := 0

//FAZ A QUERY
graphquery(cFromWhere, @cAlias)
//MONTA RESPOSTA JSON
graphJson(::id,cAlias,@oResponse)

::SetResponse(FWJsonSerialize(oResponse, .F., .F., .T.))

DbCloseArea()
FwFreeObj()

Return .T.

WSMETHOD GET PATHPARAM id WSREST tssgraph
Local cAlias := ""
Local oResponse := JsonObject():New()
Local cFromWhere := " FROM SPED050 WHERE MODELO = 55 STATUS = 6 ORDRER BY ID_ENT,DATE_NFE"
Local nLength := 0

//FAZ A QUERY
graphquery(cFromWhere, @cAlias)
//MONTA RESPOSTA JSON
graphJson(::id,cAlias,@oResponse)

::SetResponse(FWJsonSerialize(oResponse, .F., .F., .T.))

Return .T.

WSMETHOD GET getAll QUERYPARAM id,  WSREST tssgraph
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

*/
static function graphquery(cFromWhere, cAlias) 

local cAlias := GetNextAlias()
local cQuery := "SELECT R_E_C_N_O_" + cFromWhere

conout(cQuery)

DbUseArea( .T., "TOPCONN", TCGenQry(,,cQuery), cAlias, .F., .F. )

return 

static function graphJson(nid,cAlias,oResponse)

local nx 		:= 1
local nLength	:= 1
local nFind		:= 0
local aDados	:= {}
local aInf		:= {}
local cErro		:= ""
local cAviso	:= ""

local oJsonIDE	:= Nil
local oJsonEmit	:= Nil
local oJsonDest	:= Nil
local oJsonItem	:= Nil

private aItem		:= Nil
private oXml		:= Nil

oResponse['result'] := {}

do case
	case nId == 1 //retorna todos os filtros possíveis
		
		while !EOF() 
						
			sped050->(dbgoto((cAlias)->R_E_C_N_O_))
			
			oxml := xmlparser(sped050->xml_erp,"_",@cErro,@cAviso)
			if Type("oxml:_NFe:_infNFe:_det") <> "A"			
				aItem := {oxml:_NFe:_infNFe:_det}
			else
				aItem := oxml:_NFe:_infNFe:_det
			endif
			
			for nx := 1 to len(aitem)
				nFind := aScan(aDados,{|x| AllTrim(x[1])== alltrim(aitem[nx]:_prod:_ncm:text)}) //ascan(aDados[1],alltrim(aitem[nx]:_prod:_ncm:text))
				
				if nFind > 0
					aDados[nFind][3] += Val(aitem[nx]:_prod:_qCom:text)
				else
					aadd(aDados,{alltrim(aitem[nx]:_prod:_ncm:text),alltrim(aitem[nx]:_prod:_xprod:text),Val(aitem[nx]:_prod:_qCom:text)})
				endif
				
			next nx
				
			DbSkip()
			
		end
		oResponse['filtro'] := 1
				
		Aadd(oResponse['result'], JsonObject():New())
		oResponse['result'] := aDados
		
	case nId == 1
	
	case nId == 2
	
	case nId == 3
		

end

fwfreeobj(oxml)
delclassintf()
//fwfreeobj(aItem)
//fwfreeobj(aDados)

return


static function GetDadosXMl(cXml, aDados, cErro, cAviso)
local aRetorno := {}
local cPosXMl	 := ""

local nX	:= 0

private oXMl := Nil
	
if len( aDados ) > 0 
	cXml := XmlClean(cXml)
	
	oXml := XmlParser(encodeUTF8(cXml),"_",@cAviso,@cErro)
	
	if oXml == nil
		oXml := XmlParser(cXml,"_",@cAviso,@cErro) 
	endif
	
	if Empty(cAviso + cErro )
		
		for nX := 1 to Len(aDados)
			cPosXMl := ""
			cPosXMl := StrTran( aDados[nX] , "|" , ":_")
			
			if SubStr(cPosXml,len(cPosXml)-1,2) == ":_"
				cPosXml := SubStr(cPosXml,1,len(cPosXml)-2) 
			endif
			
			cPosXMl := "oXml:_"+cPosXml+":TEXT"
			
			if Type(cPosXMl) <> "U"
				aadd(aRetorno, &(cPosXMl))
			else
				aadd(aRetorno,"")
			endif	

		Next
		
	endif
	
else
	cErro := "Deve ser passado pelo menos uma posição nos dados"
endif

oXml	:= Nil
DelClassIntF()

return aRetorno