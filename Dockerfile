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
#

FROM ubuntu:20.04

LABEL maintainer="Victor Fusco <victor@cartesi.io>"

RUN apt-get update && apt-get install -y \
    make git vim wget genext2fs e2tools \
    ca-certificates libreadline8 openssl libgomp1 \
    libboost-program-options1.71.0 \
    libboost-serialization1.71.0 \
    libprotobuf17 libprotobuf-lite17 libgrpc++1 \
    && rm -rf /var/lib/apt/lists/*

ENV PATH="/opt/cartesi/bin:/opt/riscv/riscv64-cartesi-linux-gnu/bin:${PATH}"

WORKDIR /opt/cartesi

# Setup su-exec
COPY --from=cartesi/toolchain:0.5.0 /usr/local/bin/su-exec /usr/local/bin/su-exec
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# Copy emulator, toolchain, buildroot and kernel
COPY --from=cartesi/machine-emulator:0.7.0 /opt/cartesi /opt/cartesi
COPY --from=cartesi/toolchain:0.5.0 /opt/riscv /opt/riscv
COPY --from=cartesi/linux-kernel:0.7.0 /opt/riscv/kernel/artifacts/linux-5.5.19-ctsi-2.bin /opt/cartesi/share/images/
COPY --from=cartesi/rootfs:0.6.0 /opt/riscv/rootfs/artifacts/rootfs.ext2 /opt/cartesi/share/images/

# Download emulator binary images
RUN \
    wget -O /opt/cartesi/share/images/rom.bin https://github.com/cartesi/machine-emulator-rom/releases/download/v0.4.0/rom.bin && \
    cd /opt/cartesi/share/images && ln -s linux-5.5.19-ctsi-2.bin linux.bin


ENTRYPOINT [ "/usr/local/bin/entrypoint.sh" ]

