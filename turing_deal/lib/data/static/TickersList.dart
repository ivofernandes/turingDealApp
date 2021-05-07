import 'package:turing_deal/data/model/ticker.dart';

/// Kind of stable static tickers list
class TickersList{

  static Map<String, String> main = {
  '^GSPC': 'SP500',
  '^NDX': 'Nasdaq 100',
  'IWM': 'Russell 2000',
  'IWB': 'Russell 1000'
  };

  static Map<String, String> bonds = {
  '^IRX': 'USA 13 Week Bond yield',
  '^TNX': '10 Years Bond yield',
  'ZB=F': 'Treasury Bond Futures'
  };

  static Map<String, String>  sectors = {
  'XLE': 'Energy',
  'XLF': 'Financials',
  'XLU': 'Utilities',
  'XLI': 'Industrial',
  'XLV': 'Healthcare',
  'XLY': 'Cons Discretionary',
  'XLP': 'Consumer Staples',
  'XLB': 'Materials',
  'REET': 'Real Estate',
  'XLC': 'Communication Services',
  'FCOM': 'Content'
  };

  static Map<String, String> countries = {

  'EWI': 'Italia',
  'RSX': 'Russia',
  'EWL': 'Switzerland',
  'EWU': 'UK',
  'EWI': 'Italy',
  'EWP': 'Spain',
  'EWA': 'Australia',
  'AFK': 'Whole Africa',
  'EGPT': 'Egypt',
  'EWA': 'South Africa',

  'MCHI': 'China',
  'FXI': 'China Large Cap',
  'CQQQ': 'China Tech',
  'THD': 'Thailand',
  'EWY': 'South Korea',
  'EWM': 'Malaysia',
  'EWS': 'Singapore',
  'DAX': 'Germany',

  'EWC':'Canada',
  'EWZ':'Brazil',
  'EWW':'Mexico',
  'ARGT':'Argentina',
  'EPU':'Peru',
  'INDA':'India',
  'INDY':'India 50',
  'EIDO': 'Indonesia',
  'JPXN': 'Japan, Nikkei 400',
  };

  static Map<String, String> commodities = {
  'GC=F': 'Gold',
  'SI=F': 'Silver',
  'CL=F': 'Oil',
  'HG=F': 'Copper',
  'NG=F': 'Natural Gas',
  'ZC=F': 'Corn',
  'ZS=F': 'Soybean',
  'CC=F': 'Cocoa',
  'KC=F': 'Coffee',
  'SB=F': 'Sugar'
  };

  static Map<String, String>  sizes = {
  'VBR':'Value small',
  'VOE':'Value mid',
  'VTV':'Value large',

  'VB':'Core small',
  'VO':'Core mid',
  'VV':'Core large',

  'VBK':'Growth small',
  'VOT':'Growth mid',
  'VUG':'Growth large'
  };

  static Map<String, String> cryptoCurrencies = {
    'BTC-USD': 'Bitcoin',
    'ETH-USD': 'Ethereum',
    'XRP-USD': 'XRP',
    'DOGE-USD': 'Dogecoin'
  };

  static Map<String, String> companies = {
  'FTCH': 'Farfetch',
  'PYPL': 'Paypal',
  'DIS': 'Disney',
  'KO': 'Coke',
  'NFLX': 'Netflix',
  'CRWD': 'Crowdstrike',
  'ETSY': 'Etsy',
  'FVRR': 'Fiverr',
  'ZM': 'Zoom',
  'HPQ': 'HP',
  'GE': 'General Eletric',
  'JPM': 'JP Morgan',
  'CHL': 'China Mobile',
  'TWTR': 'Twitter',
  'ACN': 'Accenture',
  'GS': 'Goldman sachs',
  'AMD': 'Advanced Micro Devices',

  'SHOP': 'Shopify',
  'BRK': 'Berkshire',
  'TSLA': 'Tesla',
  'TSM': 'Taiwan Semiconductors',

  'UNH': 'United Health',
  'FB': 'Facebook',
  'AAPL': 'Apple',

  'XOM': 'Exxon',
  'BAC': 'Bank of America',
  'HSBC': ' HSBC',
  'AMZN': 'Amazon',
  'GOOG': 'Google',
  'MSFT': 'Microsoft',
  'BIDU': 'Baidu',
  'BABA': 'Alibaba',
  'WMT': 'Walmart',
  'JNJ': 'Johnson',
  'PG': 'Procter & gamble',
  'V': 'Visa',
  'NVDA': 'Nvidia',
  'INTC': 'Intel',
  };

}