<?php

############################
# CONFIGURACION ROUNDCUBE ##
############################
// ----------------------------------
// SQL DATABASE
// ----------------------------------
$config['db_dsnw'] = 'mysql://roundcube:usuario@localhost/roundcube';

// ----------------------------------
// IMAP
// ----------------------------------
$config['default_host'] = 'ssl://correo.aldeagala.icv';

// TCP port used for IMAP connections
$config['default_port'] = 993;

$config['imap_conn_options'] = array(
    'ssl' => array(
        'verify_peer' => false,
        'verify_peer_name' => false,
    ),
);
$config['smtp_conn_options'] = array(
    'ssl' => array(
        'verify_peer' => false,
        'verify_peer_name' => false,
    ),
);

// ----------------------------------
// SMTP
// ----------------------------------
$config['smtp_server'] = 'tls://correo.aldeagala.icv';

$config['support_url'] = '';

// This key is used for encrypting purposes, like storing of imap password
// in the session.
$config['des_key'] = 'G3IT436VVYR7KSO8eF2A5Hyo';

// List of active plugins (in plugins/ directory)
$config['plugins'] = array();

$config['language'] = 'es_ES';


   