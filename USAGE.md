### 📁 Configuration Directory Structure

Your Neovim configuration is typically located at:

```bash
~/.config/nvim/
```

Important files and directories include:

* `init.lua` or `init.vim`: The main entrypoint
* `lua/`: Contains modular Lua-based configuration
* `lua/gale/`: Main module, includes components like `utils`, `mappings`, `plugins`, etc.

---

### 🗂 Option 1: Backup via Git

```bash
cd ~/.config
git clone --bare https://github.com/<username>/nvim-config.git nvim-config.git
cd nvim
git init
git remote add origin https://github.com/<username>/nvim-config.git
git add .
git commit -m "Backup nvim config"
git push origin main # or master
```

> **Tip:** You can use a symlink to keep the config directly under `~/.config/nvim/`.

---

### 🗂 Option 2: Manual Backup with Archive

```bash
cd ~/.config
tar -czvf nvim-backup.tar.gz nvim/
```

---

### 💻 Setting Up Neovim Config on a New Machine

#### 1. Install Neovim

```bash
brew install neovim        # macOS
sudo apt install neovim    # Ubuntu
```

#### 2. Clone Your Config to the Right Directory

```bash
git clone https://github.com/<username>/nvim-config.git ~/.config/nvim
```

Or if you're using a `.tar.gz` archive:

```bash
tar -xzvf nvim-backup.tar.gz -C ~/.config/
```
