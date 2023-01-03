PREFIX := /boot/overlays

dtbos := $(patsubst %.dts,%.dtbo,$(wildcard *.dts))

%.dtbo: %.dts
	dtc -@ -I dts -O dtb -o $@ $<

.PHONY: all
all: $(dtbos)

.PHONY: clean
clean:
	rm -f *.dtbo

install: $(dtbos)
	install -D $(dtbos) -t $(PREFIX)
