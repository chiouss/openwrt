#!/usr/bin/env python3
#
# LOCAL: not for upstream.
#
# Pack QCN9274 firmware images into an ath12k firmware-2.bin container.
#
# ath12k only programs a unique QRTR node id for a PCI device when the
# firmware advertises ATH12K_FW_FEATURE_MULTI_QRTR_ID, which is stored in
# firmware-2.bin. Without it, the QCN9274 firmware registers its QMI
# service with an instance id that collides with the IPQ5332 AHB radio.
#
# usage: mkfw2.py <amss.bin> <amss_dualmac.bin> <m3.bin> <timestamp> <out>

import struct
import sys

MAGIC = b"QCOM-ATH12K-FW\0"

IE_TIMESTAMP = 0
IE_FEATURES = 1
IE_AMSS_IMAGE = 2
IE_M3_IMAGE = 3
IE_AMSS_DUALMAC_IMAGE = 4

# ATH12K_FW_FEATURE_MULTI_QRTR_ID | ATH12K_FW_FEATURE_MLO, as in the
# linux-firmware QCN9274 hw2.0 firmware-2.bin
FEATURES = bytes([0x03])


def pad4(data):
    return data + b"\0" * (-len(data) % 4)


def ie(ie_id, data):
    return struct.pack("<II", ie_id, len(data)) + pad4(data)


def read(path):
    with open(path, "rb") as f:
        return f.read()


def main():
    if len(sys.argv) != 6:
        sys.exit(__doc__ or "usage: mkfw2.py amss dualmac m3 timestamp out")

    amss, dualmac, m3, timestamp, out = sys.argv[1:]

    blob = pad4(MAGIC)
    blob += ie(IE_TIMESTAMP, struct.pack("<I", int(timestamp)))
    blob += ie(IE_M3_IMAGE, read(m3))
    blob += ie(IE_AMSS_IMAGE, read(amss))
    blob += ie(IE_AMSS_DUALMAC_IMAGE, read(dualmac))
    blob += ie(IE_FEATURES, FEATURES)

    with open(out, "wb") as f:
        f.write(blob)


if __name__ == "__main__":
    main()
