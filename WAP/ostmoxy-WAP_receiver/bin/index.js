#!/usr/bin/env node

require( 'strict-mode' )(function () {

	const raspi = require('raspi');
	const Serial = require('raspi-serial').Serial;

	raspi.init(
		() => {
			let serial = new Serial( {portId: '/dev/serial0', baudRate: 57600} );
			serial.open(
				() => {
					serial.on('data', (data) => {

						process.stdout.write( data );

					});
					// serial.write('Hello from raspi-serial');
				});
		});

});