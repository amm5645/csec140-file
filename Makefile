# Complex example Makefile (illustrative)

CC       := gcc
CXX      := g++
AR       := ar
RM       := rm -f

BUILD    := build
BIN      := bin
SRC      := src
INC      := include
LIB      := lib

CFLAGS   := -O2 -Wall -Wextra -Wshadow -Winvalid-pch -MMD -MP -I$(INC)
LDFLAGS  := -L$(LIB)
LDLIBS   := -lm -lpthread -lssl -lcrypto

CORE_SRCS := $(SRC)/main.c \
             $(SRC)/engine.c \
             $(SRC)/scheduler.c \
             $(SRC)/database.c \
             $(SRC)/network.c \
             $(SRC)/crypto.c

UTIL_SRCS := $(SRC)/util/file.c \
             $(SRC)/util/log.c \
             $(SRC)/util/config.c

OBJS := $(patsubst $(SRC)/%.c,$(BUILD)/%.o,$(CORE_SRCS) $(UTIL_SRCS))
DEPS := $(OBJS:.o=.d)

TARGET := $(BIN)/enterprise_app

.PHONY: all clean debug release install test docs lint package

all: release

release: CFLAGS += -DNDEBUG
release: $(TARGET)

debug: CFLAGS += -g -O0 -DDEBUG
debug: $(TARGET)

$(TARGET): $(OBJS)
	@mkdir -p $(BIN)
	$(CC) $(OBJS) $(LDFLAGS) $(LDLIBS) -o $@

$(BUILD)/%.o: $(SRC)/%.c
	@mkdir -p $(dir $@)
	$(CC) $(CFLAGS) -c $< -o $@

test:
	@echo "Running unit tests..."
	@./tests/run_all.sh

docs:
	doxygen Doxyfile

lint:
	cppcheck --enable=all $(SRC)

package:
	tar -czf release.tar.gz $(BIN) README.md LICENSE

install:
	install -m 755 $(TARGET) /usr/local/bin/

clean:
	$(RM) -r $(BUILD) $(BIN) release.tar.gz

-include $(DEPS)