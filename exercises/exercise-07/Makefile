PROJ=wbpriarbiter
SRC = *v
FORMAL_FILE = $(PROJ).sby

formal: $(FORMAL_FILE)
	sby -f $^

gtkwave: $(PROJ)/engine_0/trace*.vcd
	gtkwave $^ $(PROJ).gtkw

phony: formal gtkwave

