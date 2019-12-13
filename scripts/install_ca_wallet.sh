#!/bin/bash

create_wallet() {
  . create_ca_wallet.sh
}

move_wallet() {
  mv wallet /home/oracle
  chown -R oracle:oinstall /home/oracle/wallet
}

set_apex_wallet_and_pwd() {
  . /home/oracle/.bash_profile

  echo "Set APEX Instance SSL Wallet"
  WALLET_PWD=$(cat /home/oracle/wallet/_pwd.txt)

  echo "begin" >set_apex_wallet.sql
  echo "  apex_instance_admin.set_parameter('WALLET_PATH','file:/home/oracle/wallet');" >>set_apex_wallet.sql
  echo "  apex_instance_admin.set_parameter('WALLET_PWD','${WALLET_PWD}');" >>set_apex_wallet.sql
  echo "  commit;" >>set_apex_wallet.sql
  echo "end;" >>set_apex_wallet.sql
  echo "/" >>set_apex_wallet.sql

  echo "EXIT" | ${ORACLE_HOME}/bin/sqlplus -s -l sys/${PASS} AS SYSDBA @set_apex_wallet
}

cd /scripts
create_wallet
move_wallet
cd /files
set_apex_wallet_and_pwd
