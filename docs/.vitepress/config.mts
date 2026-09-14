import { defineConfig } from 'vitepress'

export default defineConfig({
  title: 'Godot ATT iOS',
  description: 'Official-grade Apple App Tracking Transparency (ATT) plugin for Godot 4.6+ on iOS',
  base: '/',
  cleanUrls: true,
  themeConfig: {
    logo: '/icon.svg',
    nav: [
      { text: 'Guide', link: '/guide/getting-started' },
      { text: 'API & Usage', link: '/guide/usage' },
      { text: 'iOS Export', link: '/guide/ios-export' },
      { text: 'GitHub', link: 'https://github.com/Poing-Studios/godot-att-ios' }
    ],
    sidebar: [
      {
        text: 'Getting Started',
        items: [
          { text: 'Introduction', link: '/guide/introduction' },
          { text: 'Quickstart & Installation', link: '/guide/getting-started' },
          { text: 'Testing & Gotchas', link: '/guide/testing-notes' }
        ]
      },
      {
        text: 'API Reference',
        items: [
          { text: 'Usage & Signals', link: '/guide/usage' },
          { text: 'Status Enum Reference', link: '/guide/status-enum' }
        ]
      },
      {
        text: 'Deployment & Build',
        items: [
          { text: 'iOS Export Setup', link: '/guide/ios-export' },
          { text: 'Building from Source', link: '/guide/building-from-source' }
        ]
      }
    ],
    search: {
      provider: 'local'
    },
    socialLinks: [
      { icon: 'github', link: 'https://github.com/Poing-Studios/godot-att-ios' }
    ],
    footer: {
      message: 'Released under the MIT License.',
      copyright: 'Copyright © 2026-present Poing Studios'
    }
  }
})
