#!/usr/bin/env bash
#

# Info
# https://raw.githubusercontent.com/bnoordhuis/mozilla-central/master/toolkit/crashreporter/client/certdata2pem.py
# https://raw.githubusercontent.com/alpinelinux/ca-certificates/master/certdata2pem.py
# https://www.mozilla.org/en-US/about/governance/policies/security-group/certs/
# https://hg.mozilla.org/mozilla-central/raw-file/tip/security/nss/lib/ckfw/builtins/certdata.txt

# Usage:
# . create_ca_wallet.sh

# vars
export WORKING_DIR=$(pwd)
export OUTPUT_TMP_DIR=$WORKING_DIR/output
export WALLET_DIR=$WORKING_DIR/wallet

# create needed folders
mkdir $OUTPUT_TMP_DIR
if [ ! -d $WALLET_DIR ]; then
    mkdir $WALLET_DIR
fi

# get mozilla resources
echo "**** Fetching script & certificates data from mozilla ****"
cd $OUTPUT_TMP_DIR
curl -O https://raw.githubusercontent.com/alpinelinux/ca-certificates/master/certdata2pem.py
curl -O https://hg.mozilla.org/mozilla-central/raw-file/tip/security/nss/lib/ckfw/builtins/certdata.txt
curl -O https://git.launchpad.net/ubuntu/+source/ca-certificates/plain/mozilla/blacklist.txt
chmod +x certdata2pem.py

# extract pem from data
echo ""
echo "**** Extracting data from certdata.txt and creating certificates ****"
python certdata2pem.py

cd $WORKING_DIR

# create password file
if [ ! -f $WALLET_DIR/_pwd.txt ]; then
    echo ""
    echo "**** Creating Password File ****"
    echo "Location: ${WALLET_DIR}/_pwd.txt"
    openssl rand -base64 32 >$WALLET_DIR/_pwd.txt
else
    echo ""
    echo "**** Password File already present ****"
    echo "Location: ${WALLET_DIR}/_pwd.txt"
fi

# create Oracle wallet
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

# cleanup
rm -fr $OUTPUT_TMP_DIR
rm -f $WALLET_DIR/ca-certificates.crt

echo ""
echo "**** Done ****"
echo "Location: ${WALLET_DIR}"
