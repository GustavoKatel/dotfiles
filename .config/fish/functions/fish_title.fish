function fish_title
  switch $_
  case 'fish'
    echo (uname -n)" ‐ "(whoami)" ― "(basename $PWD)(begin
        test -n "$HOSTNAME"; and echo " — $HOSTNAME"; or echo ""
      end)
  case '*'
    echo $argv[1](begin
        test -n "$HOSTNAME"; and echo " — $HOSTNAME"; or echo ""
      end)
  end
end
