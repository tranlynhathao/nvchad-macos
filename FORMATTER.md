## 🧠 About Formatting: Tabs vs Spaces

The behavior of formatting — specifically whether **1 tab equals 2 spaces or 4 spaces** — **does not depend on the `conform.nvim` plugin itself**, but rather on the **configuration of the individual formatters** like `prettier`, `clang-format`, `black`, etc. Each formatter has its **own default style**, which you can usually override with config files.

---

### 🔹 **Uses 2 spaces by default**

| Language                      | Formatter         | Notes                     |
|------------------------------|-------------------|---------------------------|
| JavaScript / TypeScript / JSX| `prettier`        | Defaults to 2 spaces      |
| CSS / SCSS                   | `prettier`        | Defaults to 2 spaces      |
| HTML                         | `prettier`        | Defaults to 2 spaces      |
| Vue / Svelte                 | `prettier`        | Defaults to 2 spaces      |
| JSON                         | `biome`, `prettier` | Both default to 2 spaces |
| Solidity                     | `prettier`        | Defaults to 2 spaces      |
| TOML                         | `taplo`           | Defaults to 2 spaces      |
| YAML                         | `yamlfmt`         | Defaults to 2 spaces      |
| Markdown                     | `prettier`, `markdownlint` | Usually 2 spaces |

---

### 🔸 **Uses 4 spaces by default**

| Language | Formatter            | Notes                                           |
|----------|----------------------|-------------------------------------------------|
| Python   | `black`              | Always 4 spaces, non-configurable               |
| C / C++  | `clang-format`       | Defaults to 4 spaces (can be configured)        |
| C#       | `clang-format`, `dotnet-format` | Defaults to 4 spaces         |
| Go       | `gofmt`              | Uses tabs (not spaces), commonly shown as 4    |
| Rust     | `rustfmt`            | Defaults to 4 spaces                            |
| Java     | `google-java-format` | Defaults to 4 spaces                            |
| PHP      | `phpcbf`             | Defaults to 4 spaces                            |
| Ruby     | `rufo`               | Defaults to 2 spaces, but `rubocop` can vary    |
| Kotlin   | `ktlint`             | Defaults to 4 spaces                            |
| SQL      | `sqlformat`          | Defaults to 4 spaces                            |
| Lua      | `stylua`             | Defaults to 2 spaces, configurable              |
| Bash     | `shfmt`              | Defaults to 4 spaces                            |

---

### 🔁 Configurable Formatters

Most formatters allow you to override the default style via config files:

| Formatter     | Config file             | Example setting                        |
|---------------|-------------------------|----------------------------------------|
| `prettier`    | `.prettierrc`           | `{ "tabWidth": 2, "useTabs": false }`  |
| `clang-format`| `.clang-format`         | `IndentWidth: 2`                       |
| `stylua`      | `stylua.toml`           | `indent_width = 2`                     |
| `yamlfmt`     | CLI args or config      | `--indent 2` or custom config          |

---

### ✅ How to Inspect / Control Formatting in Practice

1. **Trigger formatting manually**:
   - Run the keymap: `<leader>fm` in normal mode.
   - Then check current editor indent settings with:

     ```
     :set tabstop? shiftwidth? expandtab?
     ```

2. **Override formatting globally**:
   - Create or edit formatter-specific config files.
   - Example `.prettierrc`:

     ```json
     {
       "tabWidth": 2,
       "useTabs": false
     }
     ```

---

## ✅ Languages with 4-space default formatters that support 2-space indentation

| Language | Default Formatter (4 spaces) | Alternative Formatter / Configuration for 2 Spaces |
|----------|-------------------------------|----------------------------------------------------|
| **C / C++ / C#** | `clang-format` | Configure `.clang-format` with `IndentWidth: 2` citeturn0search5 |
| **Go** | `gofmt` | Use `shfmt` with `-i 2` for shell scripts citeturn0search24 |
| **Python** | `black` (enforces 4 spaces) | Use `autopep8`, `yapf`, or `ruff_format` with custom settings |
| **Rust** | `rustfmt` | Set `tab_spaces = 2` in `rustfmt.toml` citeturn0search11 |
| **Java** | `google-java-format` | Use `clang-format` with Java support and set `IndentWidth: 2` |
| **PHP** | `phpcbf` | Use `php-cs-fixer` with `'indentation_type' => 'spaces'` and set indentation to 2 spaces citeturn0search3 |
| **Ruby** | `rubocop` | Configure `.rubocop.yml` with `Layout/IndentationWidth: Width: 2` citeturn0search7 |
| **Kotlin** | `ktlint` | Use `ktfmt` or `detekt` with indentation settings set to 2 spaces |
| **SQL** | `sqlformat` | Use `sqlfluff` with `indent_unit: "  "` in `.sqlfluff` config |
| **Lua** | `stylua` | Set `indent_width = 2` in `stylua.toml` |
| **Bash** | `shfmt` | Run with `-i 2` to set indentation to 2 spaces citeturn0search24 |

---

## 📌 Example Configuration Snippets

### `.clang-format` for C/C++/C#

```yaml
IndentWidth: 2
```

### `rustfmt.toml` for Rust

```toml
tab_spaces = 2
```

### `.rubocop.yml` for Ruby

```yaml
Layout/IndentationWidth:
  Width: 2
```

### `.php_cs.dist` for PHP

```php
return PhpCsFixer\Config::create()
    ->setIndent("  ");
```

### CLI for `shfmt` (Bash)

```bash
shfmt -i 2 -w script.sh
```

---
