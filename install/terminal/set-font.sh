mkdir -p ~/.local/share/fonts/
unzip JetBrainsMono.zip -d ~/.local/share/fonts
fc-cache -f -v
echo "Set the JetBrainsMono font on terminal manually by changing settings"
