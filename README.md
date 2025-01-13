# Urpagin.net

## Deploy on Push (Continuous Deployment with Docker & GitHub Actions)

The following steps assume you are working on a Linux machine.

### Steps to Set Up Continuous Deployment:

1. On your **local machine**, generate a new SSH key by running:
   ```bash
   ssh-keygen -t ed25519 -f ~/.ssh/deploy_key
   ```

2. Copy the generated public SSH key to your server (the one where the website will run) by using the following command:
   ```bash
   ssh-copy-id -i ~/.ssh/deploy_key.pub user@host
   ```

3. Go to your GitHub repository and navigate to:
   **Settings** -> **Secrets and variables** -> **Actions** -> **New repository secret**.  
   Add the following secrets:

   - `PROJECT_PATH`: The absolute path where you cloned your repository on the remote server (e.g., `/home/debian/urpagin-dot-net/`).
   - `SSH_USER`: The username used to log in to your remote server.
   - `SSH_HOST`: The IP address of the remote server.
   - `SSH_PRIVATE_KEY`: On your **local machine**, copy the contents of the `~/.ssh/deploy_key` file, which contains the private SSH key.

4. On your remote server, run the `build_and_run.sh` script to start the project.  
   From this point onward, any `git push` action to the `master` branch will automatically trigger the `build_and_run.sh` script, via SSH, to update the website.

---

## Manual Deployment (Using Docker)

On your remote server, follow these steps:

1. Clone the repository:
   ```bash
   git clone https://github.com/Urpagin/urpagin-dot-net.git
   ```

2. Navigate to the project directory:
   ```bash
   cd urpagin-dot-net/
   ```

3. Make the `build_and_run.sh` script executable:
   ```bash
   chmod +x build_and_run.sh
   ```

4. Run the script:
   ```bash
   ./build_and_run.sh
   ```

## Manual Deployment (Using npm)

### Developing

Start a development server:

```bash
npm run dev

# or start the server and open the app in a new browser tab
npm run dev -- --open
```

### Building

To create a production version of your app:
```bash
npm run build
```
You can preview the production build with `npm run preview`.
> To deploy your app, you may need to install an [adapter](https://svelte.dev/docs/kit/adapters) for your target environment.
