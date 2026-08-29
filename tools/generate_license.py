#!/usr/bin/env python3
"""Generate a DJ Script Manager license key using the product secret."""

from __future__ import annotations

import argparse
import hashlib
import hmac
import os
import random
import re
import time

DEFAULT_SECRET = "djsm.v1.dd1e9aff069bc38ed4f7270a79285031"


def read_secret(path: str) -> str:
    if not os.path.isfile(path):
        return DEFAULT_SECRET
    text = open(path, encoding="utf-8").read()
    match = re.search(r"License\.ProductSecret\s*=\s*'([^']+)'", text)
    return match.group(1) if match else DEFAULT_SECRET


def make_key(secret: str, bind: str = "*") -> str:
    nonce = hashlib.sha256(f"djsm:{time.time()}:{random.random()}".encode()).hexdigest()[:8].upper()
    msg = f"DJSM|v1|{nonce}|{bind}".encode()
    mac = hmac.new(secret.encode(), msg, hashlib.sha256).hexdigest()[:8].upper()
    return f"DJSM-{nonce[:4]}-{nonce[4:]}-{mac[:4]}-{mac[4:]}"


def verify(secret: str, key: str, bind: str = "*") -> bool:
    parts = key.upper().split("-")
    if len(parts) != 5 or parts[0] != "DJSM":
        return False
    nonce = parts[1] + parts[2]
    got = parts[3] + parts[4]
    msg = f"DJSM|v1|{nonce}|{bind}".encode()
    mac = hmac.new(secret.encode(), msg, hashlib.sha256).hexdigest()[:8].upper()
    return hmac.compare_digest(got, mac)


def main() -> None:
    parser = argparse.ArgumentParser(description="Generate djfivem-scriptmanager license keys")
    parser.add_argument("--secret-file", default="server/license.lua")
    parser.add_argument("--bind", default="*", help="Use * or a FiveM sv_licenseKey")
    parser.add_argument("--verify", help="Verify an existing key and exit")
    args = parser.parse_args()
    secret = read_secret(args.secret_file)
    if args.verify:
        ok = verify(secret, args.verify, args.bind)
        print("VALID" if ok else "INVALID")
        raise SystemExit(0 if ok else 1)
    key = make_key(secret, args.bind)
    print(key)
    print()
    print("Paste into config.lua:")
    print(f"    Config.License = '{key}'")
    if args.bind != "*":
        print("This key is bound to the given sv_licenseKey. Set Config.BindLicenseToServer = true")


if __name__ == "__main__":
    main()
