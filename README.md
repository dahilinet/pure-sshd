# pure-sshd — ara (2026-11-06 02:57 +03)

Bagimsiz SSH (OpenSSH degil). MIT, sonra GitHub. Dil: Go.
Slogan: vhost-jail SSH; OpenSSH server replacement.

Bu dosya tek kaynak. Sonraki oturum buradan devam.

## durak

| | |
|---|---|
| surum | **0.0.4** (`SSH-2.0-pure-sshd_0.0.4`) |
| durum | `:22` dinliyor; **sifre+anahtar** (`ssh_users`); hapis yok (kanal Prohibited) |
| pid | `/run/pure-sshd.pid` |
| son komut | `/usr/sbin/pure-sshd -c /etc/pure-sshd/pure-sshd.conf` |
| bu host | apache var → `mode=vhost` `user=www-data` |
| yapilmayan | kimlik, hapis, SFTP, kabuk, systemd, GitHub |

Kapatmak: `kill $(cat /run/pure-sshd.pid)` — 22'e dokunma.

## yer

| | |
|---|---|
| ikili | `/usr/sbin/pure-sshd` |
| kaynak | `/usr/src/pure-sshd/` (`main.go` `cfg.go` `go.mod` `LICENSE` `README.md`) |
| deneme cnf | `/etc/pure-sshd/pure-sshd.conf` |
| deneme host key | `/etc/pure-sshd/host_ed25519` (0600, cnf yaninda) |
| eski key (kullanilmiyor) | `/var/lib/pure-sshd/host_ed25519` |
| varsayilan cnf (`-c` yok) | `/etc/pure-sshd/pure-sshd.conf` — bu hostta henuz yok |
| log | `/var/log/pure-sshd.log` |

Build: `cd /usr/src/pure-sshd && go build -o /usr/sbin/pure-sshd .`  
Go 1.22, `golang.org/x/crypto v0.31.0`.

## bayrak / cnf

```
/usr/sbin/pure-sshd                # /etc/pure-sshd/pure-sshd.conf (yoksa yazar)
/usr/sbin/pure-sshd -port 22     # konfig portunu ezer
```

cnf (yoksa bir kez yazilir, var olan **ezilmez**):

```
port = 22
user = www-data
mode = vhost
root_access = kapali
```
