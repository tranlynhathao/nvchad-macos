---@type NvPluginSpec
return {
  "DaikyXendo/nvim-web-devicons",
  config = function()
    require("nvim-web-devicons").setup {
      override = {
        zsh = {
          icon = "",
          color = "#428850",
          cterm_color = "65",
          name = "Zsh",
        },
        -- ["pl"] = {
        --   icon = "🐪",
        --   color = "#3178c6",
        --   cterm_color = "74",
        --   name = "Perl",
        -- },
        ["prolog"] = {
          icon = "",
          color = "#A074C4",
          cterm_color = "140",
          name = "Prolog",
        },
        ["pl"] = {
          icon = "",
          color = "#A074C4",
          cterm_color = "140",
          name = "PrologFile",
        },
        ["pug"] = {
          icon = "",
          color = "#a86454",
          cterm_color = "65",
          name = "Pug",
        },
        ["rb"] = {
          icon = "",
          color = "#f50707",
          cterm_color = "167",
          name = "Ruby",
        },
        ["Makefile"] = {
          icon = "",
          color = "#6d8086",
          cterm_color = "66",
          name = "Makefile",
        },
        ["netlify.toml"] = {
          icon = "",
          color = "#15847c",
          cterm_color = "29",
          name = "Netlify",
        },
        [".all-contributorsrc"] = {
          icon = "",
          color = "#ffcc00",
          cterm_color = "220",
          name = "AllContributors",
        },
        [".parcelrc"] = {
          icon = "",
          color = "#f8b400",
          cterm_color = "214",
          name = "ParcelRC",
        },
        ["yaml"] = {
          icon = "",
          color = "#cb171e",
          cterm_color = "160",
          name = "Yaml",
        },
        ["yml"] = {
          icon = "",
          color = "#cb171e",
          cterm_color = "160",
          name = "Yml",
        },
        ["alloy"] = {
          icon = "",
          color = "#f9ae58",
          cterm_color = "215",
          name = "Alloy",
        },
        ["ini"] = {
          icon = "",
          color = "#6d8086",
          cterm_color = "66",
          name = "Ini",
        },
        ["toml"] = {
          icon = "",
          color = "#9c4221",
          cterm_color = "130",
          name = "Toml",
        },

        -- Xcode project & workspace
        ["xcodeproj"] = {
          icon = "",
          color = "#147efb",
          cterm_color = "33",
          name = "XcodeProj",
        },
        ["xcworkspace"] = {
          icon = "",
          color = "#147efb",
          cterm_color = "33",
          name = "Xcworkspace",
        },

        -- Interface Builder
        ["storyboard"] = {
          icon = "",
          color = "#ffb86c",
          cterm_color = "215",
          name = "Storyboard",
        },
        ["xib"] = {
          icon = "",
          color = "#fab387",
          cterm_color = "215",
          name = "XIB",
        },

        -- SwiftUI preview
        ["preview"] = {
          icon = "",
          color = "#f05138",
          cterm_color = "202",
          name = "Preview",
        },

        -- Asset Catalog
        ["xcassets"] = {
          icon = "",
          color = "#ffcb6b",
          cterm_color = "221",
          name = "Xcassets",
        },
        ["imageset"] = {
          icon = "",
          color = "#c792ea",
          cterm_color = "141",
          name = "Imageset",
        },

        -- CocoaPods
        ["podspec"] = {
          icon = "",
          color = "#c43e3e",
          cterm_color = "160",
          name = "Podspec",
        },
        ["lock"] = {
          icon = "",
          color = "#6d8086",
          cterm_color = "66",
          name = "Lock",
        },
        ["Podfile"] = {
          icon = "",
          color = "#c43e3e",
          cterm_color = "160",
          name = "Podfile",
        },
        ["Podfile.lock"] = {
          icon = "",
          color = "#6d8086",
          cterm_color = "66",
          name = "PodfileLock",
        },

        -- Package Manager: SwiftPM
        ["Package.swift"] = {
          icon = "",
          color = "#f05138",
          cterm_color = "202",
          name = "PackageSwift",
        },

        -- Config & Build
        ["plist"] = {
          icon = "",
          color = "#ffcc00",
          cterm_color = "220",
          name = "Plist",
        },
        ["xcconfig"] = {
          icon = "",
          color = "#ffd700",
          cterm_color = "220",
          name = "Xcconfig",
        },

        -- Certificates & Entitlements
        ["entitlements"] = {
          icon = "",
          color = "#ffb86c",
          cterm_color = "215",
          name = "Entitlements",
        },
        ["mobileprovision"] = {
          icon = "󰀀",
          color = "#ffcc00",
          cterm_color = "220",
          name = "Provisioning",
        },

        -- Env
        -- ["env"] = {
        --   icon = "",
        --   color = "#6d8086",
        --   cterm_color = "66",
        --   name = "Env",
        -- },
        -- [".env"] = {
        --   icon = "",
        --   color = "#6d8086",
        --   cterm_color = "66",
        --   name = "DotEnv",
        -- },
      },
      color_icons = true,
      default = true,
    }
  end,
}
