SYSINCDIRS := /usr/include/lua5.1
INCLUDE := $(addprefix -isystem ,$(SYSINCDIRS))

CFLAGS := -std=c99 -Wall -Wextra -fPIC -flto $(INCLUDE)
LDFLAGS :=

CFILES := $(wildcard *.c)
LIBRARY := crc16.so

.PHONY: clean all debug

all: CFLAGS += -O3
all: LDFLAGS += -s
all: $(LIBRARY)

debug: CFLAGS += -ggdb -Og
debug: $(LIBRARY)

$(LIBRARY) : $(CFILES)
	$(CC) $(CFLAGS) $(LDFLAGS) -shared -o $@ $^

clean:
	@rm -rf $(LIBRARY)
