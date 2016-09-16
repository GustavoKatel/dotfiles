function fish_right_prompt

  set -l cyan (set_color -o cyan)
  set -l yellow (set_color -o yellow)
  set -l red (set_color -o red)
  set -l blue (set_color -o blue)
  set -l normal (set_color normal)

  set -l duration ""
  if test $CMD_DURATION -gt 1000
    set duration " ~"(printf "%.1fs " (math "$CMD_DURATION / 1000"))" | "
  end

  echo -n $yellow$duration $red"δ » Δ | λ » Λ" $normal(date +%H:%M:%S)

end
