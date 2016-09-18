function fish_right_prompt

  set -l cyan (set_color -o cyan)
  set -l yellow (set_color -o yellow)
  set -l red (set_color -o red)
  set -l blue (set_color -o blue)
  set -l normal (set_color normal)

  set -l duration ""
  if test -n "$CMD_DURATION"

    if test $CMD_DURATION -gt 60000
      set duration " ~"(printf "%.1fm " (math "$CMD_DURATION / 60000"))
    else if test $CMD_DURATION -gt 1000
      set duration " ~"(printf "%.1fs " (math "$CMD_DURATION / 1000"))
    end

  end

  echo -n $yellow$duration$red"δ » Δ | λ » Λ" $cyan(date +%H:%M:%S)

end
