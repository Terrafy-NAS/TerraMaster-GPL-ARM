LOAD_ADDR := 0x01500000

OBJS := start64.o util.o flashdev_s.o dvrmain.o mp_src.o

all: mp.bin

#mp.bin: rtk-init.c
#	$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $^ $(LDLIBS)
#	$(STRIP) $@

clean:
	rm -f *.o init

mp.elf: $(OBJS)
	$(LD) $(LDFLAGS) -g -Ttext $(LOAD_ADDR) \
		-o $@ -e start $(OBJS) \
		-Map dvrboot.map

mp.bin: mp.elf
	$(OBJCOPY) -O binary $< $@

.PHONY: all clean
