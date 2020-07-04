cask 'alacritty' do
  version '0.4.?'
  sha256 '???'

  url "https://github.com/alacritty/alacritty/releases/download/v#{version}/Alacritty-v#{version}.dmg"
  appcast 'https://github.com/alacritty/alacritty/releases.atom'
  name 'Alacritty'
  homepage 'https://github.com/alacritty/alacritty/'

  app 'Alacritty.app'
  # shim script (https://github.com/Homebrew/homebrew-cask/issues/18809)
  shimscript = "#{staged_path}/alacritty.wrapper.sh"
  binary shimscript, target: 'alacritty'

  preflight do
    IO.write shimscript, <<~EOS
      #!/bin/sh
      exec '#{appdir}/Alacritty.app/Contents/MacOS/alacritty' "$@"
    EOS
  end

  postflight do
    home_terminfo_dir = '#{ENV['HOME']}/.terminfo/61'
    app_extras_dir = '#{appdir}/Alacritty.app/Contents/Resources'
    FileUtils.mkdir_p(home_terminfo_dir)
    FileUtils.ln_sf('#{app_extras_dir}/61/alacritty', '#{home_terminfo_dir}/alacritty')
    FileUtils.ln_sf('#{app_extras_dir}/61/alacritty-direct', '#{home_terminfo_dir}/alacritty-direct')
    FileUtils.ln_sf('#{app_extras_dir}/completitions/alacritty.bash', '#{HOMEBREW_PREFIX}/etc/bash_completion.d/alacritty')
    FileUtils.ln_sf('#{app_extras_dir}/completitions/_alacritty', '#{HOMEBREW_PREFIX}/share/zsh/site-functions/_alacritty')
    FileUtils.ln_sf('#{app_extras_dir}/completitions/alacritty.fish', '#{HOMEBREW_PREFIX}#{HOMEBREW_PREFIX}/share/fish/vendor_completions.d/alacritty')
    FileUtils.ln_sf('#{app_extras_dir}/alacritty.1.gz', '#{HOMEBREW_PREFIX}/share/man/man1/alacritty.1.gz')
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
