# Could be clearer

what is wb_sel?
wb_sel[ wb_data_w / 8 : 0 ]
when writing, if data is multibyte, then one bit of wb_sel must be set to choose which byte will be written

mostly, what the process should be. Mine was:

* flip all assertions and assumptions in the slave template and save as master
* wire up templates in the arbiter file
* start making tests by assuming various master behavours and asserting the results

# Questions

* are the formal properties files like test templates? they don't contain the logic of the slave or master, just formally prove that the slave or master is behaving properly.


