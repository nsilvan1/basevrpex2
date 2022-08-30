

config = {}

--[[ exports("license", function()
	return '8a619d04d9acc8b039710d46cbe4b56b4f9151ec00fe1aa9b24ae72eb6a96d1688192c289cf192f20b49a5d5f29fa3143484' 
end) ]]
-----------------------------------------------------------------------------------------------------------------------------------------
-- locais de  Saque
-----------------------------------------------------------------------------------------------------------------------------------------
config.LocaisSaldos = {
	{-144.25,-1613.81,36.05},  --DROGAS 1
	{131.84,-1938.87,20.62},  --DROGAS2
	{364.54,-2045.5,22.36}, --DROGAS3
	{-1075.2,-1678.75,4.58}, --BLOODS
	{1272.34,-1714.73,54.78}, -- CRIPS
	{-1497.3,845.62,181.6},--TRIADE
	{1076.19,-2002.2,31.02},--RUSSKAYA
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- VALOR DA DROGA
-----------------------------------------------------------------------------------------------------------------------------------------
config.PrecoDaDroga = 1500 --- valor de cada unidade das drogas
-----------------------------------------------------------------------------------------------------------------------------------------
-- VALORES ARMAS
-----------------------------------------------------------------------------------------------------------------------------------------
config.valorAK = 500000

config.valorG3 = 900000

config.valorMP5 = 150000

config.valorTEC9 = 135000

config.valorFIVE = 200000

config.valorDOZE = 225000


-----------------------------------------------------------------------------------------------------------------------------------------
-- valores munição  (VALOR POR UNIDADADE OU SEJA A CADA 1 MUNIÇÃO)
-----------------------------------------------------------------------------------------------------------------------------------------

config.ValorMUNIAK = 1500

config.valorMUNIG3 = 1500

config.valorMUNIMP5 = 1000

config.valorMUNITEC9 = 350

config.valorMUNIFIVE = 360

config.valorMUNIDOZE = 250

-----------------------------------------------------------------------------------------------------------------------------------------
-- nomes dos baus das facções(favor deixar igual os nomes que estão no vrp_chest)
-----------------------------------------------------------------------------------------------------------------------------------------

config.bauMAFIADEMUNI1 = 'yardie'

config.bauMAFIADEMUNI2 = 'russkaya'

config.bauMAFIADEARMAS1 = 'Bloods'

config.bauMAFIADEARMAS2 = 'Crips'

config.bauDROGAS1 = 'Grove'

config.bauDROGAS2 = 'Ballas'

config.bauDROGAS3 = 'Vagos'
-----------------------------------------------------------------------------------------------------------------------------------------
-- LOG DAS COMPRAS DOS ITENS
-----------------------------------------------------------------------------------------------------------------------------------------
config.WebhookArmas1 = ''
config.WebhookArmas2 = ''
config.WebhookMuni1 = ''
config.WebhookMuni2 = ''
config.WebhookDrogas1 = ''
config.WebhookDrogas2 = ''
config.WebhookDrogas3 = ''
-----------------------------------------------------------------------------------------------------------------------------------------
-- PERMISSÃO PARA RETIRAR O DINHEIRO DAS VENDAS
-----------------------------------------------------------------------------------------------------------------------------------------
config.IDParaSacarSaldoDrogas1 = 2112    --- GROOVE
config.IDParaSacarSaldoDrogas2 = 1223  --- BALLAS
config.IDParaSacarSaldoDrogas3 = 694  --- VAGOS
config.IDParaSacarSaldoArmas1 = 106 --- BLOODS
config.IDParaSacarSaldoArmas2 = 377 --- CRIPS
config.IDParaSacarSaldoMuni1 = 102    ---TRIADE
config.IDParaSacarSaldoMuni2 = 274 ---RUSSKAYA




