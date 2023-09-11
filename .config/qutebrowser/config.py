
# Load settings configured via autoconfig.yml
config.load_autoconfig(False)

config.set('content.cookies.accept', 'all', 'chrome-devtools://*')
config.set('content.cookies.accept', 'all', 'devtools://*')

config.set('content.headers.accept_language', '', 'https://matchmaker.krunker.io/*')

config.set('content.headers.user_agent', 'Mozilla/5.0 ({os_info}) AppleWebKit/{webkit_version} (KHTML, like Gecko) {upstream_browser_key}/{upstream_browser_version} Safari/{webkit_version}', 'https://web.whatsapp.com/')

config.set('content.headers.user_agent', 'Mozilla/5.0 ({os_info}; rv:90.0) Gecko/20100101 Firefox/90.0', 'https://accounts.google.com/*')

config.set('content.headers.user_agent', 'Mozilla/5.0 ({os_info}) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/99 Safari/537.36', 'https://*.slack.com/*')

config.set('content.images', True, 'chrome-devtools://*')
config.set('content.images', True, 'devtools://*')
config.set('content.javascript.enabled', True, 'chrome-devtools://*')
config.set('content.javascript.enabled', True, 'devtools://*')
config.set('content.javascript.enabled', True, 'chrome://*/*')
config.set('content.javascript.enabled', True, 'qute://*/*')

# config.set("colors.webpage.darkmode.enabled", True)
c.downloads.location.directory = '~/Downloads'
c.tabs.show = 'multiple'

# Disable window decorations
c.window.hide_decoration = True

c.fonts.default_family = '"Hack"'
c.fonts.default_size = '17pt'
c.zoom.default = '135'
c.url.default_page = ''
c.url.start_pages = ''


c.url.searchengines = {'DEFAULT': 'https://duckduckgo.com/?q={}', 
                       'am': 'https://www.amazon.com/s?k={}', 
                       'aw': 'https://wiki.archlinux.org/?search={}', 
                       'goog': 'https://www.google.com/search?q={}', 
                       'hoog': 'https://hoogle.haskell.org/?hoogle={}', 
                       're': 'https://www.reddit.com/r/{}', 
                       'ub': 'https://www.urbandictionary.com/define.php?term={}', 
                       'wiki': 'https://en.wikipedia.org/wiki/{}', 
                       'yt': 'https://www.youtube.com/results?search_query={}'}


# Bindings for normal mode
# config.bind('M', 'hint links spawn mpv {hint-url}')
# config.bind('Z', 'hint links spawn st -e youtube-dl {hint-url}')
# config.bind('t', 'set-cmd-text -s :open -t')
config.bind('xb', 'config-cycle statusbar.show always never')
config.bind('xt', 'config-cycle tabs.show always never')
config.bind('xx', 'config-cycle statusbar.show always never;; config-cycle tabs.show always never')

config.bind('\\1', 'tab-focus 1')
config.bind('\\2', 'tab-focus 2')
config.bind('\\3', 'tab-focus 3')
config.bind('\\4', 'tab-focus 4')
config.bind('\\5', 'tab-focus 5')
config.bind('\\6', 'tab-focus 6')
config.bind('\\7', 'tab-focus 7')
config.bind('\\8', 'tab-focus 8')
# config.bind('\\9', 'tab-focus 9')

# Bindings for cycling through CSS stylesheets from Solarized Everything CSS:
# https://github.com/alphapapa/solarized-everything-css
# config.bind(',ap', 'config-cycle content.user_stylesheets ~/.config/qutebrowser/solarized-everything-css/css/apprentice/apprentice-all-sites.css ""')
# config.bind(',dr', 'config-cycle content.user_stylesheets ~/.config/qutebrowser/solarized-everything-css/css/darculized/darculized-all-sites.css ""')
# config.bind(',gr', 'config-cycle content.user_stylesheets ~/.config/qutebrowser/solarized-everything-css/css/gruvbox/gruvbox-all-sites.css ""')
# config.bind(',sd', 'config-cycle content.user_stylesheets ~/.config/qutebrowser/solarized-everything-css/css/solarized-dark/solarized-dark-all-sites.css ""')
# config.bind(',sl', 'config-cycle content.user_stylesheets ~/.config/qutebrowser/solarized-everything-css/css/solarized-light/solarized-light-all-sites.css ""')


c.colors.completion.fg = ['#9cc4ff', 'white', 'white']
c.colors.completion.odd.bg = '#1c1f24'
c.colors.completion.even.bg = '#232429'
c.colors.completion.category.fg = '#e1acff'
c.colors.completion.category.bg = 'qlineargradient(x1:0, y1:0, x2:0, y2:1, stop:0 #000000, stop:1 #232429)'
c.colors.completion.category.border.top = '#3f4147'
c.colors.completion.category.border.bottom = '#3f4147'
c.colors.completion.item.selected.fg = '#282c34'
c.colors.completion.item.selected.bg = '#ecbe7b'
c.colors.completion.item.selected.match.fg = '#c678dd'
c.colors.completion.match.fg = '#c678dd'
c.colors.completion.scrollbar.fg = 'white'
c.colors.downloads.bar.bg = '#282c34'
c.colors.downloads.error.bg = '#ff6c6b'
c.colors.hints.fg = '#282c34'
c.colors.hints.match.fg = '#98be65'
c.colors.messages.info.bg = '#282c34'
c.colors.statusbar.normal.bg = '#282c34'
c.colors.statusbar.insert.fg = 'white'
c.colors.statusbar.insert.bg = '#497920'
c.colors.statusbar.passthrough.bg = '#34426f'
c.colors.statusbar.command.bg = '#282c34'
c.colors.statusbar.url.warn.fg = 'yellow'
c.colors.tabs.bar.bg = '#1c1f34'
c.colors.tabs.odd.bg = '#282c34'
c.colors.tabs.even.bg = '#282c34'
c.colors.tabs.selected.odd.bg = '#1050b0'
c.colors.tabs.selected.even.bg = '#1050b0'
c.colors.tabs.pinned.odd.bg = 'seagreen'
c.colors.tabs.pinned.even.bg = 'darkseagreen'
c.colors.tabs.pinned.selected.odd.bg = '#282c34'
c.colors.tabs.pinned.selected.even.bg = '#282c34'

