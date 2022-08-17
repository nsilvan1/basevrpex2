local cfg = {}

cfg.groups = {
	["CEO"] = {
		_config = {
			title = "C.E.O",
			gtype = "jobdois",
		},
		"ceo.permissao",
		"admin.permissao",
		"suporte.permissao",
		"polpar.permissao",
		"rg2.permissao"
	},
	["CM"] = {
		_config = {
			title = "Community Manager",
			gtype = "jobdois",
		},
		"ceo.permissao",
		"admin.permissao",
		"suporte.permissao",
		"polpar.permissao"
	},
	["Admin"] = {
		_config = {
			title = "Admin",
			gtype = "jobdois",
		},
		"admin.permissao",
		"suporte.permissao",
		"polpar.permissao"
	},
	["Moderador"] = {
		_config = {
			title = "Moderador",
			gtype = "jobdois",
		},
		"mod.permissao",
		"suporte.permissao",
		"polpar.permissao"
	},
	["Suporte"] = {
		_config = {
			title = "Suporte",
			gtype = "jobdois",
		},
		"suporte.permissao",
		"imunidade.permissao"
	},
-----------------------------------------------------------------------------------------------------------------------------------------
-- SETS LIDER
-----------------------------------------------------------------------------------------------------------------------------------------
	["Chefepolicia"] = {
		_config = {
			title = "Chefe Policia",
			gtype = "job2"
		},
		"setpolicia.permissao",
		"player.blips"
	},

	["liderparamedico"] = {
		_config = {
			title = "Lider Paramedico",
			gtype = "job2"
		},
		"setparamedico.permissao",
		"player.blips"
	},
	["lidermecanico"] = {
		_config = {
			title = "Lider Mecanico",
			gtype = "job2"
		},
		"setmecanico.permissao",
		"player.blips"
	},
	["Concessionaria"] = {
		_config = {
			title = "Concessionaria",
			gtype = "job"
		},
		"conce.permissao",
		"sem.permissao"
	},
    ["WL"] = {
		_config = {
			title = "WL",
			gtype = "booster"
		},
		"wl.permissao"
	},
	["Booster"] = {
		_config = {
			title = "Booster",
			gtype = "booster"
		},
		"booster.permissao",
		"sem.permissao"
	},
-----------------------------------------------------------------------------------------------------------------------------------------
-- TAGS POLICIA
-----------------------------------------------------------------------------------------------------------------------------------------
	["PoliciaAcao"] = {
		_config = {
			title = "Policia em Ação",
			gtype = "job"
		},
		"policiaacao.permissao",
		"mochila.permissao",
		"avisos.permissao"
	},
	["Policia"] = {
		_config = {
			title = "Policia",
			gtype = "job"
		},
		"policia.permissao",
		"polpar.permissao",
		"portadp.permissao",
		"salario.permissao",
		"avisos.permissao",
		"sem.permissao"
	},	
	["PaisanaPolicia"] = {
		_config = {
			title = "PaisanaPolicia",
			gtype = "job"
		},
		"paisanapolicia.permissao",
		"sem.permissao"
	},
	["Paramedico"] = {
		_config = {
			title = "Hospital",
			gtype = "job"
		},
		"paramedico.permissao",
		"polpar.permissao",
		"sem.permissao"
	}, 	
	["PaisanaParamedico"] = {
		_config = {
			title = "PaisanaParamedico",
			gtype = "job"
		},
		"paisanaparamedico.permissao",
		"sem.permissao"
	},
	["Mecanico"] = {
		_config = {
			title = "Mecanico",
			gtype = "job"
		},
		"mecanico.permissao",
		"sem.permissao"
	},
	["PaisanaMecanico"] = {
		_config = {
			title = "PaisanaMecanico",
			gtype = "job"
		},
		"paisanamecanico.permissao"
	},
	["Taxista"] = {
		"taxista.permissao",
		"sem.permissao"
	},
	["PaisanaTaxista"] = {
		"paisanataxista.permissao",
		"sem.permissao"
	},
-----------------------------------------------------------------------------------------------------------------------------------------
-- VIPS
-----------------------------------------------------------------------------------------------------------------------------------------
	["Rental"] = {
		_config = {
			title = "Rental",
			gtype = "vip"
		},
		"rental.permissao",
		"mochila.permissao"
	},
	["Servidor"] = {
		_config = {
			title = "Vip Servidor",
			gtype = "vip"
		},
		"servidor.permissao",
		"mochila.permissao"
	},
	["Elite"] = {
		_config = {
			title = "Elite",
			gtype = "vip"
		},
		"elite.permissao",
		"mochila.permissao"
	},
	["Ultimate"] = {
		_config = {
			title = "Ultimate",
			gtype = "vip"
		},
		"ultimate.permissao",
		"mochila.permissao"
	},
	["Streamer"] = {
		_config = {
			title = "Streamer",
			gtype = "vip"
		},
		"streamer.permissao",
		"mochila.permissao"
	},
-----------------------------------------------------------------------------------------------------------------------------------------
-- GANGUES
-----------------------------------------------------------------------------------------------------------------------------------------
["Ballas"] = {
	_config = {
		title = "Ballas",
		gtype = "job"
	},
	"ballas.permissao",
	"trafico.permissao",
	"ilegal.permissao",
	"drogas.permissao"
},
["Vagos"] = {
	_config = {
		title = "Vagos",
		gtype = "job"
	},
	"vagos.permissao",
	"trafico.permissao",
	"ilegal.permissao",
	"drogas.permissao"
},
["Grove"] = {
	_config = {
		title = "Groove",
		gtype = "job"
	},
	"grove.permissao",
	"trafico.permissao",
	"ilegal.permissao",
	"drogas.permissao"
},	
["Crips"] = {
	_config = {
		title = "Crips",
		gtype = "job"
	},
	"crips.permissao",
	"trafico.permissao",
	"ilegal.permissao",
	"armas.permissao"
},
["Bloods"] = {
	_config = {
		title = "Bloods",
		gtype = "job"
	},
	"blood.permissao",
	"trafico.permissao",
	"ilegal.permissao",
	"armas.permissao"

},
["Native"] = {
	_config = {
		title = "Native",
		gtype = "job"
	},
	"native.permissao",
	"ilegal.permissao"
},
["Drift"] = {
	_config = {
		title = "DriftKing",
		gtype = "job"
	},
	"driftking.permissao",
	"ilegal.permissao"
},
["LifeInvader"] = {
	_config = {
		title = "LifeInvader",
		gtype = "job"
	},
	"lifeinvader.permissao",
	"ilegal.permissao",
	"lavagem.permissao"
},
["Bahamas"] = {
	_config = {
		title = "Bahamas",
		gtype = "job"
	},
	"bahamas.permissao",
	"ilegal.permissao",
	"lavagem.permissao"
},
["Siciliana"] = {
	_config = {
		title = "Siciliana",
		gtype = "job"
	},
	"siciliana.permissao",
	"ilegal.permissao",
	"municoes.permissao"
},
["Triade"] = {
	_config = {
		title = "Triade",
		gtype = "job"
	},
	"triade.permissao",
	"ilegal.permissao",
	"lavagem.permissao"
},		
}

cfg.users = {
	[0] = { "CEO" },
	[1] = { "CEO" },
	[2] = { "CEO" },
}

cfg.selectors = {}

return cfg