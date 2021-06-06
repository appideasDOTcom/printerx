#!/usr/bin/env node

/**
 * Standalone script to read serial input from an ESP8266-12E over the serial (TX/RX)
 *   pins and set the server's WiFi credentials accordng to the input
 *
 * Must be run as root
 */

 require( 'strict-mode' )(function () {

	const { exec } = require( 'child_process' );
	const raspi = require( 'raspi' );
	const Serial = require( 'raspi-serial' ).Serial;
	const shell = require( 'shelljs' );
	const fs = require( 'fs' );
	const dateFormat = require( 'dateformat' );

	const baseDir = "/home/pi/.ostmoxy";
	const backupDir = baseDir + "/backups";
	const wpaInputFile = "/boot/octopi-wpa-supplicant.txt";

	// Require root user before continuing
	if( process.env.USER != "root" ) {
		console.log( "This script must be run as root." );
		process.exit( 0 );
	}

	/**
	 * Write a new WPA supplicant file before rebooting
	 *
	 * @param JSON	jsonData			Incoming data object
	 */
	writeWpaSupplicantFile =
	( {jsonData = null} ) =>
	{
		return new Promise(
			(resolve, reject) =>
			{
				let now = new Date();
				let fileDate = dateFormat( now, "yyyymmdd-HHMMss" );
				let outputFile = backupDir + "/octopi-wpa-supplicant.txt." + fileDate;

				shell.cp( wpaInputFile, outputFile );
				let wpaContent = "";

				// Write the values to /boot/octopi-wpa-supplicant.txt
				if( jsonData && jsonData.password && jsonData.password.length > 0 )
				{
					wpaContent =
					"## WPA/WPA2 secured\n" +
					"network={\n" +
					"  ssid=\"" + jsonData.ssid + "\"\n" +
					"  psk=\"" + jsonData.password + "\"\n" +
					"}\n";
				} else {
					wpaContent =
					"## Open/unsecured\n" +
					"network={\n" +
					"  ssid=\"" + jsonData.ssid + "\"\n" +
					"  key_mgmt=NONE\n" +
					"}\n";
				}

				wpaContent +=
				"country=US # United States\n" +
				"ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev\n" +
				"update_config=1";

				fs.writeFileSync( wpaInputFile, wpaContent );
				return resolve( true );
			}
		);
	}

	/**
	 * Reboot the rPi
	 */
	reboot =
	() => {
		exec( "shutdown -r now", ( error, stdout, stderr ) =>{} );
	}

	/**
	 * Parses incoming data and send readable results to a handler
	 */
	parseInput =
	( {input = null} ) => {

		try
		{
			// Sanity check the input
			let jsonData = JSON.parse( input.toString() );
			if( !jsonData || !jsonData.action || !jsonData.ssid )
			{
				console.log( "JSON DATA WAS INVALID" );
				console.log( input.toString() );
				return;
			}
			// Set WiFi on request
			else if( jsonData.action == "set-wifi" )
			{
				writeWpaSupplicantFile( {jsonData: jsonData} )
					.then(
						(supplicantResponse) => {
							// Reboot the rPi after a short pause to make sure IO is complete
							setTimeout(
								() =>
								{
									reboot();
									return;
								}, 5000
							);
						}
					 );

			} else {

				console.log( "NO DEFINED HANDLER FOR INPUT" );
				console.log( jsonData );
			}
		}
		catch( error )
		{
			console.log( "CAUGHT ERROR" );
			console.log( error );
			return;
		}
	}

	// Make sure everything's setup
	init = () =>
	{
		if( !fs.existsSync( backupDir ) )
		{
			shell.mkdir( "-p", backupDir );
		}
	}
	init();

	// Ingest some data...

	// An incoming string buffer
	let incoming = "";
	// Listen to the serial port
	raspi.init(
		() => {
			let serial = new Serial( {portId: '/dev/serial0', baudRate: 9600} );
			serial.open(
				() => {
					serial.on( 'data',
						(data) => {
							// Don't send for processing until we have end of line
							incoming += data;
							if( data.toString().endsWith( "\n" ) ) {
								parseInput( {input: incoming} );
								incoming = "";
							}
						});
				});
		});

});
