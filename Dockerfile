# Copyright 2020 Cartesi Pte. Ltd.
#
# Licensed under the Apache License, Version 2.0 (the "License"); you may not
# use this file except in compliance with the License. You may obtain a copy of
# the License at http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
# License for the specific language governing permissions and limitations under
# the License.

FROM ubuntu:22.04 as lua

RUN apt-get update && \
    DEBIAN_FRONTEND="noninteractive" apt-get install --no-install-recommends -y \
        build-essential wget git \
        libssl-dev zlib1g-dev \
        ca-certificates automake libtool lua5.3 liblua5.3-dev luarocks && \
    rm -rf /var/lib/apt/lists/*

RUN luarocks install luasocket && \
    luarocks install luasec && \
    luarocks install lpeg && \
    luarocks install dkjson && \
    luarocks install md5 && \
    luarocks install dkjson


FROM ubuntu:22.04

RUN apt-get update && DEBIAN_FRONTEND="noninteractive" apt-get install -y \
    libboost-coroutine1.74.0 \
    libboost-context1.74.0 \
    libboost-filesystem1.74.0 \
    libboost-log1.74.0 \
    libreadline8 \
    openssl \
    libc-ares2 \
    zlib1g \
    ca-certificates \
    libgomp1 \
    lua5.3 \
    genext2fs \
    libb64-0d \
    libcrypto++8 \
    vim \
    net-tools \
    wget \
    e2tools \
    gettext \
    genext2fs \
    jq \
    file \
    devio \
    make \
    && rm -rf /var/lib/apt/lists/*

ENV PATH="/opt/cartesi/bin:/opt/riscv/riscv64-cartesi-linux-gnu/bin:${PATH}"

WORKDIR /opt/cartesi

# Create user developer
RUN adduser developer -u 499 --gecos ",,," --disabled-password

# Setup su-exec
COPY --from=cartesi/toolchain:0.14.0 /usr/local/bin/su-exec /usr/local/bin/su-exec
COPY --from=cartesi/toolchain:0.14.0 /usr/local/bin/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# Copy Lua
COPY --from=lua /usr/local/lib/lua /usr/local/lib/lua
COPY --from=lua /usr/local/share/lua /usr/local/share/lua

# Copy emulator, toolchain, rootfs, kernel, and rom
COPY --from=cartesi/machine-emulator:0.14.0 /opt/cartesi /opt/cartesi
COPY --from=cartesi/toolchain:0.14.0 /opt/riscv /opt/riscv
COPY --from=cartesi/linux-kernel:0.16.0 /opt/riscv/kernel/artifacts/linux-5.15.63-ctsi-2.bin /opt/cartesi/share/images/linux.bin
COPY --from=cartesi/rootfs:0.17.0 /opt/riscv/rootfs/artifacts/rootfs.ext2 /opt/cartesi/share/images/
RUN \
    wget -O /opt/cartesi/share/images/rom.bin https://github.com/cartesi/machine-emulator-rom/releases/download/v0.16.0/rom-v0.16.0.bin

COPY lua-paths.lua /opt/cartesi/share/
ENV LUA_INIT=@/opt/cartesi/share/lua-paths.lua

ENTRYPOINT [ "/usr/local/bin/entrypoint.sh" ]
