#!/usr/bin/env bash
#

# Info
# https://raw.githubusercontent.com/bnoordhuis/mozilla-central/master/toolkit/crashreporter/client/certdata2pem.py
# https://raw.githubusercontent.com/alpinelinux/ca-certificates/master/certdata2pem.py
# https://www.mozilla.org/en-US/about/governance/policies/security-group/certs/
# https://hg.mozilla.org/mozilla-central/raw-file/tip/security/nss/lib/ckfw/builtins/certdata.txt

# Usage:
# . create_ca_wallet.sh

# Set env vars
set_env() {
    export WORKING_DIR=$(pwd)
    export OUTPUT_TMP_DIR=$WORKING_DIR/output
    export WALLET_DIR=$WORKING_DIR/wallet
}

# Create needed folders
create_folders() {
    mkdir $OUTPUT_TMP_DIR
    if [ ! -d $WALLET_DIR ]; then
        mkdir $WALLET_DIR
    fi
}

# Get mozilla resources & scripts
fetch_scripts() {
    echo ""
    echo "**** Fetching script & certificates data from mozilla ****"
    curl -O https://raw.githubusercontent.com/alpinelinux/ca-certificates/3184fe80e403b9dc6d5fe3b7ebcd9d375363e2e4/certdata2pem.py
    curl -O https://hg.mozilla.org/mozilla-central/raw-file/tip/security/nss/lib/ckfw/builtins/certdata.txt
    curl -O https://git.launchpad.net/ubuntu/+source/ca-certificates/plain/mozilla/blacklist.txt
    chmod +x certdata2pem.py
}

# extract pem from data
convert_certdata_pem() {
    echo ""
    echo "**** Extracting data from certdata.txt and creating certificates ****"
    python certdata2pem.py
}

# Create password file
create_password_file() {
    if [ ! -f $WALLET_DIR/_pwd.txt ]; then
        echo ""
        echo "**** Creating Password File ****"
        echo "Location: ${WALLET_DIR}/_pwd.txt"
        openssl rand -base64 64 | tr -dc 'a-zA-Z0-9' | fold -w 40 | head -n 1 >$WALLET_DIR/_pwd.txt
    else
        echo ""
        echo "**** Password File already present ****"
        echo "Location: ${WALLET_DIR}/_pwd.txt"
    fi
}

# Create Oracle wallet
create_oracle_wallet() {
    echo ""
    echo "**** Creating Oracle Wallet containing all CA certificates ****"
    if type "orapki" >/dev/null; then
        echo ""
        echo "> Creating Wallet with orapki"
        orapki wallet create -wallet $WALLET_DIR -pwd <(cat $WALLET_DIR/_pwd.txt) -auto_login
        echo ""
        echo "> Add each single CA certificate to Wallet"
        for file in $OUTPUT_TMP_DIR/*.crt; do
            orapki wallet add -wallet $WALLET_DIR -trusted_cert -cert $file -pwd <(cat $WALLET_DIR/_pwd.txt)
        done
    else
        echo ""
        echo "> Build single certificate file containing all CAs"
        for file in $OUTPUT_TMP_DIR/*.crt; do
            cat $file >>$WALLET_DIR/ca-certificates.crt
        done
        echo ""
        echo "> Creating Wallet with openssl"
        openssl pkcs12 -export -in $WALLET_DIR/ca-certificates.crt -out $WALLET_DIR/ewallet.p12 -nokeys -passout file:$WALLET_DIR/_pwd.txt
    fi
}

# Cleanup
cleanup() {
    rm -fr $OUTPUT_TMP_DIR
    rm -f $WALLET_DIR/ca-certificates.crt
}

# End output
end_output() {
    echo ""
    echo "**** Done ****"
    echo "Location: ${WALLET_DIR}"
}

# Execute functions
set_env
create_folders
cd $OUTPUT_TMP_DIR
fetch_scripts
convert_certdata_pem
cd $WORKING_DIR
create_password_file
create_oracle_wallet
cleanup
end_output
