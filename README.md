# e-Špediter
e-Špediter is a mobile application that allows interaction between freight companies and others who need services provided by freight companies. Freight comapnies are able to share information about thier companies and routes they take. Other users are able to search routes they need and take contact info of the company they want to interact with.
# Prerequisites
In order to run the application on emulator or on device (so far, it is runnable from IDE only), following is required:
•	Download Git and run Git Bash
•	Download Flutter and run flutter_console.bot
•	Download Andorid Studio for emulator
•	Copy path of bin folder (from Flutter installation folder) into system paths
# Installing
Get the project files, open the project from the IDE. After the device/emulator is connected, in order to run the application, type in terminal:
		flutter run
After some time, the application will be built on the device/emulator connected and it will be usasble on the device.
# Changes
•	V1 – Sprint 1
o	User Story 1 – Log In Screen done, but having a lot of both, functional and UI bugs
o	User Story 2 – Create Route Screen having many bugs
•	V2 – Sprint 2
o	User Story 1 – Log In Screen bugs resolved:
	Checking internet connection and showing No Internet Connection Screen if there is no connection
	Focus and error text color of hint text
	Validating password if e-mail entered is wrong
	Toast error
	Validations of e-mail and password fields
	Redirection after successful log in
	Capital letters and text color of hint texts
	Disabled multiple click on 'PRIJAVA' button
	Scroll on Log In Screen
	Autocomplete in e-mail field
o	User Story 2 – Create Route Screen bugs resolved:
	Redirect to List of Routes or No Routes Screen when X button in AppBar is clicked
	Addin and removing fileds for interdestinations
	Design and deafult value of dropdown button
	Height of fields in the upper part of the screen
	Disable focus on 'Datum polaska' field
	Make timepicker not return 00:00 when 'Cancel' is clicked on the timepicker
	Validation of all fields
	Numeric keyboard on 'Popunjenost u procentima' and 'Kapacitet u tonama' fields
	Format input on 'Kapacitet u tonama' field
	Format of 'Dimenzije' field as hint text
	Enable/disable 'KREIRAJ RUTU' button
	Scroll on Create Route Screen
	Writing interdestinations into database

