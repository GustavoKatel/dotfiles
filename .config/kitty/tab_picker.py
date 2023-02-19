# pyright: reportMissingImports=false
from typing import List, Any, Dict
from kitty.boss import Boss
from kitty.fast_data_types import get_boss
from kittens.tui.handler import result_handler
import subprocess
import sys

FOLDERS_TO_SEARCH = [ "~/dev", "~/Development" ]

def main(args: List[str]):
    command = [ "fd", "--type", "d", "--max-depth", "1", "''" ]

    command.extend(FOLDERS_TO_SEARCH)

    command.append(" | fzf")

    result = subprocess.run([ " ".join(command) ], shell=True, stdout=subprocess.PIPE, stderr=sys.stderr)

    return result.stdout.decode('utf-8').strip()

@result_handler()
def handle_result(args: List[str], selected_folder: str, target_window_id: int, boss: Boss) -> None:
    w = boss.window_id_map.get(target_window_id)
    if w is not None and selected_folder:
        boss.call_remote_control(w, ('launch', '--type', 'tab', '--cwd='+selected_folder))

