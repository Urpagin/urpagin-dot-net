# Urpagin.net

A simple, fast, and minimalist personal website.


# Setup

1. Clone the repo

2. Create the `.env` file and add a `WEBHOOK_SECRET=<secret>` field.
- Replace `<secret>` by the output of the `openssl rand -hex 128` linux command.
- Add `GIT_REPO=<current_git_repo_url(here https://github.com/Urpagin/urpagin-dot-net.git)>`
- Go to your GitHub repo → Settings → Webhooks
- Click "Add Webhook"
- Fill out the fields and add 
    - Payload URL: `http://your-server-ip:42047/webhook`
    - Content Type: `application/json`
    - Secret: `<secret>`


3. `docker compose up -d`

4. Up & running at `your_server_ip:42047`


# Caddy ?

In order to update the website as soon as there is a git push on the `master` branch.