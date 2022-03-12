<# 
.SYNOPSIS
	Obtener el precio de las criptomonedas segun la fuente de cryptocompare.com
#>

# Función para obtener de la API de cryptocompare las criptomonedas pasadas por parametros en EUR y USD 
function ListCryptoRate { param([string]$Symbol, [string]$Name)
	$Rates = (invoke-webRequest -uri "https://min-api.cryptocompare.com/data/price?fsym=$Symbol&tsyms=USD,EUR,RUB,CNY" -userAgent "curl" -useBasicParsing).Content | ConvertFrom-Json
	new-object PSObject -property @{ 'Criptomonedas' = "1 $Name ($Symbol) ="; 'USD' = "$($Rates.USD)"; 'EUR' = "$($Rates.EUR)" }
}

# Función para mandar a la función anterior las criptomonedas que deseamos obtener
function ListCryptoRates { 
	ListCryptoRate BTC "Bitcoin"
	ListCryptoRate ETH "Ethereum"
	ListCryptoRate ADA "Cardano"
	ListCryptoRate BNB "Binance Coin"
	ListCryptoRate USDT "Tether"
	ListCryptoRate XRP "XRP"
	ListCryptoRate DOGE "Dogecoin"
	ListCryptoRate DOT "Polkadot"
	ListCryptoRate SOL "Solana"
	ListCryptoRate LTC "Litecoin"
	ListCryptoRate LUNA "Terra"
	ListCryptoRate MATIC "Polygon"
}

try {
	""
	"Valor Criptomonedas Exchange (fuente: cryptocompare.com)"
	"============================="

	# Funcion para formar una tabla con los datos obtenidos
	ListCryptoRates | format-table -property @{e='Criptomonedas';width=28},USD,EUR
	exit 0
} catch {
	"⚠️ Error: $($Error[0]) ($($MyInvocation.MyCommand.Name):$($_.InvocationInfo.ScriptLineNumber))"
	exit 1
}