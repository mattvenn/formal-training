# Could be clearer

what is wb_sel?
wb_sel[ wb_data_w / 8 : 0 ]
when writing, if data is multibyte, then one bit of wb_sel must be set to choose which byte will be written

# Questions

are the formal properties files like test templates? they don't contain the logic of the slave or master, just formally prove that the slave or master is behaving properly.
