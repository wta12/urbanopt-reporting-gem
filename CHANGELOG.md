# URBANopt Reporting Gem

## Version 0.3.3

Date Range: 12/09/20 - 01/13/21

- Fixed [#36]( https://github.com/urbanopt/urbanopt-reporting-gem/issues/36 ), Add reporting measure for district heating/cooling system mass flow rates
- Fixed [#37]( https://github.com/urbanopt/urbanopt-reporting-gem/issues/37 ), Add EUI to default report
- Fixed [#38]( https://github.com/urbanopt/urbanopt-reporting-gem/issues/38 ), Add better error handling around convert_units
- Fixed [#43]( https://github.com/urbanopt/urbanopt-reporting-gem/issues/43 ), Add available_roof_area calculation
- Fixed [#44]( https://github.com/urbanopt/urbanopt-reporting-gem/issues/44 ), Fix coordinates order

## Version 0.3.2

Date Range: 12/07/20 - 12/08/20

- Fixed [#27]( https://github.com/urbanopt/urbanopt-reporting-gem/issues/27 ), reporting measure fails when there are no additional fuels in the model
- Fixed [#29]( https://github.com/urbanopt/urbanopt-reporting-gem/issues/29 ), restore save_feature_report function for backward compatibility
- Fixed [#32]( https://github.com/urbanopt/urbanopt-reporting-gem/issues/32 ), bump extension-gem dependency

## Version 0.3.1

Date Range: 11/26/2020 - 12/07/2020

- Fixed [#19]( https://github.com/urbanopt/urbanopt-reporting-gem/pull/19 ), check for nil values to avoid crashing unit conversion
- Fixed [#24]( https://github.com/urbanopt/urbanopt-reporting-gem/pull/24 ), Support reporting of other fuels
- Fixed [#28]( https://github.com/urbanopt/urbanopt-reporting-gem/pull/28 ), fix for other_fuels being nil and restore save_feature_report function

## Version 0.3.0

Date Range: 11/12/2020 - 11/25/2020

- Updating dependencies to support OpenStudio 3.1.0

## Version 0.2.1

Date Range: 09/22/2020 - 11/12/2020

- Fixed [#12]( https://github.com/urbanopt/urbanopt-reporting-gem/pull/12 ), add units to the json report attributes
- Fixed [#14]( https://github.com/urbanopt/urbanopt-reporting-gem/pull/14 ), Add rdocs
- Fixed [#16]( https://github.com/urbanopt/urbanopt-reporting-gem/pull/16 ), increase sidebar width to show class names
- Fixed [#18]( https://github.com/urbanopt/urbanopt-reporting-gem/pull/18 ), measure: Handle nil values that crash OpenStudio.convert
- Fixed [#20]( https://github.com/urbanopt/urbanopt-reporting-gem/pull/20 ), fixed saving csv results bug

## Version 0.2.0

Date Range: 08/27/2020 - 09/21/2020

- Fixed [#5]( https://github.com/urbanopt/urbanopt-reporting-gem/pull/5 ), bug fixes related to REopt classes
- Fixed [#7]( https://github.com/urbanopt/urbanopt-reporting-gem/pull/7 ), adding TM symbol
- Fixed [#8]( https://github.com/urbanopt/urbanopt-reporting-gem/pull/8 ), New reopt results

## Version 0.1.1

08/26/2020

- Adding thermal storage reporting
- Fix paths for reporting and scenario gems split

## Version 0.1.0

08/17/2020

Initial release of the urbanopt-reporting gem.
