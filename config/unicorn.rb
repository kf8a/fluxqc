worker_processes 3
listen "/var/u/apps/fluxqc/current/tmp/unicorn.sock", :backlog => 64
#listen 5000
pid "/var/u/apps/fluxqc/shared/pids/unicorn.pid"
stderr_path "/var/u/apps/fluxqc/current/log/unicorn.log"
stdout_path "/var/u/apps/fluxqc/current/log/unicorn.log"
timeout 4000
