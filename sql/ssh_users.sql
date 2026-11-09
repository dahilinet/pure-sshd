-- ssh_users — kimlik tablosu (sqlite3)
-- calisan binary su dosyayi okur: {paket}/var/db/master.db
-- (yol: executable_dir/../var/db/master.db)
--
-- home zorunlu: /opt/hosting/clients/ ile baslamali (hapis.go strHapisKok)
-- username: harf rakam _ -  (root yok, max 64)
-- password: {SHA512-CRYPT}$6$...  veya $6$...
-- sifre_acik / anahtar_acik / active: 0 kapali, 1 acik

CREATE TABLE IF NOT EXISTS ssh_users (
    username TEXT PRIMARY KEY COLLATE NOCASE,
    password TEXT NOT NULL DEFAULT '',
    pubkey TEXT NOT NULL DEFAULT '',
    home TEXT NOT NULL DEFAULT '',
    fqdn TEXT NOT NULL DEFAULT '',
    client_kod TEXT NOT NULL DEFAULT '',
    subscribed_product_id INTEGER,
    sifre_acik INTEGER NOT NULL DEFAULT 1,
    anahtar_acik INTEGER NOT NULL DEFAULT 1,
    active INTEGER NOT NULL DEFAULT 1,
    created_at TEXT NOT NULL DEFAULT (datetime('now')),
    updated_at TEXT NOT NULL DEFAULT (datetime('now')),
    password_enc TEXT NOT NULL DEFAULT ''
);

-- ornek (hash'i kendin uret, asagidaki sahte):
-- INSERT INTO ssh_users (username, password, home, fqdn, client_kod, sifre_acik, anahtar_acik, active)
-- VALUES (
--   'ornek_site_com',
--   '{SHA512-CRYPT}$6$xxxxxxxx$yyyyyyyy',
--   '/opt/hosting/clients/ornekkod/site/ornek.site.com',
--   'ornek.site.com',
--   'ornekkod',
--   1, 0, 1
-- );
