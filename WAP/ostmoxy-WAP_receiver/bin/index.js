#!/usr/bin/env node

require( 'strict-mode' )(function () {

	const raspi = require('raspi');
	const Serial = require('raspi-serial').Serial;

	parseInput = ( {input = null} ) => {
		// console.log( "GOT INPUT: " + input );
		let jsonData = JSON.parse( input.toString() );
		console.log( "GOT DATA: " );
		// console.log( "ACTION : " + jsonData.action );
		// console.log( "SSID   : " + jsonData.ssid );
		// console.log( "PASS   : " + jsonData.password );

		// TODO: Write the values to /boot/octopi-wpa-supplicant.txt
		// TODO: Reboot the rPi
	}

	// An incoming string buffer
	let incoming = "";
	// Listen to the serial port
	raspi.init(
		() => {
			let serial = new Serial( {portId: '/dev/serial0', baudRate: 57600} );
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