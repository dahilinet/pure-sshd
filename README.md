pure-sshd
MIT License — license.txt
version: 0.0.9 (SSH-2.0-pure-sshd_0.0.9)
target: Ubuntu 24.04 (amd64), run as root
Not OpenSSH. Not an OpenSSH replacement. Do not touch the host sshd.

this directory
  pure-sshd
  source copy + linux amd64 binary + empty identity db + sample etc
  host key was not copied (first start writes host_ed25519 next to the conf)

what it is
  vhost-jail SSH/SFTP. The customer site root becomes jail /.
  identity is not linux useradd; sqlite ssh_users.
  listen default :22

license
  MIT. copy, modify, distribute, sell. keep license.txt with every copy.
  third-party go modules: golang.org/x/crypto, golang.org/x/sys,
  github.com/creack/pty, github.com/pkg/sftp, github.com/GehirnInc/crypt
  (go.mod). respect their licenses when you redistribute.

ubuntu 24.04 needs
  - kernel bind mount + chroot (default)
  - sqlite3 CLI  (auth execs sqlite3; login fails without it)
  - bash /usr/bin/bash  (/usr is bind-mounted inside the jail)
  - if apache2 exists, startup forces mode=vhost; else mode=root (no jail)
  to rebuild: golang-go 1.22+  (do not apt-install into this tree without approval)

warning — uid move
  on vhost start, if the apache user's uid/gid is < 1000 the binary
  may usermod/groupmod to 1111 and chown matching files under /.
  stock ubuntu www-data is often 33. check www-data uid before running
  this binary as root on a random 24.04 host.
  on the source host www-data is already 1111 + group vmail (900).
  the jail process expects uid 1111 and extra group 900.

hardcoded paths (this version)
  identity db:  {binary_dir}/../var/db/master.db
                in this package var/db/master.db
  jail home:    only directories under /opt/hosting/clients/...
  runtime:      /run/pure-sshd/m/{pid}  tmpfs + site binds + /usr -> .os
  sftp:         same binary -sftp (not openssh sftp-server)
  tcp tunnel:   no
  ssh username root is not a customer login
  conf root_access is written, not read in this version

tree
  bin/pure-sshd          runnable binary (6 Nov 2026, amd64)
  etc/pure-sshd.conf     port 22, user www-data, mode vhost
  var/db/master.db       empty ssh_users (no passwords / users)
  var/run  var/log
  src/                   go source (sshtest_tmp.go not included)
  sql/ssh_users.sql      schema + sample insert
  etc/init.d/pure-sshd   start stop restart status user_add user_dell
  license.txt  readme.txt

usage — run as root from the pure-sshd directory
  init:
       etc/init.d/pure-sshd {start|stop|restart|status|user_add|user_dell}

  1) sqlite3 present:
       sqlite3 --version
  2) home must be a real directory /opt/hosting/clients/{kod}/site/{fqdn}
  3) add a user (password prompted on TTY, or piped on stdin):

       etc/init.d/pure-sshd user_add ornek_site_com \
         /opt/hosting/clients/ornekkod/site/ornek.site.com \
         ornek.site.com ornekkod

       etc/init.d/pure-sshd user_dell ornek_site_com

  4) if another pure-sshd is already running, stop it first or :22 is busy.
     trial from this tree:

       etc/init.d/pure-sshd start
       etc/init.d/pure-sshd status
       tail -f var/log/pure-sshd.log

  5) client:

       ssh ornek_site_com@127.0.0.1
       sftp ornek_site_com@127.0.0.1

  6) stop:

       etc/init.d/pure-sshd stop

manual (no init script):
  bin/pure-sshd -c etc/pure-sshd.conf
  -port 22     overrides conf port
  -c empty     /etc/pure-sshd/pure-sshd.conf  (creates if missing)

build (ubuntu 24.04, go 1.22+):
  cd src
  go build -o ../bin/pure-sshd .
  if you move the binary, master.db is resolved as ../var/db next to it.

auth
  password: SHA512-CRYPT ($6$)
  key: ssh_users.pubkey or {home}/.ssh/authorized_keys
  panel rule: login name is fqdn with dots -> underscores (ornek.site.com -> ornek_site_com)

not copied
  live host_ed25519
  live master.db users / passwords
  host isp init.d (layout.env)
  sshtest_tmp.go

do not
  remove host openssh-server
  chmod 777; bind host /opt/hosting into a customer jail
  apt/pip without approval
  copy this tree over an existing isp install
