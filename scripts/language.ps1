# Set WinUserLanguageList as a variable
$lang = Get-WinUserLanguageList 
# Clear the WinUserLanguageList
$lang.Clear()
# Add language to the language list
$lang.add("es-ES")
# Remove whatever input method is present
$lang[0].InputMethodTips.Clear()
# Add this keyboard as keyboard language
$lang[0].InputMethodTips.Add('0C0A:0000040A')
# Set this language list as default
Set-WinUserLanguageList $lang -Force
# Make region settings independent of OS language
Set-WinCultureFromLanguageListOptOut -OptOut $True
# Set region to this Country
Set-Culture es-ES
# Set the location to this location
Set-WinHomeLocation -GeoId 0xd9
# Set non-unicode legacy software to use this language as default
Set-WinSystemLocale -SystemLocale es-ES

# Forzamos a que use la region de espana ( moneda, formato tiempo, etc...)
Set-Culture -CultureInfo es-ES
