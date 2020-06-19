cask 'alacritty' do
  version '0.4.3'
  sha256 '89f6acc094cece79734be3e56e0cdcf1d5525fdba3429b979e744e36418577fb'

  url "https://github.com/alacritty/alacritty/releases/download/v#{version}/Alacritty-v#{version}.dmg"
  appcast 'https://github.com/alacritty/alacritty/releases.atom'
  name 'Alacritty'
  homepage 'https://github.com/alacritty/alacritty/'

  app 'Alacritty.app'
  binary "#{appdir}/Alacritty.app/Contents/MacOS/alacritty"
  
  postflight do
    system_command 'gzip -c #{appdir}/Alacritty.app/Contents/Resources/alacritty.man > #{HOMEBREW_PREFIX}/share/man/man1/alacritty.1.gz'
    system_command 'tic -xe alacritty,alacritty-direct #{appdir}/Alacritty.app/Contents/Resources/alacritty.info'
    FileUtils.mv('#{appdir}/Alacirtty.app/Contents/Resources/completitions/alacritty.bash', '#{HOMEBREW_PREFIX}/etc/bash_completion.d/alacritty')
    FileUtils.mv('#{appdir}/Alacirtty.app/Contents/Resources/completitions/_alacritty', '#{HOMEBREW_PREFIX}/share/zsh/site-functions/_alacritty')
    FileUtils.mv('#{appdir}/Alacirtty.app/Contents/Resources/completitions/alacritty.fish', '#{HOMEBREW_PREFIX}#{HOMEBREW_PREFIX}/share/fish/vendor_completions.d/alacritty')
  end
  
  uninstall delete: [
    '#{HOMEBREW_PREFIX}/share/man/man1/alacritty.1.gz',
    '#{HOMEBREW_PREFIX}/etc/bash_completion.d/alacritty',
    '#{HOMEBREW_PREFIX}/share/zsh/site-functions/_alacritty',
    '#{HOMEBREW_PREFIX}/share/fish/vendor_completions.d/alacritty',    
                    ]
  
  zap delete: [
                '~/Library/Saved Application State/io.alacritty.savedState',
                '~/.terminfo/61/alacritty',
              ]
  
  caveats do
    files_in_usr_local
  end
end
